module("luci.controller.ttl64", package.seeall)

function index()
    entry({"admin", "tools", "ttl64"}, call("action_ttl64"), _("MOD/Band"), 100)
end

-- Fungsi untuk tentukan mode semasa
function get_current_mode()
    local sys = require "luci.sys"
    local pdp = sys.exec("uci get qmodem.4_1.pdp_type 2>/dev/null"):gsub("\n", "")
    local flow = sys.exec("uci get firewall.@defaults[0].flow_offloading 2>/dev/null"):gsub("\n", "")

    if pdp == "ipv4v6" and flow == "1" then
        return "nss"
    elseif pdp == "ip" and flow == "1" then
        return "vpn"
    else
        return "unknown"
    end
end

-- Fungsi utama untuk mengendalikan semua tindakan borang
function action_ttl64()
    local sys = require "luci.sys"
    local http = require "luci.http"
    local tpl = require "luci.template"
    -- Komen/Buang baris yang menyebabkan ralat:
    -- local msg = require "luci.msg" 
    local uci = require "luci.model.uci".cursor()

    local action = http.formvalue("action")
    local redirect_url = luci.dispatcher.build_url("admin", "tools", "ttl64")
    local success_msg = nil
    
    if action == "nss" then
        sys.call("/usr/bin/modipv4.sh nss &")
        success_msg = "NSS Mode applied."
    elseif action == "vpn" then
        sys.call("/usr/bin/modipv4.sh vpn &")
        success_msg = "VPN Mode applied."
    elseif action == "autoband" then
        sys.call("/usr/bin/modemtemp AUTOBAND &")
        success_msg = "Auto Band applied."
    elseif action == "lock4g" then
        sys.call("/usr/bin/modemtemp LOCK4G &")
        success_msg = "4G Lock applied."
    elseif action == "lock4g5g" then
        sys.call("/usr/bin/modemtemp LOCK4G5G &")
        success_msg = "4G+5G Lock applied."
    elseif action == "lock5gsa" then
        sys.call("/usr/bin/modemtemp LOCK5GSA &")
        success_msg = "NR5G-SA Lock applied."
    
    -- BLOK 'CHANGE WAN IP'
    elseif action == "Change Wan ip" then
        sys.call("/usr/bin/wanip >/dev/null 2>&1") 
        success_msg = "Wan ip renew"
    end
    
    -- LAKSANAKAN REDIRECT SELEPAS TINDAKAN (PRG pattern)
    if action and success_msg then
        -- KOD BARU: Aliihkan dengan mesej kejayaan dalam URL
        http.redirect(redirect_url .. "?applied=" .. http.urlencode(success_msg))
        return
    end

    -- RENDERING LAMA (Untuk GET request)
    local current_mode = get_current_mode()
    
    -- DAPATKAN MESEJ KEJAYAAN DARI URL JIKA ADA
    local applied_msg = http.formvalue("applied")

    tpl.render("admin_status/ttl64", {
        current_mode = current_mode,
        applied = applied_msg -- Hantar mesej yang diambil dari URL
    })
end

