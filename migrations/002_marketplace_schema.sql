-- Marketplace schema: products, sellers, orders, reviews, wishlists, cart
-- Supports multi-vendor with Stripe Connect, commission tracking, and full order lifecycle.

CREATE TABLE seller_profiles (
    seller_id       UUID PRIMARY KEY REFERENCES users(user_id),
    store_name      VARCHAR(200) NOT NULL,
    store_slug      VARCHAR(100) UNIQUE NOT NULL,
    description     TEXT,
    logo_url        TEXT,
    banner_url      TEXT,
    stripe_account_id VARCHAR(100),       -- Stripe Connect account ID (acct_xxx)
    stripe_onboarded BOOLEAN DEFAULT FALSE,
    commission_rate  DECIMAL(5,2) DEFAULT 12.00,  -- platform commission %
    rating_avg      DECIMAL(3,2) DEFAULT 0.00,
    rating_count    INT DEFAULT 0,
    status          VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending','active','suspended','banned')),
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE marketplace_categories (
    category_id     VARCHAR(50) PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    icon            VARCHAR(50) NOT NULL,
    sort_order      INT DEFAULT 0,
    parent_id       VARCHAR(50) REFERENCES marketplace_categories(category_id),
    is_active       BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE marketplace_products (
    product_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    seller_id       UUID NOT NULL REFERENCES seller_profiles(seller_id),
    title           VARCHAR(300) NOT NULL,
    description     TEXT,
    category_id     VARCHAR(50) NOT NULL REFERENCES marketplace_categories(category_id),
    price_cents     INT NOT NULL CHECK (price_cents >= 0),
    compare_at_cents INT,                 -- original price for showing discounts
    currency        VARCHAR(3) DEFAULT 'USD',
    sku             VARCHAR(100),
    inventory_count INT DEFAULT -1,       -- -1 = unlimited (digital goods)
    weight_grams    INT,
    shipping_required BOOLEAN DEFAULT FALSE,
    digital_asset_url TEXT,               -- S3 key for digital products
    status          VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft','pending_review','active','archived','rejected')),
    rejection_reason TEXT,
    tags            TEXT[],               -- full-text search tags
    rating_avg      DECIMAL(3,2) DEFAULT 0.00,
    rating_count    INT DEFAULT 0,
    sales_count     INT DEFAULT 0,
    view_count      INT DEFAULT 0,
    featured        BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE product_images (
    image_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id      UUID NOT NULL REFERENCES marketplace_products(product_id) ON DELETE CASCADE,
    url             TEXT NOT NULL,
    alt_text        VARCHAR(300),
    sort_order      INT DEFAULT 0,
    is_primary      BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE marketplace_orders (
    order_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    buyer_id        UUID NOT NULL REFERENCES users(user_id),
    seller_id       UUID NOT NULL REFERENCES seller_profiles(seller_id),
    status          VARCHAR(30) DEFAULT 'pending' CHECK (status IN (
        'pending','payment_processing','paid','shipped','delivered','completed',
        'cancelled','refund_requested','refunded','disputed'
    )),
    subtotal_cents  INT NOT NULL,
    commission_cents INT NOT NULL,         -- platform cut
    seller_payout_cents INT NOT NULL,      -- seller receives
    shipping_cents  INT DEFAULT 0,
    tax_cents       INT DEFAULT 0,
    total_cents     INT NOT NULL,
    currency        VARCHAR(3) DEFAULT 'USD',
    stripe_payment_intent_id VARCHAR(100),
    stripe_transfer_id       VARCHAR(100), -- Stripe Connect transfer to seller
    shipping_address JSONB,
    tracking_number VARCHAR(100),
    tracking_url    TEXT,
    notes           TEXT,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW(),
    paid_at         TIMESTAMP,
    shipped_at      TIMESTAMP,
    delivered_at    TIMESTAMP,
    completed_at    TIMESTAMP
);

CREATE TABLE order_items (
    item_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id        UUID NOT NULL REFERENCES marketplace_orders(order_id) ON DELETE CASCADE,
    product_id      UUID NOT NULL REFERENCES marketplace_products(product_id),
    title           VARCHAR(300) NOT NULL,  -- snapshot at time of purchase
    price_cents     INT NOT NULL,
    quantity        INT NOT NULL DEFAULT 1,
    image_url       TEXT,
    created_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE product_reviews (
    review_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id      UUID NOT NULL REFERENCES marketplace_products(product_id) ON DELETE CASCADE,
    reviewer_id     UUID NOT NULL REFERENCES users(user_id),
    order_id        UUID REFERENCES marketplace_orders(order_id),  -- verified purchase
    rating          INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title           VARCHAR(200),
    body            TEXT,
    helpful_count   INT DEFAULT 0,
    status          VARCHAR(20) DEFAULT 'published' CHECK (status IN ('published','hidden','flagged')),
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW(),
    UNIQUE(product_id, reviewer_id)  -- one review per buyer per product
);

CREATE TABLE wishlists (
    wishlist_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(user_id),
    product_id      UUID NOT NULL REFERENCES marketplace_products(product_id) ON DELETE CASCADE,
    created_at      TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, product_id)
);

CREATE TABLE seller_payouts (
    payout_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    seller_id       UUID NOT NULL REFERENCES seller_profiles(seller_id),
    order_id        UUID NOT NULL REFERENCES marketplace_orders(order_id),
    amount_cents    INT NOT NULL,
    currency        VARCHAR(3) DEFAULT 'USD',
    stripe_transfer_id VARCHAR(100),
    status          VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending','processing','completed','failed')),
    created_at      TIMESTAMP DEFAULT NOW(),
    completed_at    TIMESTAMP
);

-- Indexes for production query performance
CREATE INDEX idx_products_category ON marketplace_products(category_id) WHERE status = 'active';
CREATE INDEX idx_products_seller ON marketplace_products(seller_id);
CREATE INDEX idx_products_featured ON marketplace_products(featured, created_at DESC) WHERE status = 'active';
CREATE INDEX idx_products_search ON marketplace_products USING gin(to_tsvector('english', title || ' ' || COALESCE(description, '')));
CREATE INDEX idx_products_tags ON marketplace_products USING gin(tags);
CREATE INDEX idx_orders_buyer ON marketplace_orders(buyer_id, created_at DESC);
CREATE INDEX idx_orders_seller ON marketplace_orders(seller_id, created_at DESC);
CREATE INDEX idx_orders_status ON marketplace_orders(status);
CREATE INDEX idx_reviews_product ON product_reviews(product_id, created_at DESC) WHERE status = 'published';
CREATE INDEX idx_wishlists_user ON wishlists(user_id);
CREATE INDEX idx_product_images ON product_images(product_id, sort_order);

-- Seed marketplace categories
INSERT INTO marketplace_categories (category_id, name, icon, sort_order) VALUES
    ('heritage_travel', 'Heritage Travel', 'globe', 1),
    ('dna_wellness', 'DNA Wellness', 'dna', 2),
    ('genealogy_books', 'Genealogy Books', 'book', 3),
    ('heirlooms', 'Heirlooms & Craft', 'gift', 4),
    ('kinnect_kit', 'Kinnect Kit', 'package', 5);
