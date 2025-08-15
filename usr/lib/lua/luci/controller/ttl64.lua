module("luci.controller.ttl64", package.seeall)

function index()
    entry({"admin", "status", "ttl64"}, call("action_ttl64"), _("Mod/Nss/vpn"), 100)
end

function action_ttl64()
    local uci = require "luci.model.uci".cursor()
    local sys = require "luci.sys"
    local http = require "luci.http"
    local tpl = require "luci.template"

    local action = http.formvalue("action")

    if action == "mod" then
        sys.call("/usr/bin/modipv4.sh mod &")
    elseif action == "nss" then
        sys.call("/usr/bin/modipv4.sh nss &")
    elseif action == "vpn" then
        sys.call("/usr/bin/modipv4.sh vpn &")
    end

    tpl.render("admin_status/ttl64")
end
