#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";

const version = process.argv[2];

if (!version) {
  console.error("Usage: node scripts/bump-plugin-version.mjs <version>");
  process.exit(1);
}

if (!/^\d+\.\d+\.\d+$/.test(version)) {
  console.error(`Invalid version "${version}". Expected semver like 4.0.0`);
  process.exit(1);
}

const repoRoot = process.cwd();
const pluginManifestPath = path.join(
  repoRoot,
  "plugins",
  "project-engineer",
  ".claude-plugin",
  "plugin.json",
);
const marketplaceManifestPath = path.join(
  repoRoot,
  ".claude-plugin",
  "marketplace.json",
);

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJson(filePath, value) {
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`, "utf8");
}

const pluginManifest = readJson(pluginManifestPath);
const marketplaceManifest = readJson(marketplaceManifestPath);

pluginManifest.version = version;

if (!Array.isArray(marketplaceManifest.plugins)) {
  console.error("marketplace.json is missing a plugins array");
  process.exit(1);
}

const pluginEntry = marketplaceManifest.plugins.find(
  (plugin) => plugin.name === pluginManifest.name,
);

if (!pluginEntry) {
  console.error(
    `marketplace.json does not contain a plugin entry named "${pluginManifest.name}"`,
  );
  process.exit(1);
}

pluginEntry.version = version;

if (!marketplaceManifest.metadata || typeof marketplaceManifest.metadata !== "object") {
  marketplaceManifest.metadata = {};
}

marketplaceManifest.metadata.version = version;

writeJson(pluginManifestPath, pluginManifest);
writeJson(marketplaceManifestPath, marketplaceManifest);

console.log(`Updated plugin version to ${version}`);
console.log(`- ${path.relative(repoRoot, pluginManifestPath)}`);
console.log(`- ${path.relative(repoRoot, marketplaceManifestPath)}`);
