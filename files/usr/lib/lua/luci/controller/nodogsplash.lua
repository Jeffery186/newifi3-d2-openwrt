--[[
LuCI controller for NoDogSplash
Path: Services → NoDogSplash

Maps to: /cgi-bin/luci/admin/services/nodogsplash
]]--

module("luci.controller.nodogsplash", package.seeall)

function index()
	-- Add menu entry under Services
	entry({"admin", "services", "nodogsplash"},
		firstchild(),
		"NoDogSplash",
		60).dependent = false

	-- Main config page
	entry({"admin", "services", "nodogsplash", "general"},
		alias("admin", "services", "nodogsplash"),
		translate("Captive Portal"),
		10)

	-- This maps to our model (cbi/nodogsplash.lua)
	entry({"admin", "services", "nodogsplash", "general"},
		cbi("nodogsplash"),
		translate("Landing Page Settings"),
		10)

	-- Status page (shows connected clients)
	entry({"admin", "services", "nodogsplash", "status"},
		template("nodogsplash/status"),
		translate("Client Status"),
		20)

	-- API: restart service
	entry({"admin", "services", "nodogsplash", "restart"},
		call("restart_nodogsplash"),
		translate("Restart"),
		1)

	-- WiFi-guest config
	entry({"admin", "services", "nodogsplash", "wifi"},
		cbi("nodogsplash_wifi"),
		translate("Guest WiFi Settings"),
		30)
end

function restart_nodogsplash()
	luci.sys.call("/etc/init.d/nodogsplash restart")
	luci.http.prepare_content("application/json")
	luci.http.write_json({ success = true, message = "NoDogSplash restarted" })
end