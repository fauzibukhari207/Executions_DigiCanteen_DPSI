-- =====================================================================
-- DigiCanteen — Database Schema (PostgreSQL / Supabase)
-- Diturunkan dari docs/sot/database_design.md (SoT).
-- Jalankan berurutan dari atas ke bawah pada Supabase SQL Editor.
-- =====================================================================

CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id),
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('siswa','penjual')),
    wallet_balance NUMERIC(12,2) NOT NULL DEFAULT 0,
    points INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE menu_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    seller_id UUID NOT NULL REFERENCES profiles(id),
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    price NUMERIC(12,2) NOT NULL CHECK (price >= 0),
    discount_price NUMERIC(12,2),
    image_url TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('breakfast','lunch','snacks','drinks')),
    badges TEXT[] NOT NULL DEFAULT '{}',
    calories INT NOT NULL,
    protein INT,
    fat INT,
    ingredients TEXT[] NOT NULL DEFAULT '{}',
    custom_options JSONB NOT NULL DEFAULT '[]',
    is_available BOOLEAN NOT NULL DEFAULT true,
    stock INT NOT NULL CHECK (stock >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE group_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT UNIQUE NOT NULL,
    host_id UUID NOT NULL REFERENCES profiles(id),
    member_ids UUID[] NOT NULL DEFAULT '{}',
    status TEXT NOT NULL DEFAULT 'terbuka' CHECK (status IN ('terbuka','terkunci','selesai')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL REFERENCES profiles(id),
    group_order_id UUID REFERENCES group_orders(id),
    items JSONB NOT NULL,
    subtotal NUMERIC(12,2) NOT NULL,
    service_fee NUMERIC(12,2) NOT NULL,
    discount NUMERIC(12,2) NOT NULL DEFAULT 0,
    total NUMERIC(12,2) NOT NULL,
    pickup_time TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'menunggu-pembayaran'
        CHECK (status IN ('menunggu-pembayaran','menunggu-konfirmasi','diproses','siap-diambil','selesai-disajikan','dibatalkan')),
    payment_method TEXT NOT NULL CHECK (payment_method IN ('qris','saldo')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE table_checkins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id),
    student_id UUID NOT NULL REFERENCES profiles(id),
    table_number TEXT NOT NULL,
    check_in_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    check_out_at TIMESTAMPTZ,
    is_on_time BOOLEAN,
    points_earned INT
);

CREATE TABLE ratings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id),
    menu_item_id UUID NOT NULL REFERENCES menu_items(id),
    student_id UUID NOT NULL REFERENCES profiles(id),
    stars SMALLINT NOT NULL CHECK (stars BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (order_id, menu_item_id, student_id)
);

CREATE TABLE point_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL REFERENCES profiles(id),
    points INT NOT NULL,
    reason TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE vouchers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL REFERENCES profiles(id),
    points_cost INT NOT NULL,
    discount_amount NUMERIC(12,2) NOT NULL,
    is_used BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_menu_seller ON menu_items(seller_id);
CREATE INDEX idx_menu_category ON menu_items(category);
CREATE INDEX idx_menu_badges ON menu_items USING GIN (badges);
CREATE INDEX idx_orders_student ON orders(student_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE UNIQUE INDEX idx_group_orders_code ON group_orders(code);
CREATE INDEX idx_checkins_student ON table_checkins(student_id);
CREATE INDEX idx_ratings_menu_item ON ratings(menu_item_id);
CREATE INDEX idx_points_student ON point_history(student_id);
CREATE INDEX idx_vouchers_student ON vouchers(student_id);
