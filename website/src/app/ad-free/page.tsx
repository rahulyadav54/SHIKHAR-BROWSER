import React from "react";
import { Navbar } from "@/components/layout/navbar";
import { Footer } from "@/components/layout/footer";
import { ShieldCheck, CheckCircle2, Zap, Eye, Sparkles } from "lucide-react";

export const metadata = {
  title: "Ad-Free Commitment — SHIKHAR Browser",
  description: "Learn about SHIKHAR's 100% ad-free browser policy. Zero injected ads, no sponsored homepage tiles, and built-in web ad suppression.",
};

export default function AdFreePage() {
  return (
    <div className="min-h-screen bg-[#070D1D] text-white">
      <Navbar />
      <main className="pt-32 pb-24 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <span className="text-xs font-bold px-3 py-1 rounded-full bg-emerald-500/20 text-emerald-400 border border-emerald-500/40">
            OUR CORE PROMISE
          </span>
          <h1 className="text-4xl sm:text-6xl font-black text-white mt-4 mb-4">
            Zero Injected Ads. Period.
          </h1>
          <p className="text-base text-[#A7B5CC]">
            We believe your web browser is a personal tool for discovery and productivity — not a billboard for commercial sponsors.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-5xl mx-auto mb-16">
          <div className="glass-panel rounded-2xl p-8 border border-emerald-500/30">
            <CheckCircle2 className="w-8 h-8 text-emerald-400 mb-4" />
            <h3 className="text-lg font-bold text-white mb-2">No Sponsored Homepage</h3>
            <p className="text-xs text-[#A7B5CC] leading-relaxed">
              When you open a new tab in SHIKHAR, you see your shortcuts, the current time, and a clean search bar. No sponsored shopping tiles or clickbait news.
            </p>
          </div>

          <div className="glass-panel rounded-2xl p-8 border border-emerald-500/30">
            <ShieldCheck className="w-8 h-8 text-emerald-400 mb-4" />
            <h3 className="text-lg font-bold text-white mb-2">Web Ad Tracker Shield</h3>
            <p className="text-xs text-[#A7B5CC] leading-relaxed">
              Our controller filters intrusive ad network scripts, doubleclick pixels, and high-frequency video interruptions directly in the network pipeline.
            </p>
          </div>

          <div className="glass-panel rounded-2xl p-8 border border-emerald-500/30">
            <Zap className="w-8 h-8 text-emerald-400 mb-4" />
            <h3 className="text-lg font-bold text-white mb-2">Faster Page Renders</h3>
            <p className="text-xs text-[#A7B5CC] leading-relaxed">
              By eliminating third-party tracking scripts and bulky ad wrappers, web pages load up to 2.4x faster while consuming significantly less memory.
            </p>
          </div>
        </div>
      </main>
      <Footer />
    </div>
  );
}

