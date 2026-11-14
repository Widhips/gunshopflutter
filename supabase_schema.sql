-- ==============================================================================
-- GUN SHOP WAREHOUSE MANAGEMENT SYSTEM - SUPABASE SCHEMA & RLS SETUP
-- ==============================================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. ENUM / ROLES CHECK
-- Role: 'admin' OR 'user'

-- 3. PROFILES TABLE
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('admin', 'user')),
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 4. CATEGORIES TABLE
CREATE TABLE IF NOT EXISTS public.categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 5. INVENTORY TABLE
CREATE TABLE IF NOT EXISTS public.inventory (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    item_code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
    description TEXT,
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    location TEXT,
    qr_code TEXT, -- Stores item ID or unique code representation
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 6. ACTIVITY LOGS TABLE
CREATE TABLE IF NOT EXISTS public.activity_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    item_id UUID,
    action TEXT NOT NULL, -- 'CREATE_ITEM', 'UPDATE_ITEM', 'DELETE_ITEM', 'STOCK_ADJUSTMENT'
    old_data JSONB,
    new_data JSONB,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activity_logs ENABLE ROW LEVEL SECURITY;

-- Helper function to check if current authenticated user is an admin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'admin'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- --- Profiles Policies ---
-- Users can read all profiles (to view user list if needed, or their own profile)
CREATE POLICY "Profiles are readable by authenticated users"
ON public.profiles FOR SELECT
TO authenticated
USING (true);

-- Users can update only their own profile full_name, role changes restricted
CREATE POLICY "Users can update own profile"
ON public.profiles FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id AND role = (SELECT role FROM public.profiles WHERE id = auth.uid()));

-- Only admin or service role can insert / change roles
CREATE POLICY "Admins can manage all profiles"
ON public.profiles FOR ALL
TO authenticated
USING (public.is_admin());

-- --- Categories Policies ---
-- Authenticated users (admin & user) can view categories
CREATE POLICY "Categories viewable by authenticated users"
ON public.categories FOR SELECT
TO authenticated
USING (true);

-- Only admins can insert, update, delete categories
CREATE POLICY "Categories manageable only by admin"
ON public.categories FOR ALL
TO authenticated
USING (public.is_admin());

-- --- Inventory Policies ---
-- Both Admin and User can read inventory
CREATE POLICY "Inventory viewable by authenticated users"
ON public.inventory FOR SELECT
TO authenticated
USING (true);

-- Only Admin can insert, update, delete inventory items
CREATE POLICY "Inventory insertable only by admin"
ON public.inventory FOR INSERT
TO authenticated
WITH CHECK (public.is_admin());

CREATE POLICY "Inventory updatable only by admin"
ON public.inventory FOR UPDATE
TO authenticated
USING (public.is_admin());

CREATE POLICY "Inventory deletable only by admin"
ON public.inventory FOR DELETE
TO authenticated
USING (public.is_admin());

-- --- Activity Logs Policies ---
-- Authenticated users can insert activity log (e.g. actions performed)
CREATE POLICY "Authenticated users can insert activity logs"
ON public.activity_logs FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Only Admin can view activity logs
CREATE POLICY "Activity logs viewable only by admin"
ON public.activity_logs FOR SELECT
TO authenticated
USING (public.is_admin());

-- Nobody can delete or update activity logs (tamper-proof)
-- No UPDATE / DELETE policies created for activity_logs.

-- ==============================================================================
-- AUTOMATIC TRIGGERS
-- ==============================================================================

-- 1. Auto-update updated_at on inventory
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = TIMEZONE('utc'::text, NOW());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_inventory_updated
BEFORE UPDATE ON public.inventory
FOR EACH ROW
EXECUTE FUNCTION public.handle_updated_at();

-- 2. Auto-create profile record when a new user signs up via Supabase Auth
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, email, role)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', 'User'),
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'role', 'user')
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW
EXECUTE FUNCTION public.handle_new_user();

-- ==============================================================================
-- INITIAL SAMPLE DATA (OPTIONAL SEED)
-- ==============================================================================
INSERT INTO public.categories (name, description) VALUES
('Handguns / Pistols', 'Semi-automatic pistols and revolvers'),
('Rifles', 'Assault rifles, bolt-action, and marksman rifles'),
('Shotguns', 'Pump-action and semi-automatic shotguns'),
('Ammunition', 'Various calibers (9mm, 5.56x45mm, 7.62x51mm, 12 Gauge)'),
('Accessories & Optics', 'Scopes, suppressors, holsters, magazines, and cleaning kits')
ON CONFLICT (name) DO NOTHING;
