#!/bin/bash

# Carregar variáveis de ambiente do .env
source .env

# Função para verificar e clonar ou dar git pull
check_and_clone_or_pull() {
  REPO_URL=$1
  FOLDER_PATH=$2

  if [ -d "$FOLDER_PATH/.git" ]; then
    echo "Pasta $FOLDER_PATH já contém um repositório Git, executando git pull..."
    cd $FOLDER_PATH && git pull
  else
    echo "Clonando o repositório em $FOLDER_PATH..."
    git clone $REPO_URL $FOLDER_PATH
  fi
}

# Verificar e clonar/puxar os repositórios
check_and_clone_or_pull $ETL_REPO ./src/etl
check_and_clone_or_pull $API_REPO ./src/api
check_and_clone_or_pull $PREFECT_REPO ./src/prefect

# Manter o container rodando sem finalizar
# exec "$@"
