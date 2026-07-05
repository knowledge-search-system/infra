# Knowledge Search System — Infrastructure

Инфраструктурный репозиторий

Содержит конфигурацию окружений, Docker Compose, автоматический деплой и вспомогательные файлы для запуска всей системы.

---

## Состав системы

| Сервис | Назначение |
|--------|------------|
| PostgreSQL + pgvector | Основная база данных |
| Redis | Кэширование |
| Elasticsearch | Полнотекстовый поиск |
| Search Engine | Сервис поиска |
| Document Processor | Обработка документов |
| ML Service | Семантический поиск (RAG) |
| Gateway | Единая REST API точка входа |
| Frontend | Пользовательский интерфейс |

---

## Структура репозитория

```
.
├── .github/
│   └── workflows/
├── docker/
│   └── postgres/
│       └── init/
├── scripts/
├── docker-compose.dev.yml
├── docker-compose.prod.yml
└── README.md
```

---

## Локальный запуск

Запуск окружения разработки:

```bash
docker compose -f docker-compose.dev.yml up -d
```

Остановка:

```bash
docker compose -f docker-compose.dev.yml down
```

---

## Production

Запуск production-окружения:

```bash
docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d
```

---

## Переменные окружения

Конфигурация приложения хранится в файле

```text
.env
```

Пример конфигурации:

```text
.env.example
```

---

## CI/CD

Каждый микросервис содержит собственные пайплайны GitHub Actions.

При пуше в ветку **main**:

1. Выполняются проверки проекта.
2. Собирается Docker-образ.
3. Образ публикуется в GitHub Container Registry (GHCR).
4. Отправляется событие `repository_dispatch` в данный репозиторий.
5. GitHub Actions автоматически обновляет сервисы на production-сервере.

Таким образом деплой выполняется полностью автоматически после успешного пуша.

---

## Используемые технологии

- Docker
- Docker Compose
- GitHub Actions
- GitHub Container Registry (GHCR)
- PostgreSQL + pgvector
- Redis
- Elasticsearch

---

## Архитектура

```
                    Интернет
                        │
                        ▼
                 ┌─────────────┐
                 │  Frontend   │
                 │    Nginx    │
                 └──────┬──────┘
                        │
                    /api/*
                        │
                        ▼
                 ┌─────────────┐
                 │   Gateway   │
                 └──────┬──────┘
                        │
        ┌───────────────┼────────────────┐
        ▼               ▼                ▼
 Search Engine   Document Processor   ML Service
        │               │                │
        └───────────────┴────────────────┘
                        │
      PostgreSQL • Redis • Elasticsearch
```

---
