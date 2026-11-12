const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

console.log('🚀 Running Shikhar Browser Website build for Vercel...');

const websiteDir = path.join(__dirname, '..', 'website');

console.log('📦 Installing website dependencies...');
execSync('npm install', { cwd: websiteDir, stdio: 'inherit' });

console.log('⚡ Building Next.js application...');
execSync('npm run build', { cwd: websiteDir, stdio: 'inherit' });

const srcNext = path.join(websiteDir, '.next');
const destNext = path.join(__dirname, '..', '.next');

try {
  console.log(`📁 Copying .next build artifacts to root .next...`);
  fs.cpSync(srcNext, destNext, { recursive: true });
} catch (err) {
  console.warn('Artifact copy note:', err.message);
}

console.log('✅ Build completed successfully!');
