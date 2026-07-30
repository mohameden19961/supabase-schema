# supabase-schema

Dépôt d'apprentissage pour le workflow **Supabase + GitHub** avec migrations SQL versionnées et déploiement automatisé.

## Objectif

Ce repo est un bac à sable pour maîtriser le cycle complet *"schema as code"* :
écrire le schéma de base de données en SQL versionné (fichiers de migration) plutôt
que de modifier les tables manuellement dans le dashboard Supabase.

**Principe :** chaque modification du schéma est une migration SQL commitée dans
Git. Un push sur `main` déclenche l'application automatique de la migration sur
la base distante via GitHub Actions.

## Stack

| Technologie | Usage |
|---|---|
| PostgreSQL (Supabase) | Base de données |
| Supabase CLI | Création et push des migrations |
| GitHub Actions | CI/CD — déploiement automatique |
| Git / GitHub | Gestion de version |

## Schéma actuel

### `todos` — Tâches

Table principale avec RLS basé sur l'utilisateur connecté.

| Colonne | Type | Contrainte |
|---|---|---|
| `id` | `bigint` | PK, auto-généré |
| `title` | `text` | NOT NULL |
| `is_done` | `boolean` | défaut `false` |
| `priority` | `text` | défaut `'medium'`, CHECK (`low`, `medium`, `high`) |
| `user_id` | `uuid` | REFERENCES `auth.users(id)`, défaut `auth.uid()` |
| `created_at` | `timestamptz` | défaut `now()` |

**Politiques RLS :** SELECT, INSERT, UPDATE, DELETE — chaque utilisateur
ne voit/modifie que ses propres todos (`auth.uid() = user_id`).

### `final_check` — Validation CI/CD

Table de test créée pour valider le pipeline complet.

| Colonne | Type |
|---|---|
| `id` | `bigint` PK |
| `message` | `text` |
| `checked_at` | `timestamptz` |

### `todo_comments` — Commentaires (one-to-many)

Relation N:1 avec `todos`.

| Colonne | Type | Contrainte |
|---|---|---|
| `id` | `bigint` | PK |
| `todo_id` | `bigint` | FK → `todos(id)` ON DELETE CASCADE, indexé |
| `content` | `text` | NOT NULL |
| `created_at` | `timestamptz` | défaut `now()` |

### `tags` + `todo_tags` — Étiquettes (many-to-many)

Table de référence `tags` et table de jonction `todo_tags`.

**tags**

| Colonne | Type |
|---|---|
| `id` | `bigint` PK |
| `name` | `text` UNIQUE NOT NULL |
| `color` | `text` |

**todo_tags**

| Colonne | Type | Contrainte |
|---|---|---|
| `todo_id` | `bigint` | FK → `todos(id)` ON DELETE CASCADE, indexé |
| `tag_id` | `bigint` | FK → `tags(id)` ON DELETE CASCADE, indexé |
| | | PK composite `(todo_id, tag_id)` |

## Structure du projet

```
supabase-schema/
├── .github/
│   └── workflows/
│       └── deploy.yml          # Pipeline CI/CD
├── supabase/
│   ├── config.toml             # Configuration Supabase
│   └── migrations/             # Migrations SQL chronologiques
│       ├── 20260730213638_init_schema.sql
│       ├── 20260730213800_create_todos_table.sql
│       ├── 20260730214325_add_priority_to_todos.sql
│       ├── 20260730214559_add_auth_to_todos.sql
│       ├── 20260730215303_test_ci_cd.sql
│       ├── 20260730220204_final_test.sql
│       ├── 20260730221526_create_todo_comments_table.sql
│       └── 20260730222400_create_tags_and_todo_tags.sql
├── GUIDE.md                    # Guide détaillé pas à pas
└── README.md                   # Ce fichier
```

## Workflow en une ligne

```
supabase migration new <nom>  →  git add/commit/push  →  GitHub Actions déploie
```

## Prérequis

```bash
npm install -g supabase
supabase login
supabase link --project-ref camkgvkpkhawevpxmxxe
```

## Secrets GitHub Actions

| Nom | Description |
|---|---|
| `SUPABASE_ACCESS_TOKEN` | Token depuis supabase.com/dashboard/account/tokens |

---

👉 Consultez [`GUIDE.md`](./GUIDE.md) pour le guide complet pas à pas.
