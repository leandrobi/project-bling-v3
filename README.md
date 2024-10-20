
# Projeto FastAPI + ETL Bling + Prefect

Este projeto integra uma API desenvolvida com **FastAPI**, um **ETL** para o Bling, e orquestração de tarefas usando **Prefect**, tudo em uma estrutura modular dentro de `src/`.

## Estrutura do Projeto

```
project_bling_v3/
│
├── .env                # Variáveis de ambiente com URLs dos repositórios Git
├── docker-compose.yml  # Orquestração do Docker
├── Dockerfile          # Definição da imagem Docker
├── entrypoint.sh       # Script de verificação e atualização dos repositórios
└── src/
    ├── etl/            # Repositório ETL Bling v3
    ├── api/            # Repositório API FastAPI
    └── prefect/        # Repositório Prefect
```

### Componentes:

- **`api/`**: Contém o FastAPI que é exposto na porta 8000.
- **`bling/`**: Script principal de ETL que faz as operações com dados do Bling.
- **`prefect/`**: Scripts de automação e orquestração de tarefas usando o Prefect.

---

## Como Configurar e Executar o Projeto

### 1. Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto e defina as seguintes variáveis:

```env
# PostgreSQL settings
POSTGRES_USER=meu_usuario
POSTGRES_PASSWORD=minha_senha
POSTGRES_DB=meu_banco

# Configurações gerais
PYTHON_ENV=production
SECRET_KEY=sua_chave_secreta
API_PORT=8000
```

### 2. Dependências

Liste todas as dependências no arquivo `requirements.txt`. Por exemplo:

```txt
fastapi==0.78.0
uvicorn==0.17.0
prefect==2.0.3
psycopg2-binary==2.9.3
```

### 3. Subindo os Serviços com Docker

Use o **Docker Compose** para subir o ambiente completo, incluindo o FastAPI, o PostgreSQL e o Prefect.

#### Comandos:

```bash
# Construir a imagem e rodar os containers
docker-compose up --build
```

Este comando irá:
- **Rodar o FastAPI** na porta `8000`.
- **Executar o ETL** (script `main.py` do Bling) que será executado no container `app`.
- **Subir o PostgreSQL** na porta `5432`.
- **Subir o servidor do Prefect** na porta `4200` para gerenciar as tarefas.

### 4. Acessando os Serviços

- **FastAPI**: Acesse o FastAPI no endereço [http://localhost:8000](http://localhost:8000).
- **Prefect UI**: Acesse a interface do Prefect para gerenciar tarefas em [http://localhost:4200](http://localhost:4200).

### 5. Estrutura do Docker Compose

O arquivo `docker-compose.yml` orquestra os serviços do projeto:

```yaml
version: '3.8'

services:
  app:
    build: .
    container_name: app-container
    volumes:
      - .:/app
      - ~/.ssh:/root/.ssh  # Mapeando chaves SSH para persistência
    env_file:
      - .env
    ports:
      - "5000:5000"  # Porta para o projeto principal (caso necessário)
    depends_on:
      - db
    command: >
      bash -c "git pull && pip install -r requirements.txt && python src/bling/main.py"

  api:
    image: tiangolo/uvicorn-gunicorn-fastapi:python3.10
    container_name: api-container
    volumes:
      - ./src/api:/app
    env_file:
      - .env
    ports:
      - "8000:8000"
    command: uvicorn api:app --host 0.0.0.0 --port ${API_PORT}

  db:
    image: postgres
    container_name: postgres-db
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  prefect:
    image: prefecthq/prefect:latest
    container_name: prefect-container
    volumes:
      - ./src/prefect:/app/prefect
    environment:
      - PREFECT_API_URL=http://localhost:4200
    ports:
      - "4200:4200"
    command: prefect server start

volumes:
  postgres_data:
```

### 6. Logs e Monitoramento

Os logs de cada serviço podem ser visualizados diretamente nos containers, ou você pode configurar uma solução de logs persistente no `docker-compose.yml`. Para visualizar os logs de um serviço:

```bash
docker-compose logs app
docker-compose logs api
docker-compose logs prefect
```

### 7. Automação de Deploy e Agendamento de Tarefas

- O **Prefect** será responsável por gerenciar a automação das tarefas. Configure seus fluxos de trabalho dentro de `src/prefect/`.
- O comando `git pull` será executado antes de rodar o ETL do Bling para garantir que o código esteja sempre atualizado.

---

## Contribuição

1. Faça um fork do projeto.
2. Crie sua feature branch (`git checkout -b feature/sua-feature`).
3. Commit suas alterações (`git commit -m 'Add sua feature'`).
4. Faça um push para a branch (`git push origin feature/sua-feature`).
5. Abra um Pull Request.

---

## Licença

Este projeto está sob a licença MIT. Para mais informações, consulte o arquivo `LICENSE`.
