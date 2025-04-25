CREATE DATABASE e_commerce;

USE e_commerce;

-- Brand table (companies that make products)
CREATE TABLE brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    brand_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product categories (hierarchical)
CREATE TABLE product_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INT NULL,
    FOREIGN KEY (parent_category_id) REFERENCES product_category(category_id)
);

-- Size categories (groups like clothing, shoes)
CREATE TABLE size_category (
    size_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

-- Size options (specific sizes)
CREATE TABLE size_option (
    size_id INT AUTO_INCREMENT PRIMARY KEY,
    size_category_id INT NOT NULL,
    size_value VARCHAR(20) NOT NULL,
    FOREIGN KEY (size_category_id) REFERENCES size_category(size_category_id)
);

-- Color options
CREATE TABLE color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    color_name VARCHAR(50) NOT NULL,
    hex_code VARCHAR(7)
);

-- Main product table
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    brand_id INT,
    category_id INT,
    base_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id),
    FOREIGN KEY (category_id) REFERENCES product_category(category_id)
);

-- Product variations (color/size combinations)
CREATE TABLE product_variation (
    variation_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    color_id INT,
    size_id INT,
    sku VARCHAR(50) UNIQUE,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (color_id) REFERENCES color(color_id),
    FOREIGN KEY (size_id) REFERENCES size_option(size_id)
);

-- Product items (inventory)
CREATE TABLE product_item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    variation_id INT NOT NULL,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    price_adjustment DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (variation_id) REFERENCES product_variation(variation_id)
);

-- Product images
CREATE TABLE product_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- Attribute classification
CREATE TABLE attribute_category (
    attr_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- Attribute types
CREATE TABLE attribute_type (
    attr_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL, -- 'text', 'number', 'boolean'
    data_type VARCHAR(20) NOT NULL -- VARCHAR, INT, BOOLEAN
);

-- Product attributes
CREATE TABLE product_attribute (
    attribute_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    attr_category_id INT,
    attr_type_id INT,
    attribute_name VARCHAR(100) NOT NULL,
    attribute_value TEXT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (attr_category_id) REFERENCES attribute_category(attr_category_id),
    FOREIGN KEY (attr_type_id) REFERENCES attribute_type(attr_type_id)
);



-- 1. Insert data into brand table
INSERT INTO brand (brand_id, brand_name, brand_description) VALUES
  (1, 'Patagonia', 'High-quality outdoor apparel and gear'),
  (2, 'Microsoft', 'Software, hardware, and cloud services'),
  (3, 'Uniqlo', 'Global casual wear retailer'),
  (4, 'Xiaomi', 'Innovative consumer electronics'),
  (5, 'Puma', 'Athletic and lifestyle footwear'),
  (6, 'Panasonic', 'Electronic devices and home appliances'),
  (7, 'Nikon', 'Optics and imaging products'),
  (8, 'Bosch', 'Industrial technology and power tools'),
  (9, 'Columbia', 'Outdoor clothing and equipment');

SELECT * FROM brand;

-- 2. Insert data into product_category table
INSERT INTO product_category (category_id, category_name, parent_category_id) VALUES
  (1, 'Apparel', NULL),
  (2, 'Electronics', NULL),
  (3, 'Outdoor Gear', NULL),
  (4, 'Smartphones', 2),
  (5, 'Laptops', 2),
  (6, 'Jackets', 1),
  (7, 'Tents', 3),
  (8, 'Sneakers', 1),
  (9, 'Kitchenware', NULL);

SELECT * FROM product_category;

-- 3. Insert data into size_category table
INSERT INTO size_category (size_category_id, category_name) VALUES
  (1, 'Clothing'),
  (2, 'Footwear'),
  (3, 'Backpack Capacity'),
  (4, 'Volume'),
  (5, 'Memory Capacity'),
  (6, 'Screen Size'),
  (7, 'Hat Size'),
  (8, 'Kids Clothing'),
  (9, 'Frame Size');

SELECT * FROM size_category;

-- 4. Insert data into size_option table
INSERT INTO size_option (size_id, size_category_id, size_value) VALUES
  (1, 1, 'XS'),
  (2, 1, 'S'),
  (3, 1, 'M'),
  (4, 2, '8'),
  (5, 2, '9'),
  (6, 2, '10'),
  (7, 3, '20L'),
  (8, 3, '30L'),
  (9, 4, '1.5L');

SELECT * FROM size_option;

-- 5. Insert data into color table
INSERT INTO color (color_id, color_name, hex_code) VALUES
  (1, 'Crimson', '#DC143C'),
  (2, 'Midnight Blue', '#191970'),
  (3, 'Charcoal', '#36454F'),
  (4, 'Ivory', '#FFFFF0'),
  (5, 'Slate Gray', '#708090'),
  (6, 'Coral', '#FF7F50'),
  (7, 'Forest Green', '#228B22'),
  (8, 'Sky Blue', '#87CEEB'),
  (9, 'Copper', '#B87333');

SELECT * FROM color;

-- 6. Insert data into product table
INSERT INTO product (product_id, product_name, brand_id, category_id, base_price) VALUES
  (1, 'Retro Fleece Jacket', 1, 6, 129.99),
  (2, 'Surface Laptop 5', 2, 5, 1499.00),
  (3, 'Ultralight Backpack', 3, 7, 179.50),
  (4, 'Mi Mix Fold', 4, 4, 1599.00),
  (5, 'Future Rider Sneaker', 5, 8, 110.00),
  (6, 'Lumix S5II', 6, 2, 1999.00),
  (7, 'Z9 II DSLR', 7, 2, 6499.00),
  (8, 'Cordless Hammer Drill', 8, 9, 189.99),
  (9, 'Thermal Omni Heat Vest', 9, 6, 99.00);

SELECT * FROM product;

-- 7. Insert data into product_variation table
INSERT INTO product_variation (variation_id, product_id, color_id, size_id, sku) VALUES
  (1, 1, 1, 3, 'PAT-JKT-CRIM-M'),
  (2, 1, 4, 2, 'PAT-JKT-IVRY-S'),
  (3, 2, 2, NULL, 'MSFT-SL5-MDB'),
  (4, 3, 7, NULL, 'UNI-BPK-UL-OLV'),
  (5, 4, 8, NULL, 'XIA-MIXFOLD-SKY'),
  (6, 5, 3, 5, 'PUM-FTRR-CHR-9'),
  (7, 6, 5, NULL, 'PAN-S5II-GRY'),
  (8, 7, 3, NULL, 'NIK-Z9II-CHR'),
  (9, 8, 6, NULL, 'BOS-HDRILL-COR');

SELECT * FROM product_variation;

-- 8. Insert data into product_item table
INSERT INTO product_item (item_id, variation_id, quantity_in_stock, price_adjustment) VALUES
  (1, 1, 20, 0.00),
  (2, 2, 35, 0.00),
  (3, 3, 12, -15.00),
  (4, 4, 28, 0.00),
  (5, 5, 18, 0.00),
  (6, 6, 7, 0.00),
  (7, 7, 9, 0.00),
  (8, 8, 45, 0.00),
  (9, 9, 10, 0.00);

SELECT * FROM product_item;

-- 9. Insert data into product_image table
INSERT INTO product_image (image_id, product_id, image_url, is_primary) VALUES
  (1, 1, 'https://cdn.example.com/patagonia-retro-fleece-crimson.jpg', 1),
  (2, 1, 'https://cdn.example.com/patagonia-retro-fleece-back.jpg', 0),
  (3, 2, 'https://cdn.example.com/surface-laptop5-front.jpg', 1),
  (4, 2, 'https://cdn.example.com/surface-laptop5-side.jpg', 0),
  (5, 3, 'https://cdn.example.com/ultralight-backpack.jpg', 1),
  (6, 4, 'https://cdn.example.com/mi-mix-fold-sky.jpg', 1),
  (7, 5, 'https://cdn.example.com/future-rider-charcoal.jpg', 1),
  (8, 6, 'https://cdn.example.com/lumix-s5ii-gray.jpg', 1),
  (9, 7, 'https://cdn.example.com/nikon-z9ii.jpg', 1);

SELECT * FROM product_image;

-- 10. Insert data into attribute_category table
INSERT INTO attribute_category (attr_category_id, category_name) VALUES
  (1, 'Technical Specifications'),
  (2, 'Materials'),
  (3, 'Dimensions'),
  (4, 'Features'),
  (5, 'Care Instructions'),
  (6, 'Power Details'),
  (7, 'Connectivity'),
  (8, 'Warranty'),
  (9, 'Performance Metrics');

SELECT * FROM attribute_category;

-- 11. Insert data into attribute_type table
INSERT INTO attribute_type (attr_type_id, type_name, data_type) VALUES
  (1, 'Text', 'VARCHAR'),
  (2, 'Integer', 'INT'),
  (3, 'Decimal', 'DECIMAL'),
  (4, 'Boolean', 'TINYINT'),
  (5, 'Date', 'DATE'),
  (6, 'Hex Code', 'VARCHAR'),
  (7, 'Weight', 'DECIMAL'),
  (8, 'Volume', 'DECIMAL'),
  (9, 'Capacity', 'VARCHAR');

SELECT * FROM attribute_type;

-- 12. Insert data into product_attribute table
INSERT INTO product_attribute (attribute_id, product_id, attr_category_id, attr_type_id, attribute_name, attribute_value) VALUES
  (1, 2, 1, 2, 'Processor Cores', '8'),
  (2, 2, 1, 3, 'Storage Capacity (GB)', '512.00'),
  (3, 3, 2, 1, 'Fabric Material', 'Ripstop Nylon'),
  (4, 4, 1, 3, 'Battery Capacity (mAh)', '5500.00'),
  (5, 5, 3, 7, 'Weight (oz)', '10.2'),
  (6, 6, 6, 6, 'Power Consumption (W)', '15'),
  (7, 7, 1, 2, 'Megapixels', '45'),
  (8, 8, 4, 4, 'Cordless Functionality', '1'),
  (9, 9, 2, 1, 'Lining Material', 'Polyester');



