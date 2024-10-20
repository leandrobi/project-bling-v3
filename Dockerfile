FROM python:3.10-slim

# Instalar dependências essenciais
RUN apt-get update && apt-get install -y \
    git \
    openssh-client \
    build-essential \
    libssl-dev \
    libpq-dev \
    curl

# Criar diretório de trabalho
WORKDIR /app

# Copiar os arquivos necessários
COPY . /app

# Definir o script de entrada
RUN chmod +x /app/entrypoint.sh

# Definir o entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]
