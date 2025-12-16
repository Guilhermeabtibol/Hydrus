# 🚀 Hydrus - Projeto DevOps para Iniciantes

<div align="center">
  
  ![Python](https://img.shields.io/badge/Python-3.12-blue?logo=python&logoColor=white)
  ![Flask](https://img.shields.io/badge/Flask-2.3.3-black?logo=flask&logoColor=white)
  ![Linux](https://img.shields.io/badge/Linux-Mint-green?logo=linux&logoColor=white)
  ![GitHub Pages](https://img.shields.io/badge/GitHub-Pages-blue?logo=github&logoColor=white)
  ![License](https://img.shields.io/badge/License-MIT-yellow)
  
  [🌐 Site do Projeto](https://guilhermeabtibol.github.io/hydrus) •
  [📁 Código Fonte](/app) •
  [🐛 Issues](https://github.com/Guilhermeabtibol/hydrus/issues)

  *Projeto educacional para aprender DevOps na prática*
</div>

## 📋 Sobre o Projeto

O **Hydrus** é um projeto prático desenvolvido por **GVoxx (Guilhermeabtibol)** para aprender conceitos fundamentais de DevOps usando Linux Mint. Inclui automação de deploy, monitoramento, script e integração com GitHub.

### ✨ Funcionalidades

- ✅ **Aplicação Web**: Servidor Flask com página dinâmica
- ✅ **Automação**: Scripts Shell para deploy, backup e monitoramento
- ✅ **Service Management**: Configuração como serviço systemd
- ✅ **Monitoramento**: Endpoint de saúde e scripts de verificação
- ✅ **GitHub Integration**: CI/CD básico com GitHub Actions
- ✅ **Documentação**: README completo e páginas de setup

## 🏗️ Arquitetura
hydrus/
├── app/ # Aplicação Flask
│ ├── app.py # Servidor principal
│ ├── requirements.txt # Dependências Python
│ ├── templates/ # Templates HTML
│ └── static/ # Arquivos estáticos (CSS)
├── scripts/ # Scripts de automação
│ ├── deploy.sh # Instalação e configuração
│ ├── monitor.sh # Monitoramento da aplicação
│ └── backup.sh # Backup automatizado
├── docs/ # Documentação
│ └── index.md # Página GitHub Pages
├── logs/ # Logs da aplicação
└── .github/workflows/ # GitHub Actions CI/CD

text

## 🚀 Começando

### Pré-requisitos

- Linux Mint ou distribuição Debian/Ubuntu
- Python 3.8+
- Git
- Nginx (opcional, para proxy reverso)

### Instalação Rápida

# 1. Clone o repositório
git clone https://github.com/Guilhermeabtibol/hydrus.git
cd hydrus

# 2. Dê permissão aos scripts
chmod +x scripts/*.sh

# 3. Execute o deploy automático
./scripts/deploy.sh

# 4. Acesse a aplicação
curl http://localhost:5000
# Ou abra no navegador: http://localhost:5000
Testando a Aplicação
bash
# Verificar status da saúde
curl http://localhost:5000/health

# Verificar logs
sudo journalctl -u hydrus-app -f

# Monitorar recursos
./scripts/monitor.sh
📊 Dashboard e Monitoramento
A aplicação inclui um dashboard básico com:

Status do servidor em tempo real

Informações do sistema

Endpoint de saúde para monitoramento

Endpoints Disponíveis
Endpoint	Método	Descrição
/	GET	Página principal do projeto
/health	GET	Status da aplicação (JSON)
🔧 Scripts de Automação
Script	Descrição	Uso
deploy.sh	Instalação completa	./scripts/deploy.sh
monitor.sh	Verifica saúde do sistema	./scripts/monitor.sh
backup.sh	Backup do projeto	./scripts/backup.sh
Configuração do Systemd
O projeto configura automaticamente um serviço systemd:

bash
# Comandos úteis
sudo systemctl status hydrus-app    # Verificar status
sudo systemctl restart hydrus-app   # Reiniciar serviço
sudo journalctl -u hydrus-app -f    # Ver logs em tempo real
🌐 Configuração Nginx (Opcional)
Para expor a aplicação na porta 80:

bash
# Instalar Nginx
sudo apt install nginx

# Configurar site
sudo cp nginx-config/hydrus.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/hydrus /etc/nginx/sites-enabled/
sudo systemctl restart nginx
🐳 Docker (Em Desenvolvimento)
dockerfile
# Dockerfile simplificado
FROM python:3.12-slim
WORKDIR /app
COPY app/requirements.txt .
RUN pip install -r requirements.txt
COPY app/ .
CMD ["python", "app.py"]
📈 GitHub Actions
O projeto inclui workflow básico para CI/CD:

yaml
# .github/workflows/deploy.yml
name: Deploy Check
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Check Python Syntax
        run: python -m py_compile app/app.py
🧪 Testes
Execute os testes básicos:

bash
# Testar sintaxe Python
python -m py_compile app/app.py

# Testar endpoint de saúde
./scripts/monitor.sh

# Verificar estrutura do projeto
tree -I '__pycache__|venv|*.pyc'
📚 Aprendizados DevOps
Este projeto aborda:

Versionamento: Git e GitHub

Automação: Scripts Shell e Systemd

Monitoramento: Logs e health checks

Deploy: Pipelines simples

Infraestrutura: Serviços Linux

🛠️ Solução de Problemas
Erros Comuns
Problema	Solução
Porta 5000 ocupada	sudo lsof -i :5000; sudo kill -9 <PID>
Erro de permissão	chmod +x scripts/*.sh
Módulo não encontrado	cd app && pip install -r requirements.txt
Serviço não inicia	sudo journalctl -u hydrus-app -n 50
Comandos Úteis para Debug
bash
# Verificar se a aplicação está rodando
curl -s http://localhost:5000/health | jq .  # requer jq instalado

# Verificar uso de recursos
./scripts/monitor.sh

# Limpar ambiente
sudo systemctl stop hydrus-app
find . -name "__pycache__" -type d -exec rm -rf {} +
🤝 Contribuindo
Contribuições são bem-vindas! Siga estes passos:

Fork o projeto

Crie uma branch (git checkout -b feature/nova-feat)

Commit suas mudanças (git commit -m 'Add nova feat')

Push para a branch (git push origin feature/nova-feat)

Abra um Pull Request

📄 Licença
Este projeto está sob a licença MIT. Veja o arquivo LICENSE para detalhes.

👨‍💻 Autor
Guilherme Abtibol (GVoxx) - Aprendendo DevOps na prática!

GitHub: @Guilhermeabtibol

Projeto: https://guilhermeabtibol.github.io/hydrus

🌟 Agradecimentos
Linux Mint Community

Flask Documentation

GitHub Education

Todos que compartilham conhecimento sobre DevOps

<div align="center">
⭐ Se este projeto te ajudou, dê uma estrela no repositório!

https://api.star-history.com/svg?repos=Guilhermeabtibol/hydrus&type=Date

</div> EOF
echo "✅ README.md criado!"

text

## 🌐 2. Configurar GitHub Pages

### Passo 2.1: Criar arquivo de configuração do GitHub Pages


# Criar diretório para docs
mkdir -p ~/hydrus/docs

# Criar arquivo principal do GitHub Pages
cat > ~/hydrus/docs/index.md << 'EOF'
---
layout: default
title: Hydrus - Projeto DevOps
description: Projeto prático para aprender DevOps com Linux Mint
---

<div align="center">
  <h1>🚀 Hydrus - DevOps Learning Project</h1>
  <p><strong>Projeto prático de DevOps desenvolvido por GVoxx (Guilherme Abtibol)</strong></p>
  
  <img src="https://img.shields.io/badge/Python-3.12-blue" alt="Python">
  <img src="https://img.shields.io/badge/Linux-Mint-green" alt="Linux Mint">
  <img src="https://img.shields.io/badge/Status-Active-success" alt="Status">
  
  <br><br>
  <a href="https://github.com/Guilhermeabtibol/hydrus" class="btn">📁 Ver Código</a>
  <a href="#getting-started" class="btn">🚀 Começar</a>
</div>

## 🌟 Sobre o Projeto

O **Hydrus** é um projeto educacional desenvolvido para aprender os fundamentos de DevOps através da prática. O projeto inclui:

- ✅ **Aplicação Web** com Flask
- ✅ **Automação** com scripts Shell
- ✅ **Monitoramento** e health checks
- ✅ **Deploy Automatizado**
- ✅ **Integração com GitHub**

### 🎯 Objetivos de Aprendizado

1. **Versionamento de Código** com Git e GitHub
2. **Automação de Infraestrutura** com scripts
3. **Gerenciamento de Serviços** no Linux
4. **Monitoramento Básico** de aplicações
5. **CI/CD** com GitHub Actions

## 📊 Dashboard ao Vivo

<div class="dashboard">
  <div class="card">
    <h3>🖥️ Status do Servidor</h3>
    <div id="server-status">Carregando...</div>
  </div>
  
  <div class="card">
    <h3>📈 Estatísticas</h3>
    <ul>
      <li><strong>Repositório:</strong> <a href="https://github.com/Guilhermeabtibol/hydrus">Guilhermeabtibol/hydrus</a></li>
      <li><strong>Última Atualização:</strong> <span id="last-update">Carregando...</span></li>
      <li><strong>Commits:</strong> <span id="commit-count">Carregando...</span></li>
    </ul>
  </div>
</div>

## 🚀 Quick Start

### Pré-requisitos


# No Linux Mint/Debian/Ubuntu
sudo apt update
sudo apt install python3 git curl -y
Instalação em 3 Passos
bash
# 1. Clone o repositório
git clone https://github.com/Guilhermeabtibol/hydrus.git
cd hydrus

# 2. Execute o deploy automático
chmod +x scripts/*.sh
./scripts/deploy.sh

# 3. Acesse a aplicação
# No navegador: http://localhost:5000
# Ou via terminal: curl http://localhost:5000
Verificação Rápida
bash
# Verificar se está funcionando
curl http://localhost:5000/health

# Saída esperada:
# {"status": "healthy", "project": "Hydrus", "timestamp": "..."}
📁 Estrutura do Projeto
text
hydrus/
├── app/                    # Aplicação Flask principal
│   ├── app.py             # Código do servidor
│   ├── requirements.txt   # Dependências Python
│   ├── templates/         # Templates HTML
│   └── static/            # Arquivos CSS/JS
├── scripts/               # Scripts de automação
│   ├── deploy.sh          # Script de deploy completo
│   ├── monitor.sh         # Monitoramento do sistema
│   └── backup.sh          # Backup automatizado
├── docs/                  # Documentação (esta página!)
├── logs/                  # Logs da aplicação
└── .github/               # GitHub Actions e Pages
🛠️ Scripts de Automação
Script	Descrição	Comando
deploy.sh	Instala e configura toda a aplicação	./scripts/deploy.sh
monitor.sh	Verifica saúde do sistema e aplicação	./scripts/monitor.sh
backup.sh	Cria backup completo do projeto	./scripts/backup.sh
Exemplo de Uso
bash
# Deploy completo
./scripts/deploy.sh

# Monitorar a aplicação (executa verificações)
./scripts/monitor.sh

# Criar backup
./scripts/backup.sh
🔍 Endpoints da API
Endpoint	Descrição	Exemplo de Resposta
GET /	Página principal	HTML da aplicação
GET /health	Status da aplicação	{"status": "healthy", ...}
📚 Recursos de Aprendizado
Conceitos Abordados
Git & GitHub

Controle de versão

Branching strategy básica

GitHub Pages

Linux Administration

Systemd services

Permissões de arquivos

Log management

Scripting & Automation

Bash scripting

Cron jobs

Backup automation

Web Development Basics

Flask framework

REST APIs

HTML/CSS templates

Próximos Passos Sugeridos
Adicionar banco de dados SQLite

Implementar Dockerização

Adicionar testes automatizados

Configurar monitoramento com Prometheus

🤝 Como Contribuir
Encontrou um bug? Tem uma sugestão? Siga estes passos:

Reportar Issue

Use o GitHub Issues

Descreva o problema claramente

Enviar Pull Request

bash
# 1. Fork o repositório
# 2. Crie uma branch
git checkout -b minha-melhoria

# 3. Faça suas alterações
# 4. Commit
git commit -m "Minha melhoria"

# 5. Push
git push origin minha-melhoria

# 6. Abra Pull Request no GitHub
📞 Suporte e Contato
GitHub Issues: Reportar problema

Email: guiabtibol@gmail.com


📄 Licença
Este projeto está licenciado sob a MIT License - veja o arquivo LICENSE para detalhes.

<div align="center"> <p>Desenvolvido com ❤️ por <strong>Guilherme Abtibol (GVoxx)</strong></p> <p> <a href="https://github.com/Guilhermeabtibol">GitHub</a> • <a href="https://github.com/Guilhermeabtibol/hydrus">Repositório</a> • <a href="#top">⬆️ Voltar ao topo</a> </p> </div><script> // Script simples para mostrar informações dinâmicas document.addEventListener('DOMContentLoaded', function() { // Atualizar data document.getElementById('last-update').textContent = new Date().toLocaleDateString('pt-BR'); // Status do servidor (simulação) const statusEl = document.getElementById('server-status'); statusEl.innerHTML = '<span style="color: green;">✅ Online e Funcionando</span>'; // Contador de commits (placeholder) document.getElementById('commit-count').textContent = 'Ver no GitHub'; }); </script><style> .dashboard { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin: 30px 0; } .card { background: #f5f5f5; padding: 20px; border-radius: 10px; border-left: 4px solid #4CAF50; } .btn { display: inline-block; padding: 10px 20px; background: #4CAF50; color: white; text-decoration: none; border-radius: 5px; margin: 5px; } .btn:hover { background: #45a049; } </style>
EOF
