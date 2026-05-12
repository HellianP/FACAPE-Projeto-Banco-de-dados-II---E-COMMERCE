# Projeto BD II — E-Commerce

Projeto da disciplina **Banco de Dados II** (UNIVASF) usando **Firebird 5** em container Docker.

## Pré-requisitos

- Docker Desktop (Windows/Mac) ou Docker Engine + Compose plugin (Linux)
- Cliente SQL pra conectar no banco (DBeaver, IBExpert, FlameRobin ou o próprio `isql`)

## Subindo o banco

Na raiz do projeto:

```bash
docker compose up -d
```

Na primeira subida o container cria o arquivo `projetobd2.fdb` automaticamente e executa todos os scripts `.sql` da pasta `init/` em ordem alfabética. Pra acompanhar o log:

```bash
docker compose logs -f firebird
```

Pra parar:

```bash
docker compose down
```

Pra apagar o banco e recomeçar do zero (re-executa os scripts de `init/`):

```bash
docker compose down -v
```

## Configuração

Tudo fica no `docker-compose.yml`. Os valores padrão são:

| Item | Valor |
|---|---|
| Host | `localhost` |
| Porta | `3050` |
| Usuário | `SYSDBA` |
| Senha | `masterkey` |
| Database (path no container) | `/var/lib/firebird/data/projetobd2.fdb` |
| Charset padrão | `UTF8` |

Pra trocar qualquer um desses, edita direto no `docker-compose.yml` antes de subir.

## Conectando no banco

### DBeaver / IBExpert / FlameRobin

- Host: `localhost`
- Porta: `3050`
- Database: `/var/lib/firebird/data/projetobd2.fdb`
- User: `SYSDBA`
- Password: `masterkey`

### Linha de comando (isql dentro do container)

```bash
docker exec -it firebird-projetobd2 isql -user SYSDBA -password masterkey /var/lib/firebird/data/projetobd2.fdb
```

## Estrutura do projeto

```
projetobd2/
├── docker-compose.yml    # Definição do serviço Firebird
├── init/                 # Scripts SQL de inicialização (rodam só na criação do banco)
│   └── 01-schema.sql
└── README.md
```

Pra adicionar mais scripts, basta criar arquivos numerados em `init/` (`02-...sql`, `03-...sql`). A ordem alfabética é respeitada.

## Backup e restore

Backup online (com o container rodando):

```bash
docker exec firebird-projetobd2 bash -c "gbak -b -user SYSDBA -pas masterkey -se localhost:service_mgr /var/lib/firebird/data/projetobd2.fdb /var/lib/firebird/data/projetobd2.fbk"
```

O arquivo `.fbk` fica dentro do volume do container. Pra copiar pro host:

```bash
docker cp firebird-projetobd2:/var/lib/firebird/data/projetobd2.fbk ./projetobd2.fbk
```

Restore:

```bash
docker exec firebird-projetobd2 bash -c "gbak -c -user SYSDBA -pas masterkey -se localhost:service_mgr /var/lib/firebird/data/projetobd2.fbk /var/lib/firebird/data/projetobd2_restaurado.fdb"
```

## Persistência

Os dados ficam num volume Docker chamado `projetobd2_firebird_data` e sobrevivem a `docker compose down`. Só são apagados com `docker compose down -v`.

## Troubleshooting

**Porta 3050 ocupada.** Já tem um Firebird local rodando. Para ele ou troca o mapeamento de porta no compose pra algo como `"3051:3050"`.

**`failed to resolve reference firebirdsql/firebird:X`.** A tag não existe. Tags válidas no momento: `5`, `5.0.4`, `5.0.3`, `4`, `3`. Lista completa: <https://hub.docker.com/r/firebirdsql/firebird/tags>.

**Scripts de `init/` não rodaram.** Eles só executam quando o volume está vazio. Roda `docker compose down -v` e sobe de novo.
