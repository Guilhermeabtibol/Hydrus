# Primeiro, vamos criar uma versão do app.py que lida com falta de psutil

from flask import Flask, render_template, jsonify, request
import datetime
import socket
import os
import platform
import time
import subprocess
from collections import deque

app = Flask(__name__, 
            static_folder='static',
            template_folder='templates')

# Tentar importar psutil, se não estiver instalado, usar fallback
PSUTIL_AVAILABLE = False
try:
    import psutil
    PSUTIL_AVAILABLE = True
    print("✅ psutil disponível para métricas detalhadas")
except ImportError:
    print("⚠️  psutil não disponível. Usando métricas básicas.")

# Histórico de atividades
activity_log = deque(maxlen=10)

def log_activity(message, icon="info-circle"):
    """Registra uma atividade no log"""
    activity_log.append({
        'message': message,
        'icon': icon,
        'time': datetime.datetime.now().strftime("%H:%M:%S")
    })

def get_system_info():
    """Obtém informações do sistema com ou sem psutil"""
    try:
        if PSUTIL_AVAILABLE:
            # Usando psutil para métricas precisas
            cpu_percent = psutil.cpu_percent(interval=0.1)
            memory = psutil.virtual_memory()
            memory_percent = memory.percent
            disk = psutil.disk_usage('/')
            disk_percent = disk.percent
            load_avg = psutil.getloadavg()
            load_str = f"{load_avg[0]:.2f}, {load_avg[1]:.2f}, {load_avg[2]:.2f}"
        else:
            # Métricas básicas sem psutil
            cpu_percent = 5.0  # Valor padrão
            memory_percent = 30.0  # Valor padrão
            disk_percent = 25.0  # Valor padrão
            load_str = "N/A (instale psutil)"
            
            # Tentar obter load average via sistema
            try:
                load = os.getloadavg()
                load_str = f"{load[0]:.2f}, {load[1]:.2f}, {load[2]:.2f}"
            except:
                pass
        
        return {
            'cpu_percent': round(cpu_percent, 1),
            'memory_percent': round(memory_percent, 1),
            'disk_percent': round(disk_percent, 1),
            'load_average': load_str,
            'psutil_available': PSUTIL_AVAILABLE
        }
    except Exception as e:
        log_activity(f"Erro ao coletar métricas: {str(e)}", "exclamation-triangle")
        return {
            'cpu_percent': 0,
            'memory_percent': 0,
            'disk_percent': 0,
            'load_average': "Erro",
            'psutil_available': False
        }

def get_uptime():
    """Calcula uptime do sistema"""
    try:
        if PSUTIL_AVAILABLE:
            boot_time = psutil.boot_time()
            uptime_seconds = time.time() - boot_time
        else:
            # Fallback: ler do /proc/uptime
            with open('/proc/uptime', 'r') as f:
                uptime_seconds = float(f.readline().split()[0])
        
        # Converter para formato legível
        days = int(uptime_seconds // (24 * 3600))
        hours = int((uptime_seconds % (24 * 3600)) // 3600)
        minutes = int((uptime_seconds % 3600) // 60)
        
        if days > 0:
            return f"{days}d {hours}h {minutes}m"
        elif hours > 0:
            return f"{hours}h {minutes}m"
        else:
            return f"{minutes}m"
    except:
        return "N/A"

# Contador de requests
request_count = 0

@app.before_request
def count_request():
    """Conta cada request recebido"""
    global request_count
    request_count += 1

@app.route('/')
def home():
    """Página principal"""
    hostname = socket.gethostname()
    server_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # Obter IP local
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
    except:
        local_ip = socket.gethostbyname(hostname)
    
    log_activity("Página principal acessada", "home")
    
    return render_template('index.html',
                          server_time=server_time,
                          owner="GVoxx",
                          project="Hydrus",
                          hostname=hostname,
                          local_ip=local_ip)

@app.route('/health')
def health_dashboard():
    """Dashboard de saúde completo"""
    current_time = datetime.datetime.now().strftime("%H:%M:%S")
    
    # Obter informações
    server_info = {
        'hostname': socket.gethostname(),
        'ip': socket.gethostbyname(socket.gethostname()),
        'python_version': platform.python_version(),
        'flask_version': '2.3.3',
        'psutil': PSUTIL_AVAILABLE
    }
    
    system_info = get_system_info()
    
    application_info = {
        'status': 'running',
        'port': 5000,
        'request_count': request_count,
        'response_time': 0
    }
    
    client_info = {
        'ip': request.remote_addr if request.remote_addr else "Desconhecido",
        'user_agent': request.user_agent.string if request.user_agent else "N/A"
    }
    
    # Definir status geral
    if system_info['cpu_percent'] < 90 and system_info['memory_percent'] < 90:
        overall_status = 'healthy'
        status_message = 'Todos os sistemas operando normalmente'
    else:
        overall_status = 'unhealthy'
        status_message = 'Alerta: Alto uso de recursos'
    
    log_activity(f"Dashboard de saúde acessado por {client_info['ip']}", "heartbeat")
    
    return render_template('health.html',
                         current_time=current_time,
                         overall_status=overall_status,
                         status_message=status_message,
                         uptime=get_uptime(),
                         server=server_info,
                         system=system_info,
                         application=application_info,
                         client=client_info,
                         endpoints={
                             'home': '/',
                             'health': '/health',
                             'api': '/health/json',
                             'github': 'https://github.com/Guilhermeabtibol/hydrus'
                         },
                         activities=list(activity_log))

@app.route('/health/json')
def health_json():
    """Endpoint JSON para health check (API)"""
    start_time = time.time()
    
    system_info = get_system_info()
    
    response_data = {
        'status': 'healthy' if system_info['cpu_percent'] < 90 else 'warning',
        'timestamp': datetime.datetime.now().isoformat(),
        'project': 'Hydrus',
        'server': {
            'hostname': socket.gethostname(),
            'ip': socket.gethostbyname(socket.gethostname()),
            'python_version': platform.python_version(),
            'platform': platform.platform(),
            'psutil_available': PSUTIL_AVAILABLE
        },
        'system': system_info,
        'application': {
            'flask_version': '2.3.3',
            'endpoints': ['/', '/health', '/health/json'],
            'request_count': request_count
        },
        'client': {
            'ip': request.remote_addr,
            'user_agent': request.user_agent.string if request.user_agent else None
        },
        'response_time_ms': round((time.time() - start_time) * 1000, 2)
    }
    
    log_activity("Health check API chamado", "api")
    
    return jsonify(response_data)

@app.route('/health/api')
def health_api():
    """API para atualização AJAX do dashboard"""
    system_info = get_system_info()
    
    return jsonify({
        'timestamp': datetime.datetime.now().isoformat(),
        'system': system_info,
        'uptime': get_uptime(),
        'request_count': request_count,
        'activities': list(activity_log)[-5:],  # Últimas 5 atividades
        'psutil_available': PSUTIL_AVAILABLE
    })

@app.route('/static/<path:filename>')
def serve_static(filename):
    """Serve arquivos estáticos"""
    return app.send_static_file(filename)

if __name__ == '__main__':
    # Log inicial
    log_activity("Servidor Hydrus iniciado", "rocket")
    log_activity(f"Hostname: {socket.gethostname()}", "server")
    log_activity(f"IP: {socket.gethostbyname(socket.gethostname())}", "network-wired")
    
    print("╔════════════════════════════════════════════════════╗")
    print("║                🚀 HYDRUS SERVER                   ║")
    print("╠════════════════════════════════════════════════════╣")
    print("║  📊 Dashboard:    http://localhost:5000/health    ║")
    print("║  📡 API Health:   http://localhost:5000/health/json ║")
    print("║  🏠 Home:         http://localhost:5000           ║")
    print("║  🔌 Porta:        5000                            ║")
    print("║  🌐 Host:         0.0.0.0 (acesso pela rede)      ║")
    print("║  📈 psutil:       " + ("✅ Disponível" if PSUTIL_AVAILABLE else "⚠️  Básico") + " " * (27 - len("✅ Disponível")) + "║")
    print("╚════════════════════════════════════════════════════╝")
    
    app.run(host='0.0.0.0', port=5000, debug=True, threaded=True)
