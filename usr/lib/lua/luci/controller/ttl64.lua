module("luci.controller.ttl64", package.seeall)

function index()
    entry({"admin", "status", "ttl64"}, call("action_ttl64"), _("MOD/Band"), 100)
end

function action_ttl64()
    local uci = require "luci.model.uci".cursor()
    local sys = require "luci.sys"
    local http = require "luci.http"
    local tpl = require "luci.template"

    local action = http.formvalue("action")
    local msg = nil

    if action == "mod" then
        sys.call("/usr/bin/modipv4.sh mod &")
        msg = "Hotspot Mode applied."
    elseif action == "nss" then
        sys.call("/usr/bin/modipv4.sh nss &")
        msg = "NSS Mode applied."
    elseif action == "vpn" then
        sys.call("/usr/bin/modipv4.sh vpn &")
        msg = "VPN Mode applied."
    elseif action == "autoband" then
        sys.call("/usr/bin/modemtemp AUTOBAND &")
        msg = "Auto Band applied."
    elseif action == "lock4g" then
        sys.call("/usr/bin/modemtemp LOCK4G &")
        msg = "4G Lock applied."
    elseif action == "lock4g5g" then
        sys.call("/usr/bin/modemtemp LOCK4G5G &")
        msg = "4G+5G Lock applied."
    elseif action == "lock5gsa" then
        sys.call("/usr/bin/modemtemp LOCK5GSA &")
        msg = "NR5G-SA Lock applied."
    end

    tpl.render("admin_status/ttl64", {applied = msg})
end
