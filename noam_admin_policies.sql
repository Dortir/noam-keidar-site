-- ============================================================
-- Noam Keidar site — Admin write policies (Phase 3)
-- Run this in the Supabase SQL Editor AFTER the videos schema.
-- Grants full write access to LOGGED-IN (authenticated) users only.
-- The public site keeps read-only access to visible videos.
-- ============================================================

-- Authenticated users may INSERT new videos
create policy "authenticated can insert videos"
  on public.videos for insert
  to authenticated
  with check (true);

-- Authenticated users may UPDATE any video
create policy "authenticated can update videos"
  on public.videos for update
  to authenticated
  using (true)
  with check (true);

-- Authenticated users may DELETE any video
create policy "authenticated can delete videos"
  on public.videos for delete
  to authenticated
  using (true);

-- Authenticated users may also READ all videos (including hidden ones),
-- so the admin panel can show hidden videos too. Public still only sees visible.
create policy "authenticated reads all videos"
  on public.videos for select
  to authenticated
  using (true);
