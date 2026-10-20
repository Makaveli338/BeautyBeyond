-- Schema for Beauty Beyond (derived from the queries in server/api)
-- Safe to re-run: uses IF NOT EXISTS.

CREATE TABLE IF NOT EXISTS users (
  id         SERIAL PRIMARY KEY,
  username   VARCHAR(100) NOT NULL,
  email      VARCHAR(255) NOT NULL UNIQUE,
  password   TEXT NOT NULL,                       -- bcrypt hash
  role       VARCHAR(20) NOT NULL DEFAULT 'user'
             CHECK (role IN ('admin', 'staff', 'user')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS services (
  id           SERIAL PRIMARY KEY,
  user_id      INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  service_name VARCHAR(150) NOT NULL,
  price        NUMERIC(10, 2) NOT NULL,
  service_time VARCHAR(50) NOT NULL,
  service_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  commission   NUMERIC(10, 2) NOT NULL DEFAULT 0,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_services_user_id ON services(user_id);
CREATE INDEX IF NOT EXISTS idx_services_date ON services(service_date);

CREATE TABLE IF NOT EXISTS inventory (
  id           SERIAL PRIMARY KEY,
  name         VARCHAR(150) NOT NULL,
  category     VARCHAR(100) NOT NULL,
  quantity     INTEGER NOT NULL DEFAULT 0,
  price        NUMERIC(10, 2) NOT NULL DEFAULT 0,
  status       VARCHAR(50) NOT NULL,
  last_restock DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
