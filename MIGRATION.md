# Migration status

The original site used a custom `claude.use('db')` database and a client-side password hash.

This version replaces those pieces with:
- Supabase Postgres
- Supabase Auth
- Row Level Security
- Browser CSV generation
- Supabase CRUD for quotes/reviews/submissions

The UI and existing content were kept as the source basis. Further visual section extraction can be done independently.
