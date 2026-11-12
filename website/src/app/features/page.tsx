import React from "react";
import { Navbar } from "@/components/layout/navbar";
import { Footer } from "@/components/layout/footer";
import { ShieldCheck, Sparkles, Zap, Cpu, Layers, Bookmark, DownloadCloud, Lock, RefreshCw, Smartphone, Globe, EyeOff } from "lucide-react";
import Link from "next/link";

export const metadata = {
  title: "Features — SHIKHAR Browser",
  description: "Explore the comprehensive features of SHIKHAR Browser for Windows and Android: Ad-free UI, custom AI, local bookmarks, and Chromium performance.",
};

export default function FeaturesPage() {
  const features = [
    {
      icon: ShieldCheck,
      color: "text-emerald-400",
      title: "100% Ad-Free UI",
      desc: "Zero injected sponsored tiles, affiliate banners, or popups in your browser interface or default homepage.",
      status: "Available",
    },
    {
      icon: Sparkles,
      color: "text-[#26D9FF]",
      title: "Custom SHIKHAR AI",
      desc: "Instant webpage summarization, code explanation, concept breakdowns, and learning support right from the browser sidebar.",
      status: "Available",
    },
    {
      icon: Lock,
      color: "text-[#8B3DFF]",
      title: "Local-First Storage",
      desc: "Browsing history, bookmarks, and downloads are encrypted locally in SQLite databases on your device. Zero remote telemetry.",
      status: "Available",
    },
    {
      icon: Cpu,
      color: "text-[#168BFF]",
      title: "Chromium Engine",
      desc: "Powered by the world's most compatible, battle-tested web rendering engine for lightning-fast speeds and web standards.",
      status: "Available",
    },
    {
      icon: DownloadCloud,
      color: "text-amber-400",
      title: "Intelligent Media Downloader",
      desc: "Direct file and video downloading (.mp4, .webm, .mkv, .pdf, .zip) with multi-threaded downloads manager.",
      status: "Available",
    },
    {
      icon: Layers,
      color: "text-cyan-400",
      title: "Modern Multi-Tab Strips",
      desc: "Fluid desktop tab switcher with duplication, audio indicators, and mobile modal grid management.",
      status: "Available",
    },
    {
      icon: EyeOff,
      color: "text-purple-400",
      title: "Isolated Private Browsing",
      desc: "One-click incognito tabs with instant cache, storage, and cookie purging upon window closure.",
      status: "Available",
    },
    {
      icon: Globe,
      color: "text-blue-400",
      title: "Desktop & Mobile Cross-Platform",
      desc: "Consistent, premium browsing experience custom-engineered for Windows 10/11 and Android smartphones.",
      status: "Available",
    },
    {
      icon: RefreshCw,
      color: "text-emerald-300",
      title: "State-Aware Reload Toolbar",
      desc: "Dedicated stop and refresh buttons with full keyboard shortcut bindings (Ctrl+R, F5, Esc).",
      status: "Available",
    },
  ];

  return (
    <div className="min-h-screen bg-[#070D1D] text-white">
      <Navbar />
      <main className="pt-32 pb-24 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <span className="text-xs font-bold px-3 py-1 rounded-full bg-[#168BFF]/20 text-[#26D9FF] border border-[#26D9FF]/30">
            COMPREHENSIVE CAPABILITIES
          </span>
          <h1 className="text-4xl sm:text-6xl font-black text-white mt-4 mb-4">
            Engineered for Pure Performance.
          </h1>
          <p className="text-base text-[#A7B5CC]">
            Every feature in SHIKHAR Browser has been purposefully crafted to eliminate friction and maximize human productivity.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((feat, idx) => {
            const Icon = feat.icon;
            return (
              <div key={idx} className="glass-panel rounded-2xl p-8 border border-white/5 hover:border-[#26D9FF]/30 transition-all duration-200">
                <div className="flex items-center justify-between mb-5">
                  <div className="p-3 rounded-xl bg-white/5 border border-white/10">
                    <Icon className={`w-6 h-6 ${feat.color}`} />
                  </div>
                  <span className="text-[10px] font-bold px-2 py-0.5 rounded bg-emerald-500/20 text-emerald-400 font-mono">
                    {feat.status}
                  </span>
                </div>
                <h3 className="text-lg font-bold text-white mb-2">{feat.title}</h3>
                <p className="text-sm text-[#A7B5CC] leading-relaxed">{feat.desc}</p>
              </div>
            );
          })}
        </div>

        {/* CTA */}
        <div className="mt-20 text-center glass-panel rounded-3xl p-10 max-w-4xl mx-auto border border-[#26D9FF]/20">
          <h3 className="text-2xl font-bold text-white mb-3">Ready to experience true browsing freedom?</h3>
          <p className="text-sm text-[#A7B5CC] mb-6">Install SHIKHAR Browser today on Windows or your Android phone.</p>
          <Link
            href="/downloads"
            className="inline-flex items-center gap-2 px-8 py-3.5 rounded-full font-bold text-sm text-white bg-gradient-to-r from-[#168BFF] to-[#8B3DFF] shadow-lg shadow-[#168BFF]/30 hover:scale-105 transition-transform"
          >
            <span>Download SHIKHAR</span>
          </Link>
        </div>
      </main>
      <Footer />
    </div>
  );
}

