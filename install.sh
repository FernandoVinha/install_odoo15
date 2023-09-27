#!/bin/bash

# Verifica se docker-compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo "docker-compose não encontrado. Instalando..."
    # Baixa o Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    # Dá permissões de execução ao binário
    sudo chmod +x /usr/local/bin/docker-compose
    echo "docker-compose instalado com sucesso!"
else
    echo "docker-compose já está instalado!"
fi

# 1. Crie as pastas necessárias
mkdir -p config addons

# 2. Crie o docker-compose.yml
cat <<EOL > docker-compose.yml
version: '3.8'

services:
  web:
    image: odoo:15
    volumes:
      - ./config:/etc/odoo
      - ./addons:/mnt/extra-addons
    depends_on:
      - db
    ports:
      - "8069:8069"
  db:
    image: postgres:13
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_PASSWORD=odoo
      - POSTGRES_USER=odoo
EOL

# 3. Inicie o Odoo e o banco de dados PostgreSQL
docker-compose up -d

# 4. Instruções finais
echo "O Odoo está rodando! Acesse em http://localhost:8069"
echo "Edite e adicione módulos na pasta ./addons e ajuste as configurações em ./config conforme necessário."
