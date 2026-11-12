"use client";

import React, { useState, useEffect } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { siteConfig } from "@/config/site";
import { MountainLogo } from "@/components/ui/mountain-logo";
import { Download, Menu, X, Shield, Sparkles, Layers, ShieldCheck } from "lucide-react";

export function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  const pathname = usePathname();

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 20);
    };
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <nav
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        scrolled
          ? "bg-[#070D1D]/85 backdrop-blur-md border-b border-[#26D9FF]/15 py-3 shadow-2xl"
          : "bg-transparent py-5"
      }`}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between">
          {/* Logo & Brand */}
          <Link href="/" className="flex items-center gap-3 group">
            <MountainLogo className="w-10 h-10 transition-transform duration-300 group-hover:scale-105" />
            <div className="flex flex-col">
              <span className="text-xl font-black tracking-wider text-white flex items-center gap-1.5">
                SHIKHAR
                <span className="text-xs px-2 py-0.5 rounded-full font-bold bg-[#168BFF]/20 text-[#26D9FF] border border-[#26D9FF]/30">
                  BROWSER
                </span>
              </span>
              <span className="text-[10px] tracking-widest text-[#A7B5CC] font-semibold">
                YOUR WORLD. YOUR WEB.
              </span>
            </div>
          </Link>

          {/* Desktop Navigation */}
          <div className="hidden md:flex items-center gap-1 bg-[#101B35]/50 border border-[#26D9FF]/10 rounded-full px-4 py-1.5 backdrop-blur-md">
            {siteConfig.navItems.map((item) => {
              const isActive = pathname === item.href;
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`px-3.5 py-1.5 rounded-full text-xs font-medium transition-all duration-200 ${
                    isActive
                      ? "text-white bg-[#168BFF]/30 shadow-[0_0_12px_rgba(38,217,255,0.3)] font-semibold border border-[#26D9FF]/30"
                      : "text-[#A7B5CC] hover:text-white hover:bg-white/5"
                  }`}
                >
                  {item.label}
                </Link>
              );
            })}
          </div>

          {/* Action Button */}
          <div className="hidden sm:flex items-center gap-3">
            <Link
              href="/downloads"
              className="relative inline-flex items-center justify-center p-0.5 overflow-hidden text-xs font-bold rounded-full group bg-gradient-to-br from-[#26D9FF] via-[#168BFF] to-[#8B3DFF] group-hover:from-[#26D9FF] group-hover:to-[#8B3DFF] hover:text-white shadow-[0_0_20px_rgba(38,217,255,0.35)] transition-all duration-300 hover:scale-[1.02]"
            >
              <span className="relative px-5 py-2 transition-all ease-in duration-75 bg-[#070D1D] rounded-full group-hover:bg-opacity-0 flex items-center gap-2">
                <Download className="w-4 h-4 text-[#26D9FF] group-hover:text-white" />
                <span>Download SHIKHAR</span>
              </span>
            </Link>
          </div>

          {/* Mobile Menu Trigger */}
          <div className="md:hidden flex items-center">
            <button
              onClick={() => setIsOpen(!isOpen)}
              className="p-2 rounded-xl text-[#A7B5CC] hover:text-white hover:bg-[#101B35] focus:outline-none"
              aria-label="Toggle menu"
            >
              {isOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Drawer */}
      {isOpen && (
        <div className="md:hidden bg-[#070D1D]/95 backdrop-blur-xl border-b border-[#26D9FF]/20 px-4 pt-3 pb-6 mt-3 space-y-2 animate-in slide-in-from-top duration-200">
          {siteConfig.navItems.map((item) => {
            const isActive = pathname === item.href;
            return (
              <Link
                key={item.href}
                href={item.href}
                onClick={() => setIsOpen(false)}
                className={`block px-4 py-2.5 rounded-lg text-sm font-medium ${
                  isActive
                    ? "bg-[#168BFF]/20 text-[#26D9FF] border border-[#26D9FF]/30"
                    : "text-[#A7B5CC] hover:text-white hover:bg-white/5"
                }`}
              >
                {item.label}
              </Link>
            );
          })}
          <div className="pt-3">
            <Link
              href="/downloads"
              onClick={() => setIsOpen(false)}
              className="w-full flex items-center justify-center gap-2 py-3 px-4 rounded-xl font-bold text-sm text-white bg-gradient-to-r from-[#168BFF] to-[#8B3DFF] shadow-lg shadow-[#168BFF]/20"
            >
              <Download className="w-4 h-4" />
              Download for Windows & Android
            </Link>
          </div>
        </div>
      )}
    </nav>
  );
}

