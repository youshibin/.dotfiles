// @ts-check
const { test, expect } = require('@playwright/test');
const path = require('path');

// Set BASE_URL env var to target your local app, e.g.:
//   BASE_URL=http://localhost:3000 npx playwright test --config ~/.config/playwright/playwright.config.js
const BASE_URL = process.env.BASE_URL || 'http://localhost:3000';

test.describe('QA smoke test', () => {
  /** @type {string[]} */
  const consoleErrors = [];
  /** @type {string[]} */
  const networkFailures = [];

  test.beforeEach(async ({ page }) => {
    consoleErrors.length = 0;
    networkFailures.length = 0;

    page.on('console', (msg) => {
      if (msg.type() === 'error') consoleErrors.push(msg.text());
      if (msg.type() === 'warning') console.warn('[BROWSER WARN]', msg.text());
    });

    page.on('requestfailed', (req) => {
      networkFailures.push(`${req.failure()?.errorText} — ${req.url()}`);
    });

    page.on('pageerror', (err) => {
      consoleErrors.push(`Uncaught exception: ${err.message}`);
    });
  });

  test('homepage loads without errors', async ({ page }) => {
    const response = await page.goto(BASE_URL, { waitUntil: 'networkidle' });

    // Capture screenshot as evidence
    const ts = Date.now();
    await page.screenshot({
      path: path.join('bugs', `${ts}-homepage.png`),
      fullPage: true,
    });

    // FAIL conditions per PLAYWRIGHT_GUIDELINES.md
    expect(response?.status(), 'Homepage returned non-2xx').toBeLessThan(400);
    expect(consoleErrors, `Console errors: ${consoleErrors.join('; ')}`).toHaveLength(0);
    expect(networkFailures, `Network failures: ${networkFailures.join('; ')}`).toHaveLength(0);
  });

  // ---------------------------------------------------------------------------
  // Add scenario-specific tests below. Copy the pattern above:
  //   1. navigate / interact
  //   2. screenshot with descriptive name
  //   3. assert no console errors / network failures
  //   4. assert expected UI state
  // ---------------------------------------------------------------------------
});
