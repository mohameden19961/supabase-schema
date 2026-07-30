# supabase-schema


```markdown
# supabase-schema

Dépôt d'apprentissage pour le workflow **Supabase + GitHub** avec déploiement automatisé des migrations via GitHub Actions.

## Objectif

Ce repo sert de bac à sable pour maîtriser le cycle complet "schema as code" :
écrire le schéma de base de données en SQL versionné, plutôt que de modifier les tables manuellement dans le dashboard Supabase.

## Stack

- **Base de données** : PostgreSQL (Supabase, région Europe/Ireland)
- **CLI** : Supabase CLI
- **CI/CD** : GitHub Actions
- **Gestion de version** : Git / GitHub

## Structure du projet


supabase-schema/
├── .github/
│   └── workflows/
│       └── deploy.yml        # Pipeline CI/CD (déploiement auto des migrations)
├── supabase/
│   ├── config.toml
│   └── migrations/           # Historique des migrations SQL, dans l'ordre chronologique
├── GUIDE.md                  # Guide détaillé pas à pas de tout le workflow
└── README.md                 # Ce fichier
```

## Workflow

```
1. supabase migration new <nom_migration>
2. Écrire le SQL dans le fichier généré
3. git add . && git commit -m "..." && git push
4. GitHub Actions applique automatiquement la migration sur Supabase
```

Voir [`GUIDE.md`](./GUIDE.md) pour le détail complet de chaque étape, avec toutes les commandes.

## Tables actuelles

### `todos`
Table d'exemple avec RLS basé sur l'authentification (`auth.uid()`).

| Colonne | Type | Description |
|---|---|---|
| id | bigint | Clé primaire |
| title | text | Titre de la tâche |
| is_done | boolean | Statut |
| priority | text | `low` / `medium` / `high` |
| user_id | uuid | Référence `auth.users(id)` |
| created_at | timestamptz | Date de création |

### `final_check`
Table de validation du pipeline CI/CD complet.

## Prérequis pour contribuer

```bash
npm install -g supabase
supabase login
supabase link --project-ref camkgvkpkhawevpxmxxe
```

## Secrets requis (GitHub Actions)

| Nom | Description |
|---|---|
| `SUPABASE_ACCESS_TOKEN` | Token généré sur supabase.com/dashboard/account/tokens |
```

