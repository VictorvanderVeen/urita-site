-- =============================================
-- Urita CMS - Database Schema
-- Email-to-Website CMS via n8n + Supabase
-- =============================================
--
-- n8n Workflow notities:
-- - Toegestane afzender (whitelist): victor@veen.co
-- - Later toevoegen: Urita's eigen emailadres
-- - n8n gebruikt service_role key voor schrijftoegang
-- =============================================

-- Tekst-secties (bio, tagline, etc.)
CREATE TABLE public.site_content (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  section_key TEXT NOT NULL UNIQUE,
  title TEXT,
  body TEXT,
  tags TEXT[],
  sort_order INT DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Muziek releases
CREATE TABLE public.muziek (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  titel TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('album', 'ep', 'single')),
  jaar INT NOT NULL,
  aantal_tracks INT,
  spotify_url TEXT,
  apple_music_url TEXT,
  soundcloud_url TEXT,
  gradient_from TEXT DEFAULT '#1a3318',
  gradient_to TEXT DEFAULT 'rgba(217,79,138,0.4)',
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Concerten
CREATE TABLE public.concerten (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  datum DATE NOT NULL,
  venue TEXT NOT NULL,
  stad TEXT NOT NULL,
  tijd TIME,
  ticket_url TEXT,
  status TEXT DEFAULT 'beschikbaar' CHECK (status IN ('beschikbaar', 'binnenkort', 'uitverkocht')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Social media links
CREATE TABLE public.social_links (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  platform TEXT NOT NULL UNIQUE,
  url TEXT NOT NULL,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Contactgegevens
CREATE TABLE public.contact_info (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  type TEXT NOT NULL UNIQUE,
  label TEXT NOT NULL,
  url TEXT,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Row Level Security: publiek lezen, geen schrijven
-- n8n gebruikt service_role key (bypassed RLS)
-- =============================================

ALTER TABLE public.site_content ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.muziek ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.concerten ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.social_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contact_info ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read site_content" ON public.site_content
  FOR SELECT USING (true);
CREATE POLICY "Public read muziek" ON public.muziek
  FOR SELECT USING (true);
CREATE POLICY "Public read concerten" ON public.concerten
  FOR SELECT USING (true);
CREATE POLICY "Public read social_links" ON public.social_links
  FOR SELECT USING (true);
CREATE POLICY "Public read contact_info" ON public.contact_info
  FOR SELECT USING (true);

-- =============================================
-- Seed data (huidige hardcoded content)
-- =============================================

INSERT INTO site_content (section_key, title, body, tags) VALUES
('tagline', NULL, 'muzikant', NULL),
('about', 'Over mij',
 'Mijn muziek groeit zoals bloemen in een tuin - organisch, kleurrijk en altijd in beweging. Van jongs af aan ben ik gefascineerd door de verbinding tussen klanken en de natuur om ons heen.

Als zangeres en songwriter weef ik verhalen over liefde, groei en het vinden van schoonheid in het onverwachte. Mijn sound is een mix van indie-folk, dromerige pop en akoestische warmte.

Wanneer ik niet in de studio ben, vind je me tussen de planten in botanische tuinen of schrijvend in een klein cafe ergens in de stad.',
 ARRAY['Zang', 'Songwriter', 'Indie-Folk', 'Akoestisch']),
('concerts_intro', NULL, 'Kom me live zien op een van de aankomende shows.', NULL),
('social_intro', NULL, 'Blijf op de hoogte van nieuwe muziek, shows en meer.', NULL);

INSERT INTO muziek (titel, type, jaar, aantal_tracks, sort_order, gradient_from, gradient_to) VALUES
('Bloeiend Seizoen', 'album', 2025, 10, 1, '#1a3318', 'rgba(217,79,138,0.4)'),
('Nachtbloemen', 'ep', 2024, 5, 2, 'rgba(155,77,202,0.5)', 'rgba(217,79,138,0.4)'),
('Eerste Licht', 'single', 2024, NULL, 3, 'rgba(240,201,75,0.5)', 'rgba(217,79,138,0.3)');

INSERT INTO concerten (datum, venue, stad, tijd, status) VALUES
('2026-03-14', 'Paradiso - Kleine Zaal', 'Amsterdam', '20:30', 'beschikbaar'),
('2026-03-28', 'TivoliVredenburg', 'Utrecht', '20:00', 'beschikbaar'),
('2026-04-11', 'Rotown', 'Rotterdam', '21:00', 'beschikbaar'),
('2026-05-02', 'Botanique', 'Brussel', '20:00', 'binnenkort');

INSERT INTO social_links (platform, url, sort_order) VALUES
('instagram', 'https://instagram.com/urita', 1),
('tiktok', 'https://tiktok.com/@urita', 2),
('spotify', 'https://open.spotify.com/artist/urita', 3),
('youtube', 'https://youtube.com/@urita', 4),
('facebook', 'https://facebook.com/urita', 5);

INSERT INTO contact_info (type, label, url, sort_order) VALUES
('email', 'hallo@urita.nl', 'mailto:hallo@urita.nl', 1),
('booking', 'booking@urita.nl', 'mailto:booking@urita.nl', 2);
