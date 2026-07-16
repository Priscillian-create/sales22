-- PA GERRYS WHOLESALE POS Supabase setup
-- Run this in Supabase Dashboard > SQL Editor.
-- This creates empty inventory tables. No products are inserted.

create table if not exists public.store_settings (
  id integer primary key default 1,
  name text not null default 'PA GERRYS WHOLESALE',
  phone text default '',
  address text default '',
  currency text not null default 'NGN',
  footer text default '',
  updated_at timestamptz not null default now(),
  constraint store_settings_single_row check (id = 1)
);

create table if not exists public.products (
  id text primary key,
  name text not null,
  sku text not null,
  category text not null,
  cost numeric(14,2) not null default 0,
  price numeric(14,2) not null default 0,
  stock integer not null default 0,
  reorder integer not null default 0,
  supplier text default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.sales (
  id text primary key,
  receipt_no text not null unique,
  sale_date timestamptz not null default now(),
  customer text not null default 'Walk-in customer',
  payment text not null default 'Cash',
  total numeric(14,2) not null default 0,
  cost numeric(14,2) not null default 0,
  profit numeric(14,2) not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.sale_items (
  id text primary key,
  sale_id text not null references public.sales(id) on delete cascade,
  product_id text,
  product_name text not null,
  sku text default '',
  qty integer not null default 1,
  price numeric(14,2) not null default 0,
  cost numeric(14,2) not null default 0,
  total numeric(14,2) not null default 0,
  profit numeric(14,2) not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.customers (
  name text primary key,
  balance numeric(14,2) not null default 0,
  last_activity timestamptz,
  updated_at timestamptz not null default now()
);

create table if not exists public.expenses (
  id text primary key,
  date date not null default current_date,
  category text not null,
  note text not null,
  amount numeric(14,2) not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.stock_logs (
  id text primary key,
  product_id text,
  product_name text not null,
  qty integer not null,
  reason text not null,
  created_at timestamptz not null default now()
);

insert into public.store_settings (id, name, phone, address, currency, footer)
values (1, 'PA GERRYS WHOLESALE', '08141606223', '', 'NGN', 'For online orders call 08141606223')
on conflict (id) do nothing;

update public.store_settings
set phone = '08141606223',
    footer = 'For online orders call 08141606223',
    updated_at = now()
where id = 1;

-- Remove all products so you can add your own inventory from the POS.
-- Existing sales history is not deleted.
delete from public.products;

alter table public.store_settings enable row level security;
alter table public.products enable row level security;
alter table public.sales enable row level security;
alter table public.sale_items enable row level security;
alter table public.customers enable row level security;
alter table public.expenses enable row level security;
alter table public.stock_logs enable row level security;

drop policy if exists "anon_select_store_settings" on public.store_settings;
drop policy if exists "anon_insert_store_settings" on public.store_settings;
drop policy if exists "anon_update_store_settings" on public.store_settings;
drop policy if exists "anon_delete_store_settings" on public.store_settings;

drop policy if exists "anon_select_products" on public.products;
drop policy if exists "anon_insert_products" on public.products;
drop policy if exists "anon_update_products" on public.products;
drop policy if exists "anon_delete_products" on public.products;

drop policy if exists "anon_select_sales" on public.sales;
drop policy if exists "anon_insert_sales" on public.sales;
drop policy if exists "anon_update_sales" on public.sales;
drop policy if exists "anon_delete_sales" on public.sales;

drop policy if exists "anon_select_sale_items" on public.sale_items;
drop policy if exists "anon_insert_sale_items" on public.sale_items;
drop policy if exists "anon_update_sale_items" on public.sale_items;
drop policy if exists "anon_delete_sale_items" on public.sale_items;

drop policy if exists "anon_select_customers" on public.customers;
drop policy if exists "anon_insert_customers" on public.customers;
drop policy if exists "anon_update_customers" on public.customers;
drop policy if exists "anon_delete_customers" on public.customers;

drop policy if exists "anon_select_expenses" on public.expenses;
drop policy if exists "anon_insert_expenses" on public.expenses;
drop policy if exists "anon_update_expenses" on public.expenses;
drop policy if exists "anon_delete_expenses" on public.expenses;

drop policy if exists "anon_select_stock_logs" on public.stock_logs;
drop policy if exists "anon_insert_stock_logs" on public.stock_logs;
drop policy if exists "anon_update_stock_logs" on public.stock_logs;
drop policy if exists "anon_delete_stock_logs" on public.stock_logs;

create policy "anon_select_store_settings" on public.store_settings for select to anon using (true);
create policy "anon_insert_store_settings" on public.store_settings for insert to anon with check (true);
create policy "anon_update_store_settings" on public.store_settings for update to anon using (true) with check (true);
create policy "anon_delete_store_settings" on public.store_settings for delete to anon using (true);

create policy "anon_select_products" on public.products for select to anon using (true);
create policy "anon_insert_products" on public.products for insert to anon with check (true);
create policy "anon_update_products" on public.products for update to anon using (true) with check (true);
create policy "anon_delete_products" on public.products for delete to anon using (true);

create policy "anon_select_sales" on public.sales for select to anon using (true);
create policy "anon_insert_sales" on public.sales for insert to anon with check (true);
create policy "anon_update_sales" on public.sales for update to anon using (true) with check (true);
create policy "anon_delete_sales" on public.sales for delete to anon using (true);

create policy "anon_select_sale_items" on public.sale_items for select to anon using (true);
create policy "anon_insert_sale_items" on public.sale_items for insert to anon with check (true);
create policy "anon_update_sale_items" on public.sale_items for update to anon using (true) with check (true);
create policy "anon_delete_sale_items" on public.sale_items for delete to anon using (true);

create policy "anon_select_customers" on public.customers for select to anon using (true);
create policy "anon_insert_customers" on public.customers for insert to anon with check (true);
create policy "anon_update_customers" on public.customers for update to anon using (true) with check (true);
create policy "anon_delete_customers" on public.customers for delete to anon using (true);

create policy "anon_select_expenses" on public.expenses for select to anon using (true);
create policy "anon_insert_expenses" on public.expenses for insert to anon with check (true);
create policy "anon_update_expenses" on public.expenses for update to anon using (true) with check (true);
create policy "anon_delete_expenses" on public.expenses for delete to anon using (true);

create policy "anon_select_stock_logs" on public.stock_logs for select to anon using (true);
create policy "anon_insert_stock_logs" on public.stock_logs for insert to anon with check (true);
create policy "anon_update_stock_logs" on public.stock_logs for update to anon using (true) with check (true);
create policy "anon_delete_stock_logs" on public.stock_logs for delete to anon using (true);

grant usage on schema public to anon;
grant select, insert, update, delete on public.store_settings to anon;
grant select, insert, update, delete on public.products to anon;
grant select, insert, update, delete on public.sales to anon;
grant select, insert, update, delete on public.sale_items to anon;
grant select, insert, update, delete on public.customers to anon;
grant select, insert, update, delete on public.expenses to anon;
grant select, insert, update, delete on public.stock_logs to anon;
