import React from "react";
import { Navbar } from "@/components/layout/navbar";
import { Footer } from "@/components/layout/footer";
import { Download, Laptop, Smartphone, Check, FileCheck, Shield } from "lucide-react";
import { siteConfig } from "@/config/site";

export const metadata = {
  title: "Download SHIKHAR Browser — Windows & Android",
  description: "Official download center for SHIKHAR Browser. Download verified Windows 10/11 64-bit installer and Android ARM64 APK.",
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
                Standalone 64-bit executable for Windows 10 & 11 with hardware acceleration, desktop tab management, and AI sidebar.
              </p>

              <div className="space-y-2 mb-8 text-xs text-[#A7B5CC]">
                <div className="flex justify-between py-1.5 border-b border-white/5">
                  <span>Version:</span>
                  <strong className="text-white">v{siteConfig.downloads.windows.version} (Release)</strong>
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
                  <span>Executable Name:</span>
                  <strong className="text-white">{siteConfig.downloads.windows.fileName}</strong>
                </div>
              </div>
            </div>

            <a
              href={`/${siteConfig.downloads.windows.fileName}`}
              download
              className="w-full py-4 rounded-xl font-bold text-sm text-white bg-gradient-to-r from-[#168BFF] to-[#26D9FF] hover:opacity-95 transition-all text-center flex items-center justify-center gap-2 shadow-lg shadow-[#168BFF]/30"
            >
              <Download className="w-4 h-4" />
              <span>Download Windows Executable</span>
            </a>
          </div>

          {/* Android Download */}
          <div className="glass-panel rounded-3xl p-8 sm:p-10 border-[#8B3DFF]/40 bg-gradient-to-b from-[#101B35]/90 to-[#070D1D] shadow-2xl flex flex-col justify-between">
            <div>
              <div className="flex items-center justify-between mb-6">
                <div className="p-3.5 rounded-2xl bg-[#8B3DFF]/20 text-[#A78BFA] border border-[#8B3DFF]/30">
                  <Smartphone className="w-8 h-8" />
                </div>
                <span className="text-xs px-3 py-1 rounded-full font-bold bg-emerald-500/20 text-emerald-400 font-mono">
                  VERIFIED BUILD
                </span>
              </div>
              <h2 className="text-2xl font-black text-white mb-2">SHIKHAR for Android</h2>
              <p className="text-xs text-[#A7B5CC] leading-relaxed mb-6">
                Full-featured mobile Chromium browser with 9:16 cultural cinematic introduction, bottom navigation bar, and YouTube ad skipper.
              </p>

              <div className="space-y-2 mb-8 text-xs text-[#A7B5CC]">
                <div className="flex justify-between py-1.5 border-b border-white/5">
                  <span>Version:</span>
                  <strong className="text-white">v{siteConfig.downloads.android.version} (APK)</strong>
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
                  <span>Package:</span>
                  <strong className="text-white">com.shikhar.browser</strong>
                </div>
              </div>
            </div>

            <a
              href={`/${siteConfig.downloads.android.fileName}`}
              download
              className="w-full py-4 rounded-xl font-bold text-sm text-white bg-gradient-to-r from-[#8B3DFF] to-[#168BFF] hover:opacity-95 transition-all text-center flex items-center justify-center gap-2 shadow-lg shadow-[#8B3DFF]/30"
            >
              <Download className="w-4 h-4" />
              <span>Download Android APK Package</span>
            </a>
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
              <p>1. Download <code>shikhar_browser.exe</code>.</p>
              <p>2. Double-click the file to launch directly or move to your Program Files folder.</p>
              <p>3. Right-click to Pin to Taskbar for convenient 1-click access.</p>
            </div>
            <div>
              <h4 className="font-bold text-white mb-1.5">Android Device:</h4>
              <p>1. Download the <code>.apk</code> on your mobile device.</p>
              <p>2. Open your Downloads folder and tap the APK.</p>
              <p>3. If prompted, allow "Install Unknown Apps" in Android security settings.</p>
            </div>
          </div>
        </div>
      </main>
      <Footer />
    </div>
  );
}

