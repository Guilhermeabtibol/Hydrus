#!/bin/bash
# Script de backup - VERSÃO CORRIGIDA

PROJECT_NAME="hydrus"
HOME_DIR="/home/gvoxx"
PROJECT_DIR="$HOME_DIR/$PROJECT_NAME"
BACKUP_DIR="$HOME_DIR/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/${PROJECT_NAME}_backup_$DATE.tar.gz"
LOG_DIR="$PROJECT_DIR/logs"
LOG_FILE="$LOG_DIR/backup.log"

# Criar diretórios se não existirem
mkdir -p $BACKUP_DIR
mkdir -p $LOG_DIR

echo "=== Iniciando backup do projeto $PROJECT_NAME em $(date) ===" | tee -a $LOG_FILE

# Verificar se o projeto existe
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ ERRO: Diretório do projeto não encontrado: $PROJECT_DIR" | tee -a $LOG_FILE
    exit 1
fi

# Criar backup
echo "Criando backup..." | tee -a $LOG_FILE
tar -czf $BACKUP_FILE -C $HOME_DIR $PROJECT_NAME 2>&1 | tee -a $LOG_FILE

if [ $? -eq 0 ]; then
    BACKUP_SIZE=$(du -h $BACKUP_FILE | cut -f1)
    echo "✅ Backup criado com sucesso!" | tee -a $LOG_FILE
    echo "   Arquivo: $BACKUP_FILE" | tee -a $LOG_FILE
    echo "   Tamanho: $BACKUP_SIZE" | tee -a $LOG_FILE
else
    echo "❌ Falha ao criar backup" | tee -a $LOG_FILE
    exit 1
fi

# Listar backups existentes
echo "📋 Backups existentes:" | tee -a $LOG_FILE
ls -lh $BACKUP_DIR/${PROJECT_NAME}_backup_*.tar.gz 2>/dev/null | tee -a $LOG_FILE

# Manter apenas últimos 5 backups
echo "🧹 Limpando backups antigos (mantendo últimos 5)..." | tee -a $LOG_FILE
BACKUP_COUNT=$(ls -t $BACKUP_DIR/${PROJECT_NAME}_backup_*.tar.gz 2>/dev/null | wc -l)
if [ $BACKUP_COUNT -gt 5 ]; then
    ls -t $BACKUP_DIR/${PROJECT_NAME}_backup_*.tar.gz | tail -n +6 | while read OLD_BACKUP; do
        echo "   Removendo: $(basename $OLD_BACKUP)" | tee -a $LOG_FILE
        rm -f "$OLD_BACKUP"
    done
fi

echo "Backup concluído em $(date)" | tee -a $LOG_FILE
echo "=============================" | tee -a $LOG_FILE
