-- Creates the FILMCRIQE administrator profile when either owner email first signs in.
-- Replace or remove these addresses before handing the publication to another owner.
create or replace function public.handle_filmcriqe_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, role, display_name)
  values (
    new.id,
    case when lower(new.email) in ('hpostrand@gmail.com','filmcriqe@gmail.com') then 'admin' else 'editor' end,
    coalesce(new.raw_user_meta_data ->> 'full_name', split_part(new.email, '@', 1))
  ) on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_filmcriqe_user_created on auth.users;
create trigger on_filmcriqe_user_created
  after insert on auth.users for each row execute procedure public.handle_filmcriqe_user();

-- Promote an existing owner account that may have signed in before the trigger.
insert into public.profiles (id, role, display_name)
select u.id, 'admin', coalesce(u.raw_user_meta_data ->> 'full_name', split_part(u.email, '@', 1))
from auth.users u
where lower(u.email) in ('hpostrand@gmail.com','filmcriqe@gmail.com')
on conflict (id) do nothing;

update public.profiles p set role = 'admin'
from auth.users u
where p.id = u.id and lower(u.email) in ('hpostrand@gmail.com','filmcriqe@gmail.com');
