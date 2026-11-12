"use client";

import React, { useState, useEffect } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { siteConfig } from "@/config/site";
import { MountainLogo } from "@/components/ui/mountain-logo";
import { ThemeToggle } from "@/components/theme/theme-toggle";
import { Download, Menu, X } from "lucide-react";

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
          ? "bg-[#070D1D]/90 backdrop-blur-md border-b border-[#26D9FF]/15 py-3 shadow-2xl"
          : "bg-transparent py-4 sm:py-5"
      }`}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between">
          {/* Logo & Brand */}
          <Link href="/" className="flex items-center gap-2.5 sm:gap-3 group shrink-0">
            <MountainLogo className="w-9 h-9 sm:w-10 sm:h-10 transition-transform duration-300 group-hover:scale-105" />
            <div className="flex flex-col">
              <span className="text-lg sm:text-xl font-black tracking-wider text-white flex items-center gap-1.5">
                SHIKHAR
                <span className="text-[10px] sm:text-xs px-2 py-0.5 rounded-full font-extrabold bg-[#168BFF]/20 text-[#26D9FF] border border-[#26D9FF]/30">
                  BROWSER
                </span>
              </span>
              <span className="text-[9px] sm:text-[10px] tracking-widest text-[#A7B5CC] font-bold truncate">
                YOUR WORLD. YOUR WEB.
              </span>
            </div>
          </Link>

          {/* Desktop Navigation */}
          <div className="hidden lg:flex items-center gap-1 bg-[#101B35]/60 border border-[#26D9FF]/15 rounded-full px-4 py-1.5 backdrop-blur-md">
            {siteConfig.navItems.map((item) => {
              const isActive = pathname === item.href;
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`px-3.5 py-1.5 rounded-full text-xs font-semibold transition-all duration-200 ${
                    isActive
                      ? "text-white bg-[#168BFF]/35 shadow-[0_0_12px_rgba(38,217,255,0.3)] font-bold border border-[#26D9FF]/40"
                      : "text-[#A7B5CC] hover:text-white hover:bg-white/5 font-semibold"
                  }`}
                >
                  {item.label}
                </Link>
              );
            })}
          </div>

          {/* Desktop Actions: Theme Toggle + Solid Gradient Download Button */}
          <div className="hidden md:flex items-center gap-2.5">
            <ThemeToggle />

            <Link
              href="/downloads"
              className="inline-flex items-center justify-center px-5 py-2.5 rounded-full text-xs font-extrabold text-white bg-gradient-to-r from-[#168BFF] via-[#26D9FF] to-[#8B3DFF] shadow-[0_0_20px_rgba(38,217,255,0.35)] hover:shadow-[0_0_30px_rgba(38,217,255,0.55)] transition-all duration-300 hover:scale-[1.03] gap-2 shrink-0"
            >
              <Download className="w-4 h-4 text-white" />
              <span className="text-white font-extrabold tracking-wide">Download SHIKHAR</span>
            </Link>
          </div>

          {/* Mobile Right Bar: Theme Toggle + Menu Hamburger */}
          <div className="flex md:hidden items-center gap-2">
            <ThemeToggle />

            <button
              onClick={() => setIsOpen(!isOpen)}
              className="p-2.5 rounded-xl text-[#A7B5CC] hover:text-white bg-[#101B35]/70 border border-white/10 focus:outline-none"
              aria-label="Toggle menu"
            >
              {isOpen ? <X className="w-5 h-5 text-white" /> : <Menu className="w-5 h-5 text-white" />}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Drawer Navigation */}
      {isOpen && (
        <div className="md:hidden bg-[#070D1D]/95 backdrop-blur-2xl border-b border-[#26D9FF]/20 px-4 pt-3 pb-6 mt-3 space-y-2 animate-in slide-in-from-top-4 duration-200 shadow-2xl">
          <div className="grid grid-cols-2 gap-2 pt-1 pb-2">
            {siteConfig.navItems.map((item) => {
              const isActive = pathname === item.href;
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  onClick={() => setIsOpen(false)}
                  className={`px-3 py-2.5 rounded-xl text-xs font-bold text-center transition-all ${
                    isActive
                      ? "bg-[#168BFF]/25 text-[#26D9FF] border border-[#26D9FF]/40 shadow-sm"
                      : "text-[#A7B5CC] hover:text-white hover:bg-white/5 bg-[#101B35]/40 border border-white/5"
                  }`}
                >
                  {item.label}
                </Link>
              );
            })}
          </div>

          {/* Mobile Drawer Action Buttons */}
          <div className="pt-2 space-y-2.5">
            <Link
              href="/downloads"
              onClick={() => setIsOpen(false)}
              className="w-full flex items-center justify-center gap-2 py-3.5 px-4 rounded-xl font-extrabold text-xs text-white bg-gradient-to-r from-[#168BFF] via-[#26D9FF] to-[#8B3DFF] shadow-lg shadow-[#168BFF]/25"
            >
              <Download className="w-4 h-4 text-white" />
              <span className="text-white font-extrabold">Download SHIKHAR (Windows & Android)</span>
            </Link>
          </div>
        </div>
      )}
    </nav>
  );
}
