import React from "react";
import { Navbar } from "@/components/layout/navbar";
import { Footer } from "@/components/layout/footer";
import { Download, Laptop, Smartphone, Check, FileCheck, Shield, ExternalLink, Sparkles } from "lucide-react";
import { siteConfig } from "@/config/site";

export const metadata = {
  title: "Download SHIKHAR Browser — Windows & Android",
  description: "Official download center for SHIKHAR Browser. Direct high-speed download for Windows 10/11 64-bit and Android APK.",
};

export default function DownloadsPage() {
  return (
    <div className="min-h-screen bg-[#070D1D] text-white">
      <Navbar />
      <main className="pt-32 pb-24 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <span className="text-xs font-bold px-3 py-1 rounded-full bg-[#168BFF]/20 text-[#26D9FF] border border-[#26D9FF]/40">
            OFFICIAL DOWNLOAD REPOSITORY
          </span>
          <h1 className="text-4xl sm:text-6xl font-black text-white mt-4 mb-4">
            Download SHIKHAR Browser.
          </h1>
          <p className="text-base text-[#A7B5CC]">
            Direct verified release builds for Windows PC and Android smartphones. Completely free of injected advertisements and bloat.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-5xl mx-auto mb-20">
          {/* Windows Download */}
          <div className="glass-panel rounded-3xl p-8 sm:p-10 border-[#168BFF]/40 bg-gradient-to-b from-[#101B35]/90 to-[#070D1D] shadow-2xl flex flex-col justify-between">
            <div>
              <div className="flex items-center justify-between mb-6">
                <div className="p-3.5 rounded-2xl bg-[#168BFF]/20 text-[#26D9FF] border border-[#168BFF]/30">
                  <Laptop className="w-8 h-8" />
                </div>
                <span className="text-xs px-3 py-1 rounded-full font-bold bg-emerald-500/20 text-emerald-400 font-mono">
                  VERIFIED BUILD
                </span>
              </div>
              <h2 className="text-2xl font-black text-white mb-2">SHIKHAR for Windows</h2>
              <p className="text-xs text-[#A7B5CC] leading-relaxed mb-6">
                Full standalone package for Windows 10 & 11 (includes executable, Chromium WebView2 runtime engine, and offline data assets).
              </p>

              <div className="space-y-2 mb-8 text-xs text-[#A7B5CC]">
                <div className="flex justify-between py-1.5 border-b border-white/5">
                  <span>Version:</span>
                  <strong className="text-white">v{siteConfig.downloads.windows.version} (Release Build)</strong>
                </div>
                <div className="flex justify-between py-1.5 border-b border-white/5">
                  <span>Architecture:</span>
                  <strong className="text-white">{siteConfig.downloads.windows.arch}</strong>
                </div>
                <div className="flex justify-between py-1.5 border-b border-white/5">
                  <span>OS Support:</span>
                  <strong className="text-white">{siteConfig.downloads.windows.os}</strong>
                </div>
                <div className="flex justify-between py-1.5 border-b border-white/5">
                  <span>Format / Size:</span>
                  <strong className="text-white">ZIP Archive (~{siteConfig.downloads.windows.size})</strong>
                </div>
              </div>
            </div>

            <div className="space-y-3">
              <a
                href={siteConfig.downloads.windows.url}
                target="_blank"
                rel="noopener noreferrer"
                className="w-full py-4 rounded-xl font-bold text-sm text-white bg-gradient-to-r from-[#168BFF] to-[#26D9FF] hover:opacity-95 transition-all text-center flex items-center justify-center gap-2 shadow-lg shadow-[#168BFF]/30"
              >
                <Download className="w-4 h-4" />
                <span>Download Windows Package (.zip)</span>
              </a>

              <a
                href={siteConfig.downloads.windows.driveViewUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="w-full py-2.5 rounded-xl font-medium text-xs text-[#A7B5CC] hover:text-white bg-white/5 hover:bg-white/10 transition-all text-center flex items-center justify-center gap-1.5"
              >
                <ExternalLink className="w-3.5 h-3.5" />
                <span>View File on Google Drive</span>
              </a>
            </div>
          </div>

          {/* Android Download */}
          <div className="glass-panel rounded-3xl p-8 sm:p-10 border-[#8B3DFF]/40 bg-gradient-to-b from-[#101B35]/90 to-[#070D1D] shadow-2xl flex flex-col justify-between">
            <div>
              <div className="flex items-center justify-between mb-6">
                <div className="p-3.5 rounded-2xl bg-[#8B3DFF]/20 text-[#A78BFA] border border-[#8B3DFF]/30">
                  <Smartphone className="w-8 h-8" />
                </div>
                <span className="text-xs px-3 py-1 rounded-full font-bold bg-amber-500/20 text-amber-300 border border-amber-500/30">
                  COMING SOON ON PLAY STORE
                </span>
              </div>
              <h2 className="text-2xl font-black text-white mb-2">SHIKHAR for Android</h2>
              <p className="text-xs text-[#A7B5CC] leading-relaxed mb-6">
                Mobile Chromium browser with 9:16 cultural cinematic introduction, bottom navigation bar, YouTube ad skipper, and media downloader.
              </p>

              <div className="space-y-2 mb-8 text-xs text-[#A7B5CC]">
                <div className="flex justify-between py-1.5 border-b border-white/5">
                  <span>Version:</span>
                  <strong className="text-white">v{siteConfig.downloads.android.version} (Verified APK)</strong>
                </div>
                <div className="flex justify-between py-1.5 border-b border-white/5">
                  <span>Architecture:</span>
                  <strong className="text-white">{siteConfig.downloads.android.arch}</strong>
                </div>
                <div className="flex justify-between py-1.5 border-b border-white/5">
                  <span>Android OS:</span>
                  <strong className="text-white">{siteConfig.downloads.android.os}</strong>
                </div>
                <div className="flex justify-between py-1.5 border-b border-white/5">
                  <span>Google Play Store:</span>
                  <strong className="text-amber-300 font-semibold">Listing in review (Coming Soon)</strong>
                </div>
              </div>
            </div>

            <div className="space-y-3">
              <a
                href={siteConfig.downloads.android.url}
                target="_blank"
                rel="noopener noreferrer"
                className="w-full py-4 rounded-xl font-bold text-sm text-white bg-gradient-to-r from-[#8B3DFF] to-[#168BFF] hover:opacity-95 transition-all text-center flex items-center justify-center gap-2 shadow-lg shadow-[#8B3DFF]/30"
              >
                <Download className="w-4 h-4" />
                <span>Download Android APK Package</span>
              </a>

              <div className="w-full py-2.5 rounded-xl text-center text-xs text-[#A7B5CC] bg-white/5 border border-white/5 flex items-center justify-center gap-2">
                <span className="w-2 h-2 rounded-full bg-amber-400 animate-pulse" />
                <span>Google Play Store Edition — Releasing Soon</span>
              </div>
            </div>
          </div>
        </div>

        {/* Installation Instructions */}
        <div className="glass-panel rounded-2xl p-8 max-w-4xl mx-auto border border-white/10">
          <h3 className="text-lg font-bold text-white mb-4 flex items-center gap-2">
            <FileCheck className="w-5 h-5 text-emerald-400" />
            <span>Quick Installation Guide</span>
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 text-xs text-[#A7B5CC] leading-relaxed">
            <div>
              <h4 className="font-bold text-white mb-1.5">Windows PC:</h4>
              <p>1. Download the <code>SHIKHAR-Browser-Windows-x64.zip</code> file.</p>
              <p>2. Right-click and choose <strong>Extract All...</strong></p>
              <p>3. Double-click <code>shikhar_browser.exe</code> to run immediately (no installer required).</p>
            </div>
            <div>
              <h4 className="font-bold text-white mb-1.5">Android Smartphone:</h4>
              <p>1. Tap the download link on your phone.</p>
              <p>2. Open your Notifications or Downloads folder and tap the downloaded APK.</p>
              <p>3. Tap <strong>Install</strong> (enable "Allow unknown sources" if prompted).</p>
            </div>
          </div>
        </div>
      </main>
      <Footer />
    </div>
  );
}
