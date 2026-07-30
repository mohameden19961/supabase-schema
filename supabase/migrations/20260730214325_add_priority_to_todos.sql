-- Ajoute une colonne priority à la table todos
alter table todos
add column priority text default 'medium' check (priority in ('low', 'medium', 'high'));