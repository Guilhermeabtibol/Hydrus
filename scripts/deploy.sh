#!/bin/bash
# Script de deploy automatizado - VERSÃO CORRIGIDA

PROJECT_NAME="hydrus"
HOME_DIR="/home/gvoxx"
PROJECT_DIR="$HOME_DIR/$PROJECT_NAME"
LOG_DIR="$PROJECT_DIR/logs"
APP_DIR="$PROJECT_DIR/app"
LOG_FILE="$LOG_DIR/deploy.log"
VENV_DIR="$APP_DIR/venv"

# Criar diretório de logs se não existir
mkdir -p $LOG_DIR

echo "=== Iniciando deploy do projeto $PROJECT_NAME em $(date) ===" | tee -a $LOG_FILE

# 1. Verificar se o diretório app existe
if [ ! -d "$APP_DIR" ]; then
    echo "❌ ERRO: Diretório $APP_DIR não encontrado!" | tee -a $LOG_FILE
    echo "Criando estrutura básica..." | tee -a $LOG_FILE
    mkdir -p $APP_DIR
    mkdir -p $APP_DIR/templates
    mkdir -p $APP_DIR/static
fi

# 2. Criar/atualizar ambiente virtual
echo "Verificando ambiente virtual..." | tee -a $LOG_FILE
if [ ! -d "$VENV_DIR" ]; then
    echo "Criando ambiente virtual..." | tee -a $LOG_FILE
    python3 -m venv $VENV_DIR 2>&1 | tee -a $LOG_FILE
    
    if [ $? -eq 0 ]; then
        echo "✅ Ambiente virtual criado com sucesso" | tee -a $LOG_FILE
    else
        echo "❌ Falha ao criar ambiente virtual" | tee -a $LOG_FILE
        exit 1
    fi
fi

# 3. Ativar ambiente virtual e instalar dependências
echo "Instalando/atualizando dependências..." | tee -a $LOG_FILE
source $VENV_DIR/bin/activate

# Verificar se requirements.txt existe
if [ -f "$APP_DIR/requirements.txt" ]; then
    pip install --upgrade pip 2>&1 | tee -a $LOG_FILE
    pip install -r $APP_DIR/requirements.txt 2>&1 | tee -a $LOG_FILE
else
    echo "⚠️  Arquivo requirements.txt não encontrado. Criando básico..." | tee -a $LOG_FILE
    echo "Flask==2.3.3" > $APP_DIR/requirements.txt
    pip install Flask==2.3.3 2>&1 | tee -a $LOG_FILE
fi

# 4. Verificar se app.py existe
if [ ! -f "$APP_DIR/app.py" ]; then
    echo "⚠️  Arquivo app.py não encontrado. Criando aplicação básica..." | tee -a $LOG_FILE
    
    # Criar app.py básico
    cat > $APP_DIR/app.py << 'EOF'
from flask import Flask, render_template
import datetime

app = Flask(__name__)

@app.route('/')
def home():
    server_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return render_template('index.html', 
                          server_time=server_time,
                          owner="GVoxx",
                          project="Hydrus")

@app.route('/health')
def health():
    return {'status': 'healthy', 
            'project': 'Hydrus',
            'timestamp': datetime.datetime.now().isoformat()}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
EOF

    # Criar template básico
    mkdir -p $APP_DIR/templates
    cat > $APP_DIR/templates/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Hydrus - Projeto do GVoxx</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 3px solid #4CAF50;
            padding-bottom: 15px;
        }
        .info-box {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin: 25px 0;
            border-left: 4px solid #4CAF50;
        }
        .status {
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
        }
        .project-name {
            color: #764ba2;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Projeto <span class="project-name">Hydrus</span> - DevOps GVoxx</h1>
        <p>Bem-vindo ao meu projeto de aprendizado DevOps!</p>
        
        <div class="info-box">
            <p><strong>👤 Proprietário:</strong> {{ owner }}</p>
            <p><strong>📁 Projeto:</strong> {{ project }}</p>
            <p><strong>🕐 Hora do servidor:</strong> {{ server_time }}</p>
            <p><strong>🌐 Hostname:</strong> {{ hostname }}</p>
        </div>
        
        <div class="status">
            <p>✅ Sistema operacional normalmente</p>
            <p>✅ Deploy automatizado funcionando</p>
            <p>✅ DevOps em aprendizado contínuo!</p>
        </div>
    </div>
</body>
</html>
EOF
fi

# 5. Atualizar app.py para incluir hostname
if [ -f "$APP_DIR/app.py" ]; then
    # Verificar se já tem import socket
    if ! grep -q "import socket" "$APP_DIR/app.py"; then
        sed -i '1s/^/import socket\n/' "$APP_DIR/app.py"
    fi
    
    # Atualizar a função home para incluir hostname
    sed -i "s/def home():/def home():\n    hostname = socket.gethostname()/" "$APP_DIR/app.py"
    sed -i "s/render_template('index.html', /render_template('index.html', hostname=hostname, /g" "$APP_DIR/app.py"
fi

# 6. Gerenciar serviço systemd
SERVICE_NAME="hydrus-app"
echo "Configurando serviço systemd..." | tee -a $LOG_FILE

# Criar arquivo de serviço
sudo tee /etc/systemd/system/$SERVICE_NAME.service > /dev/null << EOF
[Unit]
Description=Aplicação Hydrus do GVoxx
After=network.target

[Service]
User=gvoxx
Group=gvoxx
WorkingDirectory=$APP_DIR
Environment="PATH=$VENV_DIR/bin"
ExecStart=$VENV_DIR/bin/python app.py
Restart=always
RestartSec=10
StandardOutput=append:$LOG_DIR/app.log
StandardError=append:$LOG_DIR/app.error.log

[Install]
WantedBy=multi-user.target
EOF

# 7. Parar/iniciar serviço
echo "Gerenciando serviço..." | tee -a $LOG_FILE
sudo systemctl daemon-reload

if systemctl is-active --quiet $SERVICE_NAME; then
    echo "Parando serviço anterior..." | tee -a $LOG_FILE
    sudo systemctl stop $SERVICE_NAME
fi

echo "Iniciando serviço..." | tee -a $LOG_FILE
sudo systemctl enable $SERVICE_NAME 2>&1 | tee -a $LOG_FILE
sudo systemctl start $SERVICE_NAME 2>&1 | tee -a $LOG_FILE

# 8. Verificar status
sleep 2
SERVICE_STATUS=$(sudo systemctl is-active $SERVICE_NAME)
if [ "$SERVICE_STATUS" = "active" ]; then
    echo "✅ Serviço $SERVICE_NAME está ATIVO" | tee -a $LOG_FILE
    echo "📊 Verifique a aplicação em: http://localhost:5000" | tee -a $LOG_FILE
    echo "📊 Verifique a saúde em: http://localhost:5000/health" | tee -a $LOG_FILE
else
    echo "❌ Serviço $SERVICE_NAME está INATIVO" | tee -a $LOG_FILE
    echo "🔍 Verifique os logs com: sudo journalctl -u $SERVICE_NAME -f" | tee -a $LOG_FILE
fi

echo "Deploy concluído em $(date)" | tee -a $LOG_FILE
echo "=============================" | tee -a $LOG_FILE
