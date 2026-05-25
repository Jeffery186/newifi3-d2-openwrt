--[[
  Hotspot Landing Page — CBI Configuration Form
  Auto-generates a web form from /etc/config/hotspot-landing
  Accessible at: LuCI → Services → Hotspot Landing
]]

local m = Map("hotspot-landing", translate("Hotspot Landing Page"),
  translate("Configure the WiFi captive portal landing page — advertisement packages, WhatsApp number, countdown timer, and branding."))

-- ═══════════════════════════════════════════
-- Section: Branding
-- ═══════════════════════════════════════════
local s1 = m:section(NamedSection, "main", "landing", translate("Page Branding"))

s1:option(Value, "page_title", translate("Page Title"))
s1:option(Value, "page_subtitle", translate("Page Subtitle"))
s1:option(Value, "logo_url", translate("Logo URL (optional)"))
s1:option(Value, "background_color", translate("Background Color (hex)"))

-- ═══════════════════════════════════════════
-- Section: Advertisement
-- ═══════════════════════════════════════════
local s2 = m:section(NamedSection, "main", "landing", translate("Advertisement Banner"))

s2:option(Flag, "ad_enabled", translate("Show Advertisement"))
s2:option(Value, "ad_title", translate("Ad Title"))
s2:option(Value, "ad_tagline", translate("Ad Tagline"))

-- Package 1
local p1 = s2:option(Flag, "pkg1_enabled", translate("Package 1 — Show"))
p1.rmempty = false
s2:option(Value, "pkg1_speed", translate("Package 1 Speed"))
s2:option(Value, "pkg1_price", translate("Package 1 Price"))
s2:option(Value, "pkg1_validity", translate("Package 1 Validity"))

-- Package 2
local p2 = s2:option(Flag, "pkg2_enabled", translate("Package 2 — Show"))
p2.rmempty = false
s2:option(Value, "pkg2_speed", translate("Package 2 Speed"))
s2:option(Value, "pkg2_price", translate("Package 2 Price"))
s2:option(Value, "pkg2_validity", translate("Package 2 Validity"))

-- Package 3
local p3 = s2:option(Flag, "pkg3_enabled", translate("Package 3 — Show"))
p3.rmempty = false
s2:option(Value, "pkg3_speed", translate("Package 3 Speed"))
s2:option(Value, "pkg3_price", translate("Package 3 Price"))
s2:option(Value, "pkg3_validity", translate("Package 3 Validity"))

-- ═══════════════════════════════════════════
-- Section: WhatsApp
-- ═══════════════════════════════════════════
local s3 = m:section(NamedSection, "main", "landing", translate("WhatsApp Button"))

s3:option(Flag, "whatsapp_enabled", translate("Show WhatsApp Button"))
s3:option(Value, "whatsapp_number", translate("WhatsApp Number"),
  translate("Full international number without + or spaces, e.g. 601161956105"))
s3:option(Value, "whatsapp_message", translate("Pre-filled Message"))
s3:option(Value, "whatsapp_label", translate("Button Label"))

-- ═══════════════════════════════════════════
-- Section: Timer & Button
-- ═══════════════════════════════════════════
local s4 = m:section(NamedSection, "main", "landing", translate("Countdown Timer"))

s4:option(Value, "countdown_seconds", translate("Countdown Seconds"),
  translate("How many seconds before the 'Click to Online' button appears"))
s4:option(Value, "timer_label", translate("Timer Running Label"))
s4:option(Value, "timer_done_label", translate("Timer Done Label"))

-- ═══════════════════════════════════════════
-- Section: Button
-- ═══════════════════════════════════════════
local s5 = m:section(NamedSection, "main", "landing", translate("Online Button"))

s5:option(Value, "button_label", translate("Button Label"))
s5:option(Value, "footer_text", translate("Footer Text"))

return m
