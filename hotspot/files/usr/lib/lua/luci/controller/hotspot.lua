--[[
  Hotspot Landing Page — LuCI Controller
  Adds menu entry: Services → Hotspot Landing
]]
module("luci.controller.hotspot", package.seeall)

function index()
  -- Register menu under Services
  entry(
    {"admin", "services", "hotspot"},
    cbi("hotspot-landing"),
    _("Hotspot Landing"),
    50
  )
end
