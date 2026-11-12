import React from "react";
import Link from "next/link";
import { Download, Sparkles, Mountain, ArrowRight } from "lucide-react";

export function FinalCta() {
  return (
    <section className="relative py-28 overflow-hidden bg-gradient-to-b from-[#070D1D] via-[#101B35] to-[#040812]">
      {/* Background glow and mountain backdrop simulation */}
      <div className="absolute inset-0 pointer-events-none">
        <div className="absolute bottom-0 left-1/2 -translate-x-1/2 w-[1100px] h-[400px] bg-gradient-to-t from-[#168BFF]/20 via-[#8B3DFF]/15 to-transparent blur-[140px] rounded-full" />
      </div>

      <div className="relative z-10 max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <div className="w-16 h-16 mx-auto mb-6 rounded-3xl bg-gradient-to-br from-[#26D9FF] to-[#8B3DFF] p-0.5 shadow-[0_0_40px_rgba(38,217,255,0.4)]">
          <div className="w-full h-full bg-[#070D1D] rounded-[22px] flex items-center justify-center font-black text-2xl text-white">
            <Sparkles className="w-7 h-7 text-[#26D9FF]" />
          </div>
        </div>

        <h2 className="text-3xl sm:text-6xl font-black text-white tracking-tight mb-4">
          BETTER BROWSING. <br />
          <span className="text-gradient">BRIGHTER FUTURE.</span>
        </h2>

        <p className="max-w-2xl mx-auto text-base sm:text-lg text-[#A7B5CC] leading-relaxed mb-10">
          Experience a cleaner, smarter, and more intelligent way to explore the internet. Download SHIKHAR Browser today for Windows and Android.
        </p>

        <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
          <Link
            href="/downloads"
            className="w-full sm:w-auto px-9 py-4 rounded-full font-bold text-sm text-white bg-gradient-to-r from-[#26D9FF] via-[#168BFF] to-[#8B3DFF] shadow-[0_0_35px_rgba(38,217,255,0.5)] hover:scale-105 transition-all duration-300 flex items-center justify-center gap-2"
          >
            <Download className="w-4 h-4" />
            <span>GET SHIKHAR FOR FREE</span>
          </Link>

          <Link
            href="/about"
            className="w-full sm:w-auto px-8 py-4 rounded-full font-semibold text-sm text-white bg-white/5 hover:bg-white/10 border border-white/15 transition-all duration-200 flex items-center justify-center gap-2"
          >
            <span>Learn About The Vision</span>
            <ArrowRight className="w-4 h-4 text-[#26D9FF]" />
          </Link>
        </div>
      </div>
    </section>
  );
}

