# Kumar Solar — GitHub + Supabase

## What was converted

- Removed the old `claude.use('db')` persistence dependency.
- Removed the old `claude.use('downloads')` CSV dependency.
- Quotation requests now insert into Supabase.
- Customer reviews now insert into the moderation queue.
- Admin quotations can update status/notes and DELETE records.
- Admin reviews can approve/reject/edit/delete.
- Admin authentication uses Supabase Auth instead of the old client-side SHA-256 password.
- Row Level Security protects customer/admin database access.
- CSV export is performed entirely in the browser.

## Setup

1. Create a Supabase project.
2. Open SQL Editor.
3. Run `database/supabase-schema.sql`.
4. In Supabase Authentication, create the admin email/password user.
5. Copy that user's UUID.
6. Insert the UUID into `public.admin_users` using the commented SQL at the bottom of the schema.
7. Open `js/supabase.js` and replace:
   - `YOUR_SUPABASE_URL`
   - `YOUR_SUPABASE_ANON_KEY`
8. Commit/push the project to GitHub.
9. Enable GitHub Pages.

## Security

Do not put a Supabase `service_role` key in this project. Only the public anon key belongs in browser code.

## Delete

The admin Delete button now calls Supabase `.delete().eq('id', id)`, updates the local admin state after success, and displays the actual database error if the operation is denied.
