
#!/bin/bash
echo "🚀 Iniciando Hydrus Server..."
echo ""

# Navegar para diretório do app
cd ~/hydrus/app || { echo "❌ Diretório app não encontrado"; exit 1; }

# Verificar ambiente virtual
if [ ! -d "venv" ]; then
    echo "🔧 Criando ambiente virtual..."
    python3 -m venv venv
fi

# Ativar ambiente virtual
echo "🐍 Ativando ambiente virtual..."
source venv/bin/activate || { echo "❌ Falha ao ativar venv"; exit 1; }

# Instalar dependências se necessário
echo "📦 Verificando dependências..."
if ! python -c "import flask" 2>/dev/null; then
    echo "   Instalando Flask..."
    pip install flask==2.3.3
fi

if ! python -c "import psutil" 2>/dev/null; then
    echo "   Instalando psutil (para métricas avançadas)..."
    pip install psutil
fi

# Verificar porta
echo "🔌 Verificando porta 5000..."
if lsof -i :5000 > /dev/null 2>&1; then
    echo "   ⚠️  Porta 5000 ocupada. Liberando..."
    sudo fuser -k 5000/tcp 2>/dev/null
    sleep 2
fi

# Iniciar servidor
echo ""
echo "═══════════════════════════════════════════════"
echo "          HYDRUS SERVER INICIANDO"
echo "═══════════════════════════════════════════════"
echo ""
echo "📊 URLs de acesso:"
echo "   • Dashboard: http://localhost:5000/health"
echo "   • API JSON:  http://localhost:5000/health/json"
echo "   • Home:      http://localhost:5000"
echo ""
echo "🌐 Acesso pela rede:"
IP=$(hostname -I | awk '{print $1}')
echo "   • http://$IP:5000/health"
echo ""
echo "🛑 Pressione Ctrl+C para parar o servidor"
echo ""

# Executar app
python app.py