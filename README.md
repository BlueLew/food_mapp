# Food Mapp

Food Mapp is a Rails 8 rewrite of the original restaurant review prototype. The app connects venue likes with residence history so users can see how geography shapes taste.

## Stack

- Ruby 4.0.2
- Rails 8.1
- PostgreSQL
- Hotwire with importmap and Stimulus
- Tailwind CSS
- Solid Queue / Solid Cache / Solid Cable
- Geocoder + Google Maps

## Core Concepts

- `User`: authenticated member or admin
- `Residence`: a city/state/country entry attached to a user
- `Venue`: a place users can browse and like
- `Like`: a non-polymorphic join between user and venue

## Local Setup

1. Verify Ruby `4.0.2` is active.
2. Install gems with `bundle install`.
3. Export env values from `.env.example` if you want to override the local defaults.
4. Start PostgreSQL locally, or use Docker Compose.
5. Prepare the database with `bin/rails db:prepare`.
6. Load demo data with `bin/rails db:seed`.

For a Homebrew PostgreSQL install, the app defaults to:

- host: `127.0.0.1`
- port: `5432`
- username: your current macOS username
- password: blank

If you are using Docker Compose instead, set `DB_USER=postgres`, `DB_PASSWORD=postgres`, and `DB_HOST=db`.

Solid Queue uses a separate queue database in development, test, and production. After changing DB config, run `bin/rails db:prepare` so both the primary and queue databases are created and loaded.

## Docker Compose

The repo includes a local development stack with:

- `db`: PostgreSQL
- `web`: Rails server
- `worker`: Solid Queue worker

Boot it with:

```bash
docker compose up --build
```

Then initialize the app from another shell:

```bash
docker compose run --rm web bin/rails db:prepare db:seed
```

The Docker database is published on host port `5433`, so it can run alongside a local Homebrew PostgreSQL server on `5432`.

## Dip

If you prefer `dip`, the repo includes a ready-to-use config in [dip.yml](/Users/lewiscruz/projects/food_mapp/dip.yml).

Examples:

```bash
dip provision
dip up
dip start:app
dip start:worker
dip start:db
dip rails console
dip rails db:migrate
dip rails db:seed
dip test
dip bash
```

## Jobs Dashboard

The app includes Mission Control Jobs for a Rails-native background job dashboard. Admin users can access it at `/jobs`.

## Useful Commands

```bash
bin/rails server
bin/rails tailwindcss:watch
bin/jobs start
bin/rails test
```

## Seed Accounts

All seeded users use the password `password123`.

- Admin: `admin@foodmapp.test`
- Member: `amina@foodmapp.test`
- Member: `leo@foodmapp.test`
- Member: `mei@foodmapp.test`

## Maps

Set `GOOGLE_MAPS_API_KEY` to enable:

- venue map rendering
- residence-origin map rendering
- automatic geocoding for venues and residences

If the key is missing, the app still works, but maps and geocoding fall back gracefully.
