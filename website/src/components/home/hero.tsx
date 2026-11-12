"use client";

import React, { useState } from "react";
import Link from "next/link";
import { Download, Sparkles, Shield, Zap, Laptop, Smartphone, Volume2, VolumeX, ArrowRight } from "lucide-react";

export function Hero() {
  const [activePlatform, setActivePlatform] = useState<"windows" | "android">("windows");
  const [isMuted, setIsMuted] = useState(true);

  return (
    <section className="relative min-h-[90vh] pt-28 sm:pt-36 pb-16 sm:pb-24 flex flex-col justify-center items-center overflow-hidden">
      {/* Background Decorative Gradients & Mountain glow */}
      <div className="absolute inset-0 pointer-events-none">
        <div className="absolute -top-40 left-1/2 -translate-x-1/2 w-[900px] max-w-full h-[550px] bg-gradient-to-b from-[#168BFF]/25 via-[#8B3DFF]/15 to-transparent blur-[120px] rounded-full" />
        <div className="absolute top-1/2 -left-40 w-96 h-96 bg-[#26D9FF]/10 blur-[100px] rounded-full" />
        <div className="absolute bottom-10 -right-40 w-96 h-96 bg-[#8B3DFF]/15 blur-[100px] rounded-full" />
      </div>

      <div className="relative z-10 max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        {/* Brand Badge */}
        <div className="inline-flex items-center gap-2 px-3.5 sm:px-4 py-1.5 rounded-full bg-[#101B35]/80 border border-[#26D9FF]/30 backdrop-blur-md mb-6 sm:mb-8 shadow-[0_0_20px_rgba(38,217,255,0.2)]">
          <span className="flex h-2 w-2 rounded-full bg-[#26D9FF] animate-ping" />
          <span className="text-[10px] sm:text-xs font-extrabold tracking-wide text-white">
            OFFICIAL RELEASE • DEVELOPED BY ZAYA CODE HUB
          </span>
        </div>

        {/* Headlines */}
        <h1 className="text-3xl sm:text-5xl md:text-6xl lg:text-7xl font-black tracking-tight text-white leading-[1.12] sm:leading-[1.08] mb-4">
          REACH NEW HEIGHTS. <br className="hidden sm:inline" />
          <span className="text-gradient">BROWSE BEYOND LIMITS.</span>
        </h1>

        <p className="max-w-2xl mx-auto text-sm sm:text-base md:text-lg text-[#A7B5CC] leading-relaxed mb-6 sm:mb-8 px-2 font-medium">
          Discover <strong className="text-white font-bold">SHIKHAR Browser</strong> — an ad-free, AI-powered browsing experience crafted for Windows and Android. Built for maximum speed, local-first privacy, and high-productivity workflows.
        </p>

        {/* Three Core Feature Indicators */}
        <div className="flex flex-wrap items-center justify-center gap-2.5 sm:gap-4 mb-8 sm:mb-10 text-xs font-bold px-2">
          <div className="flex items-center gap-2 px-4 py-2 rounded-full bg-[#101B35]/90 border border-white/10 shadow-sm text-white">
            <Shield className="w-4 h-4 text-emerald-400 shrink-0" />
            <span className="tracking-wide">100% Ad-Free</span>
          </div>
          <div className="flex items-center gap-2 px-4 py-2 rounded-full bg-[#101B35]/90 border border-white/10 shadow-sm text-white">
            <Sparkles className="w-4 h-4 text-[#26D9FF] shrink-0" />
            <span className="tracking-wide">Custom SHIKHAR AI</span>
          </div>
          <div className="flex items-center gap-2 px-4 py-2 rounded-full bg-[#101B35]/90 border border-white/10 shadow-sm text-white">
            <Zap className="w-4 h-4 text-[#8B3DFF] shrink-0" />
            <span className="tracking-wide">Privacy-First</span>
          </div>
        </div>

        {/* CTA Buttons */}
        <div className="flex flex-col sm:flex-row items-center justify-center gap-3.5 sm:gap-4 mb-10 sm:mb-14 w-full max-w-md mx-auto sm:max-w-none">
          <Link
            href="/downloads"
            className="w-full sm:w-auto px-7 sm:px-9 py-3.5 sm:py-4 rounded-full font-extrabold text-xs sm:text-sm text-white bg-gradient-to-r from-[#168BFF] via-[#26D9FF] to-[#8B3DFF] shadow-[0_0_30px_rgba(22,139,255,0.4)] hover:shadow-[0_0_45px_rgba(38,217,255,0.6)] transition-all duration-300 hover:scale-[1.03] flex items-center justify-center gap-2.5"
          >
            <Download className="w-4 h-4 sm:w-5 sm:h-5 text-white" />
            <span className="text-white font-extrabold">DOWNLOAD FOR WINDOWS</span>
          </Link>
          <Link
            href="/features"
            className="w-full sm:w-auto px-7 sm:px-9 py-3.5 sm:py-4 rounded-full font-bold text-xs sm:text-sm text-white bg-[#101B35]/80 hover:bg-[#101B35] border border-white/15 hover:border-[#26D9FF]/40 transition-all duration-200 flex items-center justify-center gap-2 shadow-sm"
          >
            <span>EXPLORE SHIKHAR</span>
            <ArrowRight className="w-4 h-4 text-[#26D9FF]" />
          </Link>
        </div>

        {/* Video Mode Switcher (Desktop vs Mobile Intro) */}
        <div className="flex flex-wrap items-center justify-center gap-2.5 mb-5">
          <button
            onClick={() => setActivePlatform("windows")}
            className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold transition-all ${
              activePlatform === "windows"
                ? "bg-[#168BFF] text-white shadow-lg shadow-[#168BFF]/30"
                : "bg-[#101B35]/70 text-[#A7B5CC] hover:text-white border border-white/5"
            }`}
          >
            <Laptop className="w-4 h-4" />
            <span>Windows Desktop (16:9)</span>
          </button>
          <button
            onClick={() => setActivePlatform("android")}
            className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold transition-all ${
              activePlatform === "android"
                ? "bg-[#8B3DFF] text-white shadow-lg shadow-[#8B3DFF]/30"
                : "bg-[#101B35]/70 text-[#A7B5CC] hover:text-white border border-white/5"
            }`}
          >
            <Smartphone className="w-4 h-4" />
            <span>Mobile Cinematic (9:16)</span>
          </button>
        </div>

        {/* Live Cinematic Video Player with Authentic Nepali Music */}
        <div className="relative mx-auto max-w-4xl rounded-2xl sm:rounded-3xl p-1.5 sm:p-3 bg-gradient-to-b from-[#26D9FF]/30 via-[#101B35] to-[#070D1D] shadow-[0_25px_70px_-15px_rgba(0,0,0,0.9)] border border-[#26D9FF]/20 overflow-hidden">
          <div className="relative bg-[#070D1D] rounded-xl sm:rounded-2xl overflow-hidden flex items-center justify-center">
            {activePlatform === "windows" ? (
              <video
                key="desktop-video"
                src="/videos/shikhar_desktop_intro.mp4"
                autoPlay
                loop
                muted={isMuted}
                playsInline
                className="w-full h-auto aspect-video object-cover rounded-lg sm:rounded-xl"
              />
            ) : (
              <div className="py-4 sm:py-6 flex justify-center w-full bg-[#050914]">
                <div className="w-[260px] sm:w-[300px] aspect-[9/16] rounded-xl sm:rounded-2xl overflow-hidden border-2 border-[#8B3DFF]/40 shadow-2xl">
                  <video
                    key="mobile-video"
                    src="/videos/shikhar_mobile_intro.mp4"
                    autoPlay
                    loop
                    muted={isMuted}
                    playsInline
                    className="w-full h-full object-cover"
                  />
                </div>
              </div>
            )}

            {/* Audio Toggle Floating Pill */}
            <div className="absolute bottom-2 right-2 sm:bottom-4 sm:right-4 z-20 flex items-center gap-2">
              <button
                onClick={() => setIsMuted(!isMuted)}
                className="px-3 sm:px-4 py-1.5 sm:py-2 rounded-full bg-[#070D1D]/85 backdrop-blur-md border border-white/20 text-white text-[11px] sm:text-xs font-bold flex items-center gap-1.5 sm:gap-2 shadow-xl hover:bg-[#168BFF] transition-all"
              >
                {isMuted ? (
                  <>
                    <VolumeX className="w-3.5 h-3.5 text-rose-400 shrink-0" />
                    <span>Unmute Music</span>
                  </>
                ) : (
                  <>
                    <Volume2 className="w-3.5 h-3.5 text-[#26D9FF] animate-pulse shrink-0" />
                    <span>Mute Music</span>
                  </>
                )}
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
