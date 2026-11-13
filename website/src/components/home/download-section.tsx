import React from "react";
import { Download, Laptop, Smartphone, Check, ArrowRight, ShieldCheck, Cpu, ExternalLink } from "lucide-react";
import Link from "next/link";
import { siteConfig } from "@/config/site";

export function DownloadSection() {
  return (
    <section id="downloads" className="py-24 relative bg-[#040812]">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#168BFF]/20 border border-[#168BFF]/40 text-[#26D9FF] text-xs font-bold mb-4">
            <Download className="w-3.5 h-3.5" />
            <span>CROSS-PLATFORM INSTALLERS</span>
          </div>
          <h2 className="text-3xl sm:text-5xl font-black text-white mb-4">
            GET SHIKHAR FOR YOUR DEVICES.
          </h2>
          <p className="text-base text-[#A7B5CC]">
            Experience ad-free browsing and intelligent AI assistance across Windows desktop and Android mobile smartphones.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-5xl mx-auto">
          {/* Windows Download Card */}
          <div className="glass-panel rounded-3xl p-8 sm:p-10 border-[#168BFF]/30 bg-gradient-to-b from-[#101B35]/80 via-[#070D1D] to-[#070D1D] shadow-[0_0_40px_rgba(22,139,255,0.15)] flex flex-col justify-between relative overflow-hidden group">
            <div className="absolute top-0 right-0 w-40 h-40 bg-[#168BFF]/10 rounded-full blur-3xl pointer-events-none" />

            <div>
              <div className="flex items-center justify-between mb-8">
                <div className="p-4 rounded-2xl bg-[#168BFF]/15 border border-[#168BFF]/30 text-[#26D9FF]">
                  <Laptop className="w-8 h-8" />
                </div>
                <span className="px-3 py-1 rounded-full text-xs font-bold bg-emerald-500/20 text-emerald-400 border border-emerald-500/30">
                  {siteConfig.downloads.windows.status}
                </span>
              </div>

              <h3 className="text-2xl font-black text-white mb-2">
                {siteConfig.downloads.windows.title}
              </h3>
              <p className="text-sm text-[#A7B5CC] mb-6">
                Optimized for high-performance desktop multi-tasking with native Chromium engine, custom tab strip, and AI sidebar.
              </p>

              <div className="space-y-2.5 mb-8 text-xs text-[#A7B5CC]">
                <div className="flex items-center gap-2">
                  <Check className="w-4 h-4 text-[#26D9FF]" />
                  <span>Compatible with <strong>{siteConfig.downloads.windows.os}</strong></span>
                </div>
                <div className="flex items-center gap-2">
                  <Check className="w-4 h-4 text-[#26D9FF]" />
                  <span>Architecture: <strong>{siteConfig.downloads.windows.arch}</strong></span>
                </div>
                <div className="flex items-center gap-2">
                  <Check className="w-4 h-4 text-[#26D9FF]" />
                  <span>Version: <strong>v{siteConfig.downloads.windows.version} (Release Build)</strong></span>
                </div>
                <div className="flex items-center gap-2">
                  <Check className="w-4 h-4 text-[#26D9FF]" />
                  <span>Full Package: <strong>{siteConfig.downloads.windows.fileName}</strong></span>
                </div>
              </div>
            </div>

            <div className="space-y-3">
              <a
                href={siteConfig.downloads.windows.url}
                download="SHIKHAR-Browser-Windows-Setup.exe"
                className="w-full py-4 rounded-2xl font-bold text-sm text-white bg-gradient-to-r from-[#168BFF] to-[#26D9FF] shadow-lg shadow-[#168BFF]/30 hover:shadow-[#26D9FF]/40 transition-all duration-300 flex items-center justify-center gap-2 group-hover:scale-[1.02]"
              >
                <Download className="w-4 h-4" />
                <span>Download Windows Installer (.exe)</span>
              </a>

              <Link
                href="/downloads"
                className="block text-center text-xs text-[#A7B5CC] hover:text-[#26D9FF] transition-colors py-1"
              >
                View installation instructions →
              </Link>
            </div>
          </div>

          {/* Android Download Card */}
          <div className="glass-panel rounded-3xl p-8 sm:p-10 border-[#8B3DFF]/30 bg-gradient-to-b from-[#101B35]/80 via-[#070D1D] to-[#070D1D] shadow-[0_0_40px_rgba(139,61,255,0.15)] flex flex-col justify-between relative overflow-hidden group">
            <div className="absolute top-0 right-0 w-40 h-40 bg-[#8B3DFF]/10 rounded-full blur-3xl pointer-events-none" />

            <div>
              <div className="flex items-center justify-between mb-8">
                <div className="p-4 rounded-2xl bg-[#8B3DFF]/15 border border-[#8B3DFF]/30 text-[#A78BFA]">
                  <Smartphone className="w-8 h-8" />
                </div>
                <span className="px-3 py-1 rounded-full text-xs font-bold bg-amber-500/20 text-amber-300 border border-amber-500/30">
                  PLAY STORE COMING SOON
                </span>
              </div>

              <h3 className="text-2xl font-black text-white mb-2">
                {siteConfig.downloads.android.title}
              </h3>
              <p className="text-sm text-[#A7B5CC] mb-6">
                Mobile-first Chromium browsing with 9:16 cultural cinematic introduction, bottom navigation bar, and one-tap AI modal.
              </p>

              <div className="space-y-2.5 mb-8 text-xs text-[#A7B5CC]">
                <div className="flex items-center gap-2">
                  <Check className="w-4 h-4 text-[#A78BFA]" />
                  <span>Compatible with <strong>{siteConfig.downloads.android.os}</strong></span>
                </div>
                <div className="flex items-center gap-2">
                  <Check className="w-4 h-4 text-[#A78BFA]" />
                  <span>Architecture: <strong>{siteConfig.downloads.android.arch}</strong></span>
                </div>
                <div className="flex items-center gap-2">
                  <Check className="w-4 h-4 text-[#A78BFA]" />
                  <span>Direct APK: <strong>Available Now (v{siteConfig.downloads.android.version})</strong></span>
                </div>
                <div className="flex items-center gap-2">
                  <Check className="w-4 h-4 text-[#A78BFA]" />
                  <span>Google Play Store: <strong>Listing In Review (Coming Soon)</strong></span>
                </div>
              </div>
            </div>

            <div className="space-y-3">
              <a
                href={siteConfig.downloads.android.url}
                target="_blank"
                rel="noopener noreferrer"
                className="w-full py-4 rounded-2xl font-bold text-sm text-white bg-gradient-to-r from-[#8B3DFF] to-[#168BFF] shadow-lg shadow-[#8B3DFF]/30 hover:shadow-[#168BFF]/40 transition-all duration-300 flex items-center justify-center gap-2 group-hover:scale-[1.02]"
              >
                <Download className="w-4 h-4" />
                <span>Download Android Package (.apk)</span>
              </a>

              <Link
                href="/downloads"
                className="block text-center text-xs text-[#A7B5CC] hover:text-[#A78BFA] transition-colors py-1"
              >
                View installation instructions →
              </Link>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
