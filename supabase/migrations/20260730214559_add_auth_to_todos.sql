-- Ajoute un lien vers l'utilisateur propriétaire
alter table todos
add column user_id uuid references auth.users(id) default auth.uid();

-- Remplace l'ancienne politique trop permissive
drop policy "Allow all access to todos" on todos;

-- Chacun ne voit/modifie que ses propres todos
create policy "Users can view their own todos"
on todos for select
using (auth.uid() = user_id);

create policy "Users can insert their own todos"
on todos for insert
with check (auth.uid() = user_id);

create policy "Users can update their own todos"
on todos for update
using (auth.uid() = user_id);

create policy "Users can delete their own todos"
on todos for delete
using (auth.uid() = user_id);