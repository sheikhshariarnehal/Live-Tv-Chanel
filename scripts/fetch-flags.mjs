// One-off script: download SVG flags for all World Cup 2026 teams.
// Run with: node scripts/fetch-flags.mjs
import { writeFile, mkdir } from 'node:fs/promises';
import { existsSync } from 'node:fs';

const OUT = 'public/assets/flags';
if (!existsSync(OUT)) await mkdir(OUT, { recursive: true });

// flag-icons CDN (Wikimedia-sourced). We use the 4x3 aspect ratio SVGs.
const BASE = 'https://cdn.jsdelivr.net/npm/flag-icons@7.2.3/flags/4x3';

// Map of ISO code -> output filename. All .svg.
const codes = [
  // Group A
  'mx','za','kr','cz',
  // Group B
  'ca','ba','qa','ch',
  // Group C
  'br','ma','ht','gb-sct',
  // Group D
  'us','py','au','tr',
  // Group E
  'de','cw','ci','ec',
  // Group F
  'nl','jp','se','tn',
  // Group G
  'be','eg','ir','nz',
  // Group H
  'es','cv','sa','uy',
  // Group I
  'fr','sn','iq','no',
  // Group J
  'ar','dz','at','jo',
  // Group K
  'pt','cd','uz','co',
  // Group L
  'gb-eng','gh','pa','hr',
];

const unique = [...new Set(codes)];
let ok = 0, fail = 0;

for (const code of unique) {
  const url = `${BASE}/${code}.svg`;
  const safeName = code.replace('-', '_') + '.svg'; // gb-eng -> gb_eng.svg
  try {
    const res = await fetch(url);
    if (!res.ok) { console.log('FAIL', code, res.status); fail++; continue; }
    const svg = await res.text();
    if (!svg.includes('<svg')) { console.log('FAIL(bad)', code); fail++; continue; }
    await writeFile(`${OUT}/${safeName}`, svg, 'utf8');
    console.log('OK', code, '->', safeName, `(${svg.length} bytes)`);
    ok++;
  } catch (e) {
    console.log('ERR', code, e.message);
    fail++;
  }
}

console.log(`\nDone: ${ok} downloaded, ${fail} failed.`);
