#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
/usr/bin/time -p bash -c 'echo "Capture: URL=${CAPTURE_URL:-<unset>} DIR=${CAPTURE_DIR:-<unset>}"'
/usr/bin/time -p bash -c 'test -n "${CAPTURE_URL:-}" || { echo "CAPTURE_URL is required" >&2; exit 1; }'
/usr/bin/time -p bash -c 'test -n "${CAPTURE_DIR:-}" || { echo "CAPTURE_DIR is required" >&2; exit 1; }'
/usr/bin/time -p mkdir -p "$CAPTURE_DIR"
/usr/bin/time -p node - <<'NODEJS'
const { mkdirSync, statSync } = require('node:fs');
const { join } = require('node:path');
const url = process.env.CAPTURE_URL;
const output = process.env.CAPTURE_DIR;
if (!url || !output) { console.error('Set CAPTURE_URL and CAPTURE_DIR.'); process.exit(1); }
mkdirSync(output, { recursive: true });
let playwrightPath = process.env.HOME + '/.local/share/omgithub-playwright/node_modules/playwright';
let chromium;
try { ({ chromium } = require(playwrightPath)); }
catch (e) { console.error('Playwright load failed (defect):', e.message); process.exit(1); }
const transientStatus = new Set([408, 429, 500, 502, 503, 504]);
(async () => {
  let browser;
  try {
    try {
      browser = await chromium.launch({ headless: true, timeout: 30000, args: ['--no-sandbox', '--disable-dev-shm-usage', '--disable-gpu'] });
    } catch (e) { console.error('Browser launch failed (transient):', e.message); process.exit(75); }
    for (const [name, width, height] of [['desktop', 1440, 900], ['mobile', 390, 844]]) {
      let context, page;
      try {
        context = await browser.newContext({ viewport: { width, height }, deviceScaleFactor: 1 });
        page = await context.newPage();
        page.setDefaultTimeout(30000);
        page.on('pageerror', err => console.error(`pageerror ${name}:`, err.message));
        let response;
        try {
          response = await page.goto(url, { waitUntil: 'load', timeout: 45000 });
        } catch (e) {
          console.error(`Navigation ${name} failed (transient):`, e.message);
          process.exit(75);
        }
        if (!response) { console.error(`No response ${name} (transient)`); process.exit(75); }
        const status = response.status();
        if (!response.ok()) {
          console.error(`HTTP ${status} loading preview (${name})`);
          process.exit(!response || transientStatus.has(status) ? 75 : 1);
        }
        try {
          await page.locator('body').waitFor({ state: 'visible', timeout: 30000 });
          await page.waitForFunction(() => document.fonts ? document.fonts.status === 'loaded' : true, null, { timeout: 15000 });
        } catch (e) {
          console.error(`Wait for content ${name} failed:`, e.message);
          process.exit(e.name === 'TimeoutError' ? 75 : 1);
        }
        await page.waitForTimeout(1200);
        const textLen = await page.evaluate(() => document.body ? document.body.innerText.length : 0).catch(() => 0);
        if (textLen < 10) { console.error(`Blank render ${name}: textLen=${textLen} (defect)`); process.exit(1); }
        const dest = join(output, `final-${name}.png`);
        try {
          await page.screenshot({ path: dest, timeout: 30000 });
        } catch (e) {
          console.error(`Screenshot ${name} failed:`, e.message);
          if (e.name === 'TimeoutError' || !browser.isConnected()) process.exit(75);
          process.exit(1);
        }
        console.log(`Captured ${name}: ${dest} (textLen=${textLen})`);
        await context.close().catch(() => {});
      } catch (e) {
        if (e && (e.code === 75 || process.exitCode === 75)) throw e;
        console.error(`View ${name} failed:`, e && e.message);
        const code = (e && (e.exitCode || e.code)) || 1;
        process.exit(code === 75 ? 75 : 1);
      } finally {
        await context?.close().catch(() => {});
      }
    }
  } catch (e) {
    console.error(e && e.message ? e.message : e);
    process.exit(process.exitCode && process.exitCode !== 0 ? process.exitCode : 1);
  } finally {
    try { await browser?.close(); } catch (e) { console.error('Browser close failed:', e.message); process.exitCode ||= 75; }
  }
  for (const n of ['final-desktop.png', 'final-mobile.png']) {
    const f = join(output, n);
    try {
      const st = statSync(f);
      if (st.size < 5000) { console.error(`${f} too small (${st.size} bytes, defect)`); process.exit(1); }
      console.log(`OK ${f} ${st.size} bytes`);
    } catch (e) { console.error(`Missing ${f} (defect)`); process.exit(1); }
  }
})();
NODEJS
/usr/bin/time -p bash -c 'ls -l "$CAPTURE_DIR/final-desktop.png" "$CAPTURE_DIR/final-mobile.png"'
