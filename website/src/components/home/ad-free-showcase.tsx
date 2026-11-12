import React from "react";
import { CheckCircle, XCircle, Shield, Zap, Sparkles } from "lucide-react";
import Link from "next/link";

export function AdFreeShowcase() {
  return (
    <section className="py-24 relative bg-[#070D1D]">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-500/20 border border-emerald-500/40 text-emerald-400 text-xs font-bold mb-4">
            <Shield className="w-3.5 h-3.5" />
            <span>CLEAN BROWSING REVOLUTION</span>
          </div>
          <h2 className="text-3xl sm:text-5xl font-black text-white mb-4">
            YOUR WEB. <br />
            <span className="text-gradient">WITHOUT THE AD NOISE.</span>
          </h2>
          <p className="text-base text-[#A7B5CC]">
            Enjoy an interface 100% free of sponsored recommendations, pop-up banners, and forced partner links. Focus directly on content, without clutter.
          </p>
        </div>

        {/* Side-by-Side Comparison */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 items-stretch">
          {/* Cluttered Ordinary Browser */}
          <div className="glass-panel rounded-2xl p-6 sm:p-8 border-red-500/20 bg-gradient-to-b from-red-950/10 to-[#070D1D] flex flex-col justify-between">
            <div>
              <div className="flex items-center justify-between pb-4 border-b border-white/10 mb-6">
                <span className="text-xs font-bold uppercase tracking-wider text-red-400 flex items-center gap-2">
                  <XCircle className="w-4 h-4 text-red-400" />
                  Ordinary Commercial Browsers
                </span>
                <span className="text-[10px] text-[#A7B5CC]">Standard Bloat</span>
              </div>

              <div className="space-y-4">
                <div className="p-4 rounded-xl bg-red-500/10 border border-red-500/20 text-xs text-red-300">
                  ⚠️ Sponsored search suggestions and affiliate tiles injected into the default homepage.
                </div>
                <div className="p-4 rounded-xl bg-red-500/10 border border-red-500/20 text-xs text-red-300">
                  ⚠️ Annoying newsfeed popups and clickbait articles cluttering your new tab view.
                </div>
                <div className="p-4 rounded-xl bg-red-500/10 border border-red-500/20 text-xs text-red-300">
                  ⚠️ Background tracking scripts reporting browsing telemetry to corporate ad servers.
                </div>
                <div className="p-4 rounded-xl bg-red-500/10 border border-red-500/20 text-xs text-red-300">
                  ⚠️ Heavy page weight causing slow load times and draining laptop battery life.
                </div>
              </div>
            </div>

            <div className="pt-6 mt-6 border-t border-white/5 text-xs text-[#A7B5CC]">
              Result: Distraction, increased memory usage, and constant cognitive overload.
            </div>
          </div>

          {/* Clean SHIKHAR Browser */}
          <div className="glass-panel rounded-2xl p-6 sm:p-8 border-emerald-500/30 bg-gradient-to-b from-emerald-950/20 via-[#101B35] to-[#070D1D] shadow-[0_0_40px_rgba(52,211,153,0.15)] flex flex-col justify-between">
            <div>
              <div className="flex items-center justify-between pb-4 border-b border-white/10 mb-6">
                <span className="text-xs font-bold uppercase tracking-wider text-emerald-400 flex items-center gap-2">
                  <CheckCircle className="w-4 h-4 text-emerald-400" />
                  The SHIKHAR Experience
                </span>
                <span className="text-[10px] px-2 py-0.5 rounded-full bg-emerald-500/20 text-emerald-400 font-bold font-mono">
                  100% CLEAN
                </span>
              </div>

              <div className="space-y-4">
                <div className="p-4 rounded-xl bg-emerald-500/10 border border-emerald-500/25 text-xs text-emerald-200 flex items-center gap-3">
                  <CheckCircle className="w-4 h-4 text-emerald-400 shrink-0" />
                  <span><strong>Zero Injected Ads:</strong> No sponsored tiles, banner popups, or paid partner links anywhere in the browser.</span>
                </div>
                <div className="p-4 rounded-xl bg-emerald-500/10 border border-emerald-500/25 text-xs text-emerald-200 flex items-center gap-3">
                  <CheckCircle className="w-4 h-4 text-emerald-400 shrink-0" />
                  <span><strong>Minimalist Homepage:</strong> Beautiful Himalayan mountain branding, clean search bar, and custom shortcuts only.</span>
                </div>
                <div className="p-4 rounded-xl bg-emerald-500/10 border border-emerald-500/25 text-xs text-emerald-200 flex items-center gap-3">
                  <CheckCircle className="w-4 h-4 text-emerald-400 shrink-0" />
                  <span><strong>Intelligent Media Downloader:</strong> Direct download handling for images, videos, audio, and documents.</span>
                </div>
                <div className="p-4 rounded-xl bg-emerald-500/10 border border-emerald-500/25 text-xs text-emerald-200 flex items-center gap-3">
                  <CheckCircle className="w-4 h-4 text-emerald-400 shrink-0" />
                  <span><strong>Blazing Speed:</strong> Less background bloat means faster rendering and reduced CPU/RAM footprint.</span>
                </div>
              </div>
            </div>

            <div className="pt-6 mt-6 border-t border-white/5 flex items-center justify-between">
              <span className="text-xs font-semibold text-white">Your Web. Your Rules.</span>
              <Link href="/ad-free" className="text-xs font-bold text-[#26D9FF] hover:underline">
                Read our Ad-Free commitment →
              </Link>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

