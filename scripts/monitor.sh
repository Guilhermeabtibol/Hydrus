#!/bin/bash
# Script de monitoramento simples - VERSÃO CORRIGIDA

PROJECT_NAME="hydrus"
HOME_DIR="/home/gvoxx"
LOG_DIR="$HOME_DIR/$PROJECT_NAME/logs"
LOG_FILE="$LOG_DIR/monitor.log"
HEALTH_URL="http://localhost:5000/health"

# Criar diretório de logs se não existir
mkdir -p $LOG_DIR

echo "=== Verificação em $(date) ===" >> $LOG_FILE

# Verificar se a aplicação está respondendo
if curl -s --max-time 5 --head $HEALTH_URL > /dev/null 2>&1; then
    echo "✅ Aplicação Hydrus está saudável" >> $LOG_FILE
    
    # Ver detalhes da saúde
    HEALTH_RESPONSE=$(curl -s $HEALTH_URL)
    echo "   Resposta: $HEALTH_RESPONSE" >> $LOG_FILE
else
    echo "❌ Aplicação não está respondendo" >> $LOG_FILE
    
    # Tentar reiniciar
    echo "🔄 Tentando reiniciar serviço..." >> $LOG_FILE
    sudo systemctl restart hydrus-app 2>&1 >> $LOG_FILE
    
    # Verificar se reiniciou
    sleep 3
    if systemctl is-active --quiet hydrus-app; then
        echo "   ✅ Serviço reiniciado com sucesso" >> $LOG_FILE
    else
        echo "   ❌ Falha ao reiniciar serviço" >> $LOG_FILE
    fi
fi

# Verificar uso de sistema
echo "--- Status do Sistema ---" >> $LOG_FILE

# Uso de disco
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5 " usado (" $3 "/" $2 ")"}')
echo "💾 Disco: $DISK_USAGE" >> $LOG_FILE

# Uso de memória
MEM_TOTAL=$(free -h | awk 'NR==2 {print $2}')
MEM_USED=$(free -h | awk 'NR==2 {print $3}')
MEM_PERCENT=$(free | awk 'NR==2 {printf "%.1f%%", $3*100/$2}')
echo "🧠 Memória: $MEM_PERCENT usado ($MEM_USED/$MEM_TOTAL)" >> $LOG_FILE

# CPU load
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}')
echo "⚡ Load Average: $LOAD_AVG" >> $LOG_FILE

# Status do serviço
SERVICE_STATUS=$(systemctl is-active hydrus-app 2>/dev/null || echo "not-found")
echo "🔧 Serviço hydrus-app: $SERVICE_STATUS" >> $LOG_FILE

echo "" >> $LOG_FILE
