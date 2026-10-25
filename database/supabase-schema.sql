-- Kumar Solar Supabase schema
create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.quotes (
  id text primary key,
  created_at timestamptz not null default now(),
  name text not null,
  consumer text,
  phone text,
  place text,
  status text not null default 'new'
    check (status in ('new','contacted','closed')),
  note text,
  at bigint
);

create table if not exists public.submissions (
  id text primary key,
  created_at timestamptz not null default now(),
  name text not null,
  stars integer not null default 5 check (stars between 1 and 5),
  text text,
  tags jsonb not null default '[]'::jsonb,
  photo text,
  at bigint
);

create table if not exists public.reviews (
  id text primary key,
  created_at timestamptz not null default now(),
  name text not null,
  stars integer not null default 5 check (stars between 1 and 5),
  text text,
  tags jsonb not null default '[]'::jsonb,
  photo text,
  at bigint,
  hide boolean not null default false
);

alter table public.admin_users enable row level security;
alter table public.quotes enable row level security;
alter table public.submissions enable row level security;
alter table public.reviews enable row level security;

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.admin_users
    where user_id = auth.uid()
  );
$$;

-- Public submission policies.
create policy "public can submit quotes"
on public.quotes for insert to anon, authenticated
with check (true);

create policy "public can submit reviews"
on public.submissions for insert to anon, authenticated
with check (true);

-- Public published review access.
create policy "public can read published reviews"
on public.reviews for select to anon, authenticated
using (hide = false);

-- Admin policies.
create policy "admins can read quotes"
on public.quotes for select to authenticated
using (public.is_admin());

create policy "admins can update quotes"
on public.quotes for update to authenticated
using (public.is_admin()) with check (public.is_admin());

create policy "admins can delete quotes"
on public.quotes for delete to authenticated
using (public.is_admin());

create policy "admins can read submissions"
on public.submissions for select to authenticated
using (public.is_admin());

create policy "admins can delete submissions"
on public.submissions for delete to authenticated
using (public.is_admin());

create policy "admins can read all reviews"
on public.reviews for select to authenticated
using (public.is_admin());

create policy "admins can insert reviews"
on public.reviews for insert to authenticated
with check (public.is_admin());

create policy "admins can update reviews"
on public.reviews for update to authenticated
using (public.is_admin()) with check (public.is_admin());

create policy "admins can delete reviews"
on public.reviews for delete to authenticated
using (public.is_admin());

-- After creating your admin user in Supabase Auth, run:
-- insert into public.admin_users(user_id) values ('YOUR-AUTH-USER-UUID');

-- Realtime is optional; enable it in Supabase Dashboard for reviews if desired.
