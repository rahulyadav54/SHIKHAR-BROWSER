const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

console.log('🚀 Running Shikhar Browser Website build for Vercel...');

// Detect whether we are running from inside website/ or repo root
const cwd = process.cwd();
const isInsideWebsite = fs.existsSync(path.join(cwd, 'src', 'app')) && (fs.existsSync(path.join(cwd, 'next.config.ts')) || fs.existsSync(path.join(cwd, 'next.config.js')));

try {
  if (isInsideWebsite) {
    console.log('⚡ Working directory is website. Running next build directly...');
    execSync('npx next build', { cwd, stdio: 'inherit' });
    console.log('✅ Build completed successfully inside website directory!');
  } else {
    const websiteDir = path.join(cwd, 'website');
    console.log('📦 Installing website dependencies...');
    execSync('npm install --include=dev', { cwd: websiteDir, stdio: 'inherit' });

    console.log('⚡ Building Next.js application in website directory...');
    execSync('npx next build', { cwd: websiteDir, stdio: 'inherit' });

    const srcNext = path.join(websiteDir, '.next');
    const destNext = path.join(cwd, '.next');
    if (fs.existsSync(srcNext)) {
      console.log('📁 Copying .next build artifacts from website/.next to root .next...');
      fs.cpSync(srcNext, destNext, { recursive: true });
    }

    const srcPublic = path.join(websiteDir, 'public');
    const destPublic = path.join(cwd, 'public');
    if (fs.existsSync(srcPublic)) {
      console.log('📁 Copying public static assets from website/public to root public...');
      fs.cpSync(srcPublic, destPublic, { recursive: true });
    }

    console.log('✅ Build completed successfully from root directory!');
  }
} catch (error) {
  console.error('❌ Build failed:', error.message);
  process.exit(1);
}
