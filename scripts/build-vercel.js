const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

console.log('🚀 Running Shikhar Browser Website build for Vercel...');

const websiteDir = path.join(__dirname, '..', 'website');

try {
  console.log('📦 Installing website dependencies...');
  execSync('npm install --include=dev', { cwd: websiteDir, stdio: 'inherit' });

  console.log('⚡ Building Next.js application...');
  execSync('npm run build', { cwd: websiteDir, stdio: 'inherit' });

  const srcNext = path.join(websiteDir, '.next');
  const destNext = path.join(__dirname, '..', '.next');

  if (fs.existsSync(srcNext)) {
    console.log(`📁 Copying .next build artifacts from website/.next to root .next...`);
    fs.cpSync(srcNext, destNext, { recursive: true });
  }

  console.log('✅ Build completed successfully for Vercel!');
} catch (error) {
  console.error('❌ Build failed:', error.message);
  process.exit(1);
}
