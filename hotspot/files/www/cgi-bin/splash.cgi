#!/bin/sh
#
# Hotspot Landing Page — Dynamic CGI
# Served by uhttpd at /cgi-bin/splash.cgi
# Reads settings from UCI: /etc/config/hotspot-landing
#
# Nodogsplash redirects clients here:
#   http://192.168.10.1/cgi-bin/splash.cgi?redir=<original_url>
#

echo "Content-Type: text/html"
echo ""

# ── Load UCI config with defaults ──
uci_get() {
  local val
  val=$(uci -q get hotspot-landing.main."$1")
  echo "${val:-$2}"
}

PAGE_TITLE=$(uci_get page_title "Free WiFi Hotspot")
PAGE_SUBTITLE=$(uci_get page_subtitle "Welcome! Please wait to continue...")
LOGO_URL=$(uci_get logo_url "")
BG_COLOR=$(uci_get background_color "#0f2027")

AD_ENABLED=$(uci_get ad_enabled "1")
AD_TITLE=$(uci_get ad_title "Internet Packages")
AD_TAGLINE=$(uci_get ad_tagline "High-speed fibre broadband for your home")

PKG1_ENABLED=$(uci_get pkg1_enabled "1")
PKG1_SPEED=$(uci_get pkg1_speed "30Mbps")
PKG1_PRICE=$(uci_get pkg1_price "RM 89/mo")
PKG1_VALIDITY=$(uci_get pkg1_validity "Unlimited")

PKG2_ENABLED=$(uci_get pkg2_enabled "1")
PKG2_SPEED=$(uci_get pkg2_speed "100Mbps")
PKG2_PRICE=$(uci_get pkg2_price "RM 129/mo")
PKG2_VALIDITY=$(uci_get pkg2_validity "Unlimited")

PKG3_ENABLED=$(uci_get pkg3_enabled "1")
PKG3_SPEED=$(uci_get pkg3_speed "500Mbps")
PKG3_PRICE=$(uci_get pkg3_price "RM 199/mo")
PKG3_VALIDITY=$(uci_get pkg3_validity "Unlimited")

WA_ENABLED=$(uci_get whatsapp_enabled "1")
WA_NUMBER=$(uci_get whatsapp_number "601161956105")
WA_MESSAGE=$(uci_get whatsapp_message "Hi, I am interested in your internet packages.")
WA_LABEL=$(uci_get whatsapp_label "Chat on WhatsApp")

COUNTDOWN=$(uci_get countdown_seconds "10")
TIMER_LABEL=$(uci_get timer_label "seconds until you can go online")
TIMER_DONE=$(uci_get timer_done_label "You may now go online")

BTN_LABEL=$(uci_get button_label "✅ Click to Online")
FOOTER=$(uci_get footer_text "Contact us for the best internet deals!")

# URL-encode WhatsApp message
WA_MSG_ENC=$(echo "$WA_MESSAGE" | sed 's/ /%20/g')

# ── Output the splash page ──
cat <<PAGE_HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${PAGE_TITLE}</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: linear-gradient(135deg, ${BG_COLOR} 0%, #203a43 50%, #2c5364 100%);
      min-height: 100vh;
      display: flex; align-items: center; justify-content: center;
      padding: 16px;
    }
    .card {
      background: #fff; border-radius: 20px; max-width: 420px; width: 100%;
      overflow: hidden; box-shadow: 0 25px 60px rgba(0,0,0,0.4);
    }
    .ad-section {
      background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%);
      padding: 24px 20px; text-align: center; color: #fff;
    }
    .ad-section h2 { font-size: 20px; font-weight: 700; margin-bottom: 4px; }
    .ad-section .tagline { font-size: 13px; opacity: 0.9; margin-bottom: 14px; }
    .packages { display: flex; gap: 10px; flex-wrap: wrap; justify-content: center; }
    .pkg {
      background: rgba(255,255,255,0.18); backdrop-filter: blur(6px);
      border-radius: 12px; padding: 12px 14px; min-width: 90px; text-align: center;
    }
    .pkg .speed { font-size: 22px; font-weight: 800; }
    .pkg .price { font-size: 14px; font-weight: 600; margin-top: 2px; }
    .pkg .validity { font-size: 11px; opacity: 0.8; margin-top: 2px; }
    .main-body { padding: 28px 24px 32px; text-align: center; }
    .wifi-icon {
      width: 64px; height: 64px; background: #e8f5e9; border-radius: 50%;
      display: flex; align-items: center; justify-content: center; margin: 0 auto 16px;
    }
    .wifi-icon svg { width: 36px; height: 36px; fill: #2e7d32; }
    .main-body h1 { font-size: 22px; color: #1a1a2e; margin-bottom: 6px; }
    .main-body .subtitle { font-size: 14px; color: #666; margin-bottom: 20px; }
    .timer-box { background: #f5f5f5; border-radius: 14px; padding: 16px; margin-bottom: 20px; }
    .timer-box .countdown { font-size: 48px; font-weight: 800; color: #2c5364; }
    .timer-box .timer-label { font-size: 13px; color: #999; margin-top: 2px; }
    .btn-online {
      display: none; width: 100%; padding: 16px;
      background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
      border: none; border-radius: 14px; color: #fff; font-size: 18px;
      font-weight: 700; cursor: pointer;
      transition: transform 0.2s, box-shadow 0.2s;
      box-shadow: 0 6px 20px rgba(17,153,142,0.35);
    }
    .btn-online.show { display: block; }
    .btn-online:hover { transform: translateY(-2px); box-shadow: 0 10px 28px rgba(17,153,142,0.5); }
    .btn-online:active { transform: scale(0.97); }
    .whatsapp-section { margin-top: 20px; }
    .btn-whatsapp {
      display: inline-flex; align-items: center; gap: 8px;
      padding: 12px 24px; background: #25d366; color: #fff;
      border-radius: 30px; text-decoration: none; font-weight: 600; font-size: 15px;
      transition: transform 0.2s, box-shadow 0.2s;
      box-shadow: 0 4px 14px rgba(37,211,102,0.35);
    }
    .btn-whatsapp:hover { transform: translateY(-2px); box-shadow: 0 8px 22px rgba(37,211,102,0.5); }
    .btn-whatsapp svg { width: 22px; height: 22px; fill: #fff; }
    .footer-note { margin-top: 16px; font-size: 12px; color: #aaa; }
  </style>
</head>
<body>
  <div class="card">
PAGE_HTML

# ── Advertisement Section ──
if [ "$AD_ENABLED" = "1" ]; then
  cat <<AD_HTML
    <div class="ad-section">
      <h2>🚀 ${AD_TITLE}</h2>
      <p class="tagline">${AD_TAGLINE}</p>
      <div class="packages">
AD_HTML
  [ "$PKG1_ENABLED" = "1" ] && echo "        <div class=\"pkg\"><div class=\"speed\">${PKG1_SPEED}</div><div class=\"price\">${PKG1_PRICE}</div><div class=\"validity\">${PKG1_VALIDITY}</div></div>"
  [ "$PKG2_ENABLED" = "1" ] && echo "        <div class=\"pkg\"><div class=\"speed\">${PKG2_SPEED}</div><div class=\"price\">${PKG2_PRICE}</div><div class=\"validity\">${PKG2_VALIDITY}</div></div>"
  [ "$PKG3_ENABLED" = "1" ] && echo "        <div class=\"pkg\"><div class=\"speed\">${PKG3_SPEED}</div><div class=\"price\">${PKG3_PRICE}</div><div class=\"validity\">${PKG3_VALIDITY}</div></div>"
  cat <<AD_END
      </div>
    </div>
AD_END
fi

# ── Main Body ──
cat <<BODY_HTML
    <div class="main-body">
      <div class="wifi-icon">
        <svg viewBox="0 0 24 24"><path d="M12 21l-2-2h4l-2 2zm-9.07-7.07c3.9-3.9 10.24-3.9 14.14 0l-1.41 1.41c-3.12-3.12-8.19-3.12-11.31 0l-1.42-1.41zm2.83-2.83c2.35-2.35 6.14-2.35 8.49 0l-1.41 1.41c-1.57-1.57-4.1-1.57-5.66 0l-1.42-1.41zM5.64 8.36c3.54-3.54 9.28-3.54 12.82 0L17.05 9.77c-2.77-2.77-7.25-2.77-10.01 0L5.64 8.36z"/></svg>
      </div>
      <h1>${PAGE_TITLE}</h1>
      <p class="subtitle">${PAGE_SUBTITLE}</p>

      <div class="timer-box">
        <div class="countdown" id="timer">${COUNTDOWN}</div>
        <div class="timer-label" id="timerLabel">${TIMER_LABEL}</div>
      </div>

      <button class="btn-online" id="btnOnline" onclick="goOnline()">
        ${BTN_LABEL}
      </button>
BODY_HTML

# ── WhatsApp Button ──
if [ "$WA_ENABLED" = "1" ]; then
  cat <<WA_HTML
      <div class="whatsapp-section">
        <a class="btn-whatsapp"
           href="https://wa.me/${WA_NUMBER}?text=${WA_MSG_ENC}"
           target="_blank">
          <svg viewBox="0 0 24 24"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/></svg>
          ${WA_LABEL}
        </a>
      </div>
WA_HTML
fi

cat <<FOOTER_HTML
      <p class="footer-note">${FOOTER}</p>
    </div>
  </div>

  <script>
    var seconds = ${COUNTDOWN};
    var timerEl = document.getElementById('timer');
    var timerLabel = document.getElementById('timerLabel');
    var btnOnline = document.getElementById('btnOnline');

    var countdown = setInterval(function() {
      seconds--;
      timerEl.textContent = seconds;
      if (seconds <= 0) {
        clearInterval(countdown);
        timerEl.textContent = '0';
        timerLabel.textContent = '${TIMER_DONE}';
        btnOnline.classList.add('show');
      }
    }, 1000);

    function goOnline() {
      var authtarget = "\$authtarget";
      if (authtarget && authtarget.charAt(0) !== "\$") {
        window.location.href = authtarget;
      } else {
        var match = location.href.match(/[?&]redir=([^&]+)/);
        if (match) {
          window.location.href = decodeURIComponent(match[1]);
        } else {
          window.location.href = "http://captive.apple.com/hotspot-detect.html";
        }
      }
    }
  </script>
</body>
</html>
FOOTER_HTML
