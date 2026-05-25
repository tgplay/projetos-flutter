# GranaBase API — Backend Dart

Servidor REST em Dart (Shelf) que serve de backend para o app Flutter GranaBase. Gerencia autenticação JWT e persiste dados no PostgreSQL.

## Pré-requisitos

- [Dart SDK](https://dart.dev/get-dart) 3.x ou superior
- PostgreSQL 13 ou superior rodando localmente
- DBeaver ou outro cliente PostgreSQL (para executar o script de setup)

---

## Configuração do banco de dados

### 1. Criar o banco

No DBeaver (ou psql), crie um banco chamado `grana_base`:

```sql
CREATE DATABASE grana_base;
```

### 2. Executar o script de setup

Conecte no banco `grana_base` e execute o arquivo `setup.sql`:

```
File → Open File → setup.sql → Ctrl+Alt+X
```

Isso cria todas as tabelas: `users`, `categories`, `transactions`, `reserve_goals`, `reserve_contributions`.

### 3. Ajustar as credenciais

Se o seu PostgreSQL usar usuário/senha diferentes de `postgres/postgres`, edite `lib/config/database.dart`:

```dart
Endpoint(
  host: 'localhost',
  port: 5432,
  database: 'grana_base',
  username: 'seu_usuario',
  password: 'sua_senha',
)
```

---

## Rodando o servidor

### Instalar dependências

```bash
dart pub get
```

### Via terminal

```bash
dart run bin/server.dart
```

### Via VS Code (Run & Debug)

Abra a pasta `grana_base_api` no VS Code e pressione `F5` — a configuração já está em `.vscode/launch.json`.

O servidor inicia na porta **8080**:
```
GranaBase API rodando em http://0.0.0.0:8080
```

---

## Endpoints

### Autenticação (público)

| Método | Rota | Descrição |
|---|---|---|
| POST | `/auth/register` | Cadastrar usuário |
| POST | `/auth/login` | Login — retorna JWT |

**Body (ambos):**
```json
{ "email": "usuario@email.com", "password": "123456" }
```

**Resposta:**
```json
{ "token": "eyJ...", "userId": "uuid", "email": "usuario@email.com" }
```

---

### Rotas protegidas (requer `Authorization: Bearer <token>`)

#### Categorias

| Método | Rota | Descrição |
|---|---|---|
| GET | `/categories/?type=income` | Listar por tipo (`income` ou `expense`) |
| POST | `/categories/` | Criar categoria |

#### Transações

| Método | Rota | Descrição |
|---|---|---|
| GET | `/transactions/summary` | Totais de receitas e despesas |
| GET | `/transactions/?page=1&limit=5` | Listar com paginação |
| POST | `/transactions/` | Criar transação |
| PUT | `/transactions/<id>` | Editar transação |
| DELETE | `/transactions/<id>` | Excluir transação |

#### Meta de reserva

| Método | Rota | Descrição |
|---|---|---|
| GET | `/reserve-goals/` | Buscar meta do usuário |
| POST | `/reserve-goals/` | Criar meta |
| PUT | `/reserve-goals/<id>` | Editar meta |

#### Aportes de reserva

| Método | Rota | Descrição |
|---|---|---|
| GET | `/reserve-contributions/` | Listar todos os aportes |
| GET | `/reserve-contributions/?recent=true` | Últimos 10 aportes |
| POST | `/reserve-contributions/` | Registrar aporte |
| PUT | `/reserve-contributions/<id>` | Editar aporte |
| DELETE | `/reserve-contributions/<id>` | Excluir aporte |

---

## Estrutura do projeto

```
grana_base_api/
├── bin/
│   └── server.dart                        # Entrada do servidor
├── lib/
│   ├── config/
│   │   └── database.dart                  # Conexão PostgreSQL
│   ├── middleware/
│   │   └── auth_middleware.dart           # Validação JWT
│   └── handlers/
│       ├── auth_handler.dart
│       ├── categories_handler.dart
│       ├── transactions_handler.dart
│       ├── reserve_goals_handler.dart
│       └── reserve_contributions_handler.dart
├── setup.sql                              # Script de criação das tabelas
└── pubspec.yaml
```

---

## Observações

- O segredo JWT está em `lib/middleware/auth_middleware.dart` na constante `jwtSecret`. **Troque-o antes de ir para produção.**
- O token expira em **7 dias**.
- Para produção, use variáveis de ambiente para credenciais do banco e o segredo JWT.
