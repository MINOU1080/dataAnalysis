-- =========================
-- Référentiels géographiques
-- =========================
CREATE TABLE regions (
  region_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE countries (
  country_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  region_id INT NOT NULL REFERENCES regions(region_id),
  UNIQUE (name)
);

CREATE TABLE states (
  state_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  country_id INT NOT NULL REFERENCES countries(country_id),
  UNIQUE (name, country_id)
);

CREATE TABLE cities (
  city_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  state_id INT NOT NULL REFERENCES states(state_id),
  postal_code TEXT,
  UNIQUE (name, state_id, postal_code)
);

-- =========================
-- Autres référentiels
-- =========================
CREATE TABLE segments (
  segment_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE ship_modes (
  ship_mode_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE categories (
  category_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE subcategories (
  subcategory_id SERIAL PRIMARY KEY,
  category_id INT NOT NULL REFERENCES categories(category_id),
  name TEXT NOT NULL,
  UNIQUE (category_id, name)
);

CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  product_code TEXT NOT NULL UNIQUE,  -- "Product ID" du CSV
  name TEXT NOT NULL,                 -- "Product Name"
  subcategory_id INT NOT NULL REFERENCES subcategories(subcategory_id)
);

-- =========================
-- Entités métier
-- =========================
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  customer_code TEXT NOT NULL UNIQUE, -- "Customer ID" du CSV
  name TEXT NOT NULL,                 -- "Customer Name"
  segment_id INT NOT NULL REFERENCES segments(segment_id),
  city_id INT NOT NULL REFERENCES cities(city_id)
);

CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  order_code TEXT NOT NULL UNIQUE,    -- "Order ID" du CSV
  order_date DATE NOT NULL,           -- "Order Date"
  ship_date DATE,                     -- "Ship Date"
  ship_mode_id INT NOT NULL REFERENCES ship_modes(ship_mode_id),
  customer_id INT NOT NULL REFERENCES customers(customer_id)
);

CREATE TABLE order_lines (
  order_line_id BIGSERIAL PRIMARY KEY,
  order_id INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
  product_id INT NOT NULL REFERENCES products(product_id),
  sales NUMERIC(12,2) NOT NULL,       -- "Sales"
  -- En pratique on pourrait ajouter quantity, unit_price si on les a
  -- Empêche les doublons exacts (même produit sur la même commande et même montant)
  UNIQUE (order_id, product_id, sales)
);

-- Quelques index utiles pour les requêtes
CREATE INDEX idx_orders_order_date ON orders(order_date);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_order_lines_product ON order_lines(product_id);
CREATE INDEX idx_customers_city ON customers(city_id);
