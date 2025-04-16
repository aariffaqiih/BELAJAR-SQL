-- Tabel Produk
CREATE TABLE products (
    product_id     INT PRIMARY KEY,
    product_name   VARCHAR(100),
    category       VARCHAR(50),
    unit_price     DECIMAL(10, 2)
);

-- Tabel Negara
CREATE TABLE countries (
    country_id     INT PRIMARY KEY,
    country_name   VARCHAR(100),
    region         VARCHAR(50)
);

-- Tabel Ekspor
CREATE TABLE exports (
    export_id      INT PRIMARY KEY,
    product_id     INT,
    country_id     INT,
    quantity       INT,
    export_date    DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

-- Tabel Lisensi Impor
CREATE TABLE import_licenses (
    license_id     INT PRIMARY KEY,
    product_id     INT,
    country_id     INT,
    quota          INT,
    valid_until    DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

-- Kuota per negara dan rata-rata
SELECT c.country_name,
       SUM(i.quota) AS total_quota,
       (SELECT AVG(quota) FROM import_licenses) AS avg_quota
FROM countries c
JOIN import_licenses i ON c.country_id = i.country_id
GROUP BY c.country_name;

-- Produk lebih murah dari rata-rata kategori 'Electronics'
SELECT product_name, unit_price
FROM products
WHERE unit_price < (
    SELECT AVG(unit_price)
    FROM products
    WHERE category = 'Electronics'
);

-- Produk lebih mahal dari rata-rata kategori 'Food'
SELECT product_name, unit_price,
       (SELECT AVG(unit_price) FROM products WHERE category = 'Food') AS avg_food_price
FROM products
WHERE unit_price > (
    SELECT AVG(unit_price) FROM products WHERE category = 'Food'
);

-- Negara dengan kuota terbesar pada satu lisensi
SELECT c.country_name, i.quota
FROM countries c
JOIN import_licenses i ON c.country_id = i.country_id
WHERE i.quota = (
    SELECT MAX(quota)
    FROM import_licenses
);

-- Produk lebih mahal dari 'Coffee Beans'
SELECT product_name, unit_price
FROM products
WHERE unit_price > (
    SELECT unit_price
    FROM products
    WHERE product_name = 'Coffee Beans'
)
ORDER BY unit_price DESC;

-- Negara dengan kuota lebih besar dari rata-rata
SELECT c.country_name, i.quota,
       (SELECT AVG(quota) FROM import_licenses) AS parameter
FROM countries c
JOIN import_licenses i ON c.country_id = i.country_id
WHERE i.quota > (
    SELECT AVG(quota)
    FROM import_licenses
)
ORDER BY i.quota DESC;

-- Produk yang pernah diekspor
SELECT product_name
FROM products
WHERE product_id IN (
    SELECT product_id
    FROM exports
);

-- Negara yang pernah menerima ekspor
SELECT country_name
FROM countries
WHERE country_id IN (
    SELECT country_id
    FROM exports
);

-- Produk yang belum masuk daftar lisensi impor
SELECT product_name
FROM products
WHERE product_id NOT IN (
    SELECT product_id
    FROM import_licenses
);

-- Produk lebih mahal dari salah satu kategori 'Transport'
SELECT product_name, unit_price AS price_check
FROM products
WHERE unit_price > ANY (
    SELECT unit_price
    FROM products
    WHERE category = 'Transport'
);

-- Produk lebih mahal dari semua kategori 'Food'
SELECT product_name, unit_price
FROM products
WHERE unit_price > ALL (
    SELECT unit_price
    FROM products
    WHERE category = 'Food'
);

-- Produk di atas rata-rata harga semua produk
SELECT product_name, unit_price,
       (SELECT AVG(unit_price) FROM products) AS parameter
FROM products
WHERE unit_price > (
    SELECT AVG(unit_price)
    FROM products
);

-- Negara dengan total kuota di atas rata-rata semua kuota
SELECT c.country_name, i.quota
FROM countries c
JOIN import_licenses i ON c.country_id = i.country_id
WHERE i.quota > ALL (
    SELECT AVG(quota)
    FROM import_licenses
);

-- Produk dengan harga sama seperti 'Tablet'
SELECT product_name, unit_price
FROM products
WHERE unit_price = (
    SELECT unit_price
    FROM products
    WHERE product_name = 'Tablet'
);

-- Produk lebih mahal dari salah satu kategori 'Food'
SELECT product_name, unit_price
FROM products
WHERE unit_price > ANY (
    SELECT unit_price
    FROM products
    WHERE category = 'Food'
);
