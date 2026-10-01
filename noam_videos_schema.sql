-- ============================================================
-- Noam Keidar site — video management schema
-- Run this in the Supabase SQL Editor (new project for Noam)
-- ============================================================

-- Clean start (safe to re-run)
drop table if exists public.videos cascade;

create table public.videos (
  id           bigint generated always as identity primary key,
  youtube_id   text not null,
  title_he     text not null default '',
  title_en     text not null default '',
  client_he    text not null default '',
  client_en    text not null default '',
  desc_he      text not null default '',
  desc_en      text not null default '',
  section      text not null default 'portfolio'
                 check (section in ('portfolio','testimonial')),
  sort_order   int  not null default 0,
  is_visible   boolean not null default true,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

-- Keep updated_at fresh on edits
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

create trigger videos_touch
  before update on public.videos
  for each row execute function public.touch_updated_at();

-- Index for fast ordered reads
create index videos_section_order_idx on public.videos (section, sort_order);

-- ============================================================
-- Row Level Security
-- Public site: read only visible videos. Admin panel: full access
-- via the service_role key (used server-side only).
-- ============================================================
alter table public.videos enable row level security;

-- Anyone (anon) may READ visible videos — this is what the public site uses
create policy "public reads visible videos"
  on public.videos for select
  using (is_visible = true);

-- Writes are NOT allowed to anon/authenticated here; the admin panel will
-- use the service_role key server-side, which bypasses RLS. So we add no
-- write policies for anon — keeping the data safe from public tampering.

-- ============================================================
-- Seed data: the 31 videos currently on the site
-- ============================================================

insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('prS_-I7vi_8','שואוריל','Showreel','נועם קידר הפקות','סיפור בצורה שמרגישה אחרת — שואוריל נועם קידר הפקות.','portfolio',10,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('49ccTtgcFrI','תולדות אחרית הימים','The End of Days','ערוץ מאיר / YES','סרט תיעודי על אחרית הימים מנקודת מבט יהודית, שודר בערוץ מאיר.','portfolio',20,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('DAHJ0mGFJ3A','מסע כומתה','Beret March','ערוץ מאיר לילדים','הפרק הראשון בתוכנית הטיולים של ערוץ מאיר לילדים.','portfolio',30,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('ej6Rh4bMVcA','הכנסת ספר תורה','Torah Scroll Dedication','ישיבת מעלה אליהו','בהשתתפות נשיא המדינה, לעילוי נשמת סרן לירון שניר הי"ד.','portfolio',40,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('zRF90lljf08','בית בטוח - מועצה גוש עציון','Safe Home — Gush Etzion','מועצה אזורית גוש עציון','פרויקט בית בטוח לגיל השלישי בגוש עציון.','portfolio',50,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('BvO336MBojE','סיירת סבתא','Grandma Patrol','חמדיגיטלי','מיזם ייחודי שמחבר בין דורות דרך טכנולוגיה.','portfolio',60,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('5bU8EBTee4c','טריילר משכן התכלת','Mishkan HaTchelet Trailer','פרויקט נדלן','טריילר קולנועי לפרויקט מגורים יוקרתי.','portfolio',70,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('pu0wQCDxrIQ','פאר תחת אפר','Beauty for Ashes','יום גוש קטיף','קדימון — יום גוש קטיף במערכת החינוך.','portfolio',80,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('LWWShMpu7Kk','מצות לכולם','Matzot for All','מיזם חכימא','סרטון חינוכי על נגישות מצות לכולם.','portfolio',90,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('qZZ8Hao2wCg','החידא','The Chida','מיזם חכימא','דוקומנטרי על הרב חיד"א — מגדולי הפוסקים.','portfolio',100,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('ZbGNYOHnQGY','מערך מתגיירים','Conversion Program','מערך הגיור','סרטון עבור מערך הגיור הלאומי.','portfolio',110,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('R_hRq8JYjXE','גן גורו','Gan Garoo','גן גורו','סרטון תדמית לגן החיות האוסטרלי גן גורו.','portfolio',120,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('nFXyuIFB89U','הלביאות שלנו','Our Lionesses','מועצה אזורית גוש עציון','נשים מוציאות רישיון לאקדח במועצה האזורית גוש עציון.','portfolio',130,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('DeT1FbZkhy0','כיתת כוננות במיצד','Emergency Squad — Metzad','מיצד','חרדים לבטחון — כיתת הכוננות במיצד.','portfolio',140,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('1d9Rowz-ILQ','הכירו את אגדה','Meet Agada','אגדה','סרטון היכרות עם אגדה — בית סיפורי העם היהודי.','portfolio',150,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('3Lebr-qJBQE','בר מצווה בכותל המערבי','Bar Mitzvah at the Kotel','הקרן למורשת הכותל','חוויית בר מצווה בכותל המערבי.','portfolio',160,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('8MZ0gRqmGOU','80 שנה לגוש עציון','80 Years of Gush Etzion','מועצה אזורית גוש עציון','80 שנה לגוש עציון! האנשים עושים את המקום.','portfolio',170,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('OyQZo7ME7Cg','ברית גרר','The Covenant of Gerar','מרכז קטיף','על הברית של אברהם עם אבימלך — בימוי, צילום ועריכה: נועם קידר.','portfolio',180,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('trhH_K3chsQ','להתענג בתענוגים','LeHitaneg BeTaanugim','הרכב מוזיקלי','קליפ מוזיקלי לפיוט שבת. צילום ועריכה: נועם קידר.','portfolio',190,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('L_ByHcHSa-M','סיירת סבתא - ראש חודש שבט','Grandma Patrol — Shvat','חמדיגיטלי','פרק נוסף בסדרת סיירת סבתא.','portfolio',200,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('2sk7sWt9m1Q','בירה במדבר','Beer in the Desert','פסטיבל תקוע','פסטיבל הבירה בתקוע — אוירה, מוזיקה ואנשים יפים.','portfolio',210,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('5LaHv7NhCNI','מלון ליטוב בכותל','Litov Hotel at the Kotel','רשת מלונות ליטוב','סרטון תדמית למלון ליטוב בכותל.','portfolio',220,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('OWIVimyfWDg','מרכז מבקרים תפילין בית אל','Tefillin Beit El Visitor Center','תפילין בית אל','חוויה ערכית ומרגשת לכל המשפחה.','portfolio',230,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('0u_-1hICSeM','שיר תודה','A Song of Thanks','יהודה כץ והמעגל','קליפ מוזיקלי רשמי לאמן יהודה כץ.','portfolio',240,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('6l4F7y_OuCM','אבא ליום אחד - פייטן','Dad for a Day — Paytan','תוכנית טלוויזיה','פרק מסדרת הטלוויזיה אבא ליום אחד.','portfolio',250,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('yEyr9zd6RuA','אבא ליום אחד - מצנחי רחיפה','Dad for a Day — Paragliding','תוכנית טלוויזיה','הרפתקה של מצנחי רחיפה מעל הגלבוע.','portfolio',260,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('XAMvytyOhVM','הודו לשם - טריילר','Your Sweet Light — Trailer','מעלה VOD','טריילר — התמודדות זוגית בצל שליחות.','portfolio',270,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('9AO3BpwUxBU','גלאט שפיל - מאחורי הקלעים','Glat Spiel — Behind the Scenes','גלאט שפיל','תיעוד מאחורי הקלעים של הופעה חסידית.','portfolio',280,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('TGkHbhhvJRk','שלמה אברהמי','Shlomo Avrahami','לקוח','עבדנו עם נועם על פרויקט תדמית מורכב.','testimonial',10,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('ehiqPIh_Hpw','אריק ורצבורגר','Arik Wurzburger','לקוח','','testimonial',20,true);
insert into public.videos (youtube_id,title_he,title_en,client_he,desc_he,section,sort_order,is_visible) values ('bef3GOej2mw','שרה בק','Sara Bak','מיזם חכימא','נועם מבין סיפור אנושי.','testimonial',30,true);
