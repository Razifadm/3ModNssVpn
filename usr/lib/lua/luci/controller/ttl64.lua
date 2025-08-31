module("luci.controller.ttl64", package.seeall)

function index()
    entry({"admin", "status", "ttl64"}, call("action_ttl64"), _("MOD/Band"), 100)
end

-- Fungsi untuk tentukan mode semasa
function get_current_mode()
    local sys = require "luci.sys"
    local pdp = sys.exec("uci get qmodem.4_1.pdp_type 2>/dev/null"):gsub("\n", "")
    local flow = sys.exec("uci get firewall.@defaults[0].flow_offloading 2>/dev/null"):gsub("\n", "")

    if pdp == "ip" and flow == "0" then
        return "mod"
    elseif pdp == "ipv4v6" and flow == "0" then
        return "nss"
    elseif pdp == "ipv4v6" and flow == "1" then
        return "flow"
    elseif pdp == "ip" and flow == "1" then
        return "vpn"
    else
        return "unknown"
    end
end

-- Fungsi utama
function action_ttl64()
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
    elseif action == "flow" then
        sys.call("/usr/bin/modipv4.sh flow &")
        msg = "TurboAcc Mode applied."
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

    local current_mode = get_current_mode()

    tpl.render("admin_status/ttl64", {
        applied = msg,
        current_mode = current_mode
    })
end
