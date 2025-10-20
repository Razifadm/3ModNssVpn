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

    local action = http.formvalue("action")
    local msg = nil

    if action == "nss" then
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
    
    -- Blok Change Wan IP: Jalankan di latar belakang dan alihkan halaman
    elseif action == "Change Wan ip" then
        -- Jalankan skrip di latar belakang dan buang output
        sys.call("/usr/bin/wanip >/dev/null 2>&1 &") 
        
        -- Alihkan pengguna semula ke halaman ini dengan segera
        http.redirect(http.getenv("HTTP_REFERER"))
        return -- Hentikan fungsi di sini
    end

    -- Rendering halaman untuk semua tindakan lain
    local current_mode = get_current_mode()

    tpl.render("admin_status/ttl64", {
        applied = msg,
        current_mode = current_mode
    })
end
