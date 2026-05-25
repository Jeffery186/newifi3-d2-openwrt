--[[
LuCI model for NoDogSplash Captive Portal Configuration
Path: Services → NoDogSplash → Landing Page

This creates the admin form in LuCI at:
http://192.168.10.1/cgi-bin/luci/admin/services/nodogsplash
]]--

require("luci.model.uci")
require("luci.fs")
require("nixio.fs")

local m = Map("nodogsplash", "NoDogSplash",
	translate("NoDogSplash Captive Portal"),
	translate("Configure guest WiFi captive portal with branded landing page, " ..
	          "advertisement countdown, and WhatsApp contact."))

m:section(Section, "general", translate("General Settings"))

local s = m:section(NamedSection, "general", "nodogsplash", translate("General"))
s.addremove = false
s.anonymous = true

-- Enable/Disable toggle
local o = s:option(Flag, "enabled", translate("Enable Captive Portal"))
o.default = "0"
o.rmempty = false

-- Gateway interface (guest WiFi interface)
o = s:option(Value, "gatewayinterface", translate("Guest WiFi Interface"))
o:value("wlan1", "wlan1 (Radio 0 - 2.4GHz)")
o:value("wlan0", "wlan0 (Radio 0 - 2.4GHz)")
o:value("wlan0-1", "wlan0-1 (Radio 0 - 5GHz)")
o:value("wlan1-1", "wlan1-1 (Radio 1 - 5GHz)")
o.datatype = "string"
o.placeholder = "wlan1"

-- Gateway name (SSID label)
o = s:option(Value, "gatewayname", translate("Portal Network Name"))
o.datatype = "string"
o.placeholder = "RateONE_Guest"

-- Session timeout
o = s:option(Value, "sessiontimeout", translate("Session Duration (seconds)"))
o.datatype = "uinteger"
o.placeholder = "3600"
o.description = translate("How long a guest can stay online before needing to re-authenticate. Default: 3600 (1 hour)")

-- Idle timeout
o = s:option(Value, "idletimeout", translate("Idle Timeout (seconds)"))
o.datatype = "uinteger"
o.placeholder = "1800"
o.description = translate("Kick clients after this long of inactivity. 0 = disabled. Default: 1800 (30 min)")

-- Max clients
o = s:option(Value, "maxclients", translate("Maximum Clients"))
o.datatype = "uinteger"
o.placeholder = "50"
o.description = translate("Maximum concurrent guests allowed on the portal.")

-- Upload/Download limits (0 = unlimited)
o = s:option(Value, "uploadlimit", translate("Upload Limit (KB/s)"))
o.datatype = "uinteger"
o.placeholder = "0"
o.description = translate("0 = unlimited. Set per-client speed limit in KB/s.")

o = s:option(Value, "downloadlimit", translate("Download Limit (KB/s)"))
o.datatype = "uinteger"
o.placeholder = "0"

-- ============================================================
-- LANDING PAGE SETTINGS
-- ============================================================
local ps = m:section(Section, "settings", translate("Landing Page Settings"))

local sp = ps:section(NamedSection, "settings", "settings", translate("Landing Page Customization"))
sp.addremove = false
sp.anonymous = true

-- Brand / Ad title
o = sp:option(Value, "ad_headline", translate("Advertisement Headline"))
o.datatype = "string"
o.placeholder = "Welcome to RateONE Guest WiFi"
o.description = translate("Main headline displayed on the landing page banner.")

-- Ad subtext
o = sp:option(Value, "ad_subtext", translate("Advertisement Subtext"))
o.datatype = "string"
o.placeholder = "Enjoy 1 hour free WiFi"
o.description = translate("Sub text below the headline on the ad banner.")

-- Ad by (brand name)
o = sp:option(Value, "ad_by", translate("Advertised By / Brand Name"))
o.datatype = "string"
o.placeholder = "RateONE"
o.description = translate("Shown in the 'Ad • By' info card on the landing page.")

-- Ad image URL
o = sp:option(Value, "ad_image_url", translate("Advertisement Image URL"))
o.datatype = "string"
o.placeholder = "https://your-domain.com/ad-banner.jpg"
o.description = translate("Full URL to a banner image (recommended: 728x90 or 320x150). " ..
	"Leave empty to show text placeholder.")

-- Countdown seconds
o = sp:option(Value, "countdown_secs", translate("Countdown Duration (seconds)"))
o.datatype = "uinteger"
o.placeholder = "10"
o.description = translate("How many seconds guests must wait before the 'Go Online' button is enabled. Default: 10")

-- Session duration in minutes (for display)
o = sp:option(Value, "session_dur", translate("Session Duration Display (minutes)"))
o.datatype = "uinteger"
o.placeholder = "60"
o.description = translate("Shown on the landing page info card. Default: 60")

-- ============================================================
-- WHATSAPP SETTINGS
-- ============================================================
local ws = m:section(Section, "whatsapp", translate("WhatsApp Contact"))

local wp = ws:section(NamedSection, "settings", "settings", translate("WhatsApp Integration"))
wp.addremove = false
wp.anonymous = true

-- WhatsApp number
o = wp:option(Value, "whatsapp_number", translate("WhatsApp Number"))
o.datatype = "string"
o.placeholder = "60123456789"
o.description = translate("Full number with country code, no + or spaces. " ..
	"E.g. 60123456789 for Malaysian number. Leave empty to hide WhatsApp button.")

-- WhatsApp label
o = wp:option(Value, "whatsapp_label", translate("WhatsApp Button Label"))
o.datatype = "string"
o.placeholder = "Chat with Us on WhatsApp"
o.description = translate("Text on the WhatsApp button. Leave empty for default.")

-- ============================================================
-- ACTIONS
-- ============================================================

-- Restart button
function m.on_commit(map)
	luci.sys.call("/etc/init.d/nodogsplash restart >/dev/null 2>&1")
end

-- Apply reload
function m.on_apply(map)
	luci.http.redirect(luci.dispatcher.build_url("admin", "services", "nodogsplash"))
end

return m