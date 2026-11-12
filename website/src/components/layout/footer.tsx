import React from "react";
import Link from "next/link";
import { MountainLogo } from "@/components/ui/mountain-logo";
import { siteConfig } from "@/config/site";
import { Shield, Sparkles, Cpu, Download, Heart } from "lucide-react";

export function Footer() {
  return (
    <footer className="bg-[#040812] border-t border-[#26D9FF]/10 pt-16 pb-12 text-[#A7B5CC]">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-10 pb-12 border-b border-white/5">
          {/* Brand Info */}
          <div className="md:col-span-1 space-y-4">
            <Link href="/" className="flex items-center gap-3">
              <MountainLogo className="w-9 h-9" />
              <div className="flex flex-col">
                <span className="text-lg font-black tracking-wider text-white">SHIKHAR</span>
                <span className="text-[9px] tracking-widest text-[#26D9FF] font-semibold">
                  YOUR WORLD. YOUR WEB.
                </span>
              </div>
            </Link>
            <p className="text-xs text-[#A7B5CC] leading-relaxed">
              Next-generation Chromium browser crafted for Windows and Android. 100% free of SHIKHAR-injected ads, custom intelligent AI assistant, and local-first data protection.
            </p>
            <div className="flex items-center gap-2 pt-2">
              <span className="px-2.5 py-1 text-[11px] font-bold rounded bg-[#101B35] text-[#26D9FF] border border-[#26D9FF]/20">
                DEVELOPED BY {siteConfig.developer}
              </span>
            </div>
          </div>

          {/* Product Links */}
          <div className="space-y-3">
            <h4 className="text-xs font-bold uppercase tracking-widest text-white">Browser Core</h4>
            <ul className="space-y-2 text-xs">
              <li>
                <Link href="/ad-free" className="hover:text-[#26D9FF] transition-colors">
                  100% Ad-Free Experience
                </Link>
              </li>
              <li>
                <Link href="/ai" className="hover:text-[#26D9FF] transition-colors">
                  SHIKHAR AI Assistant
                </Link>
              </li>
              <li>
                <Link href="/features" className="hover:text-[#26D9FF] transition-colors">
                  Tab & Memory Management
                </Link>
              </li>
              <li>
                <Link href="/privacy" className="hover:text-[#26D9FF] transition-colors">
                  Local-First Security
                </Link>
              </li>
              <li>
                <Link href="/downloads" className="hover:text-[#26D9FF] transition-colors">
                  Smart Media Downloader
                </Link>
              </li>
            </ul>
          </div>

          {/* Platforms & Downloads */}
          <div className="space-y-3">
            <h4 className="text-xs font-bold uppercase tracking-widest text-white">Platforms</h4>
            <ul className="space-y-2 text-xs">
              <li>
                <Link href="/downloads" className="hover:text-[#26D9FF] transition-colors">
                  Windows 10 & 11 (64-bit EXE)
                </Link>
              </li>
              <li>
                <Link href="/downloads" className="hover:text-[#26D9FF] transition-colors">
                  Android Smartphones (APK)
                </Link>
              </li>
              <li>
                <Link href="/downloads" className="hover:text-[#26D9FF] transition-colors">
                  Google Play Store
                </Link>
              </li>
              <li>
                <Link href="/faq" className="hover:text-[#26D9FF] transition-colors">
                  System Requirements
                </Link>
              </li>
            </ul>
          </div>

          {/* Legal & Company */}
          <div className="space-y-3">
            <h4 className="text-xs font-bold uppercase tracking-widest text-white">Company & Privacy</h4>
            <ul className="space-y-2 text-xs">
              <li>
                <Link href="/about" className="hover:text-[#26D9FF] transition-colors">
                  About SHIKHAR
                </Link>
              </li>
              <li>
                <Link href="/privacy" className="hover:text-[#26D9FF] transition-colors">
                  Privacy Policy
                </Link>
              </li>
              <li>
                <Link href="/terms" className="hover:text-[#26D9FF] transition-colors">
                  Terms of Service
                </Link>
              </li>
              <li>
                <Link href="/faq" className="hover:text-[#26D9FF] transition-colors">
                  Frequently Asked Questions
                </Link>
              </li>
              <li>
                <Link href="/contact" className="hover:text-[#26D9FF] transition-colors">
                  Contact & Support
                </Link>
              </li>
            </ul>
          </div>
        </div>

        {/* Bottom Banner */}
        <div className="pt-8 flex flex-col sm:flex-row items-center justify-between text-xs text-[#A7B5CC]/70 gap-4">
          <p>© 2026 SHIKHAR Browser. All rights reserved. Crafted by ZAYA CODE HUB.</p>
          <div className="flex items-center gap-6">
            <span className="flex items-center gap-1.5 text-white/80">
              <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
              Chromium Production Engine
            </span>
            <Link href="/privacy" className="hover:text-white transition-colors">
              Zero Telemetry
            </Link>
            <Link href="/terms" className="hover:text-white transition-colors">
              Local Storage
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
}
