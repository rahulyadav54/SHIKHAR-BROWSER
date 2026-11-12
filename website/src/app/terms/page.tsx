import React from "react";
import { Navbar } from "@/components/layout/navbar";
import { Footer } from "@/components/layout/footer";

export const metadata = {
  title: "Terms of Service — SHIKHAR Browser",
  description: "Terms and conditions governing the use of SHIKHAR Browser software and official web services.",
};

export default function TermsPage() {
  return (
    <div className="min-h-screen bg-[#070D1D] text-white">
      <Navbar />
      <main className="pt-32 pb-24 max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <h1 className="text-3xl sm:text-5xl font-black text-white mb-6">Terms of Service</h1>
        <p className="text-xs text-[#26D9FF] font-mono mb-10">Last Updated: November 2026</p>

        <div className="space-y-8 text-sm text-[#A7B5CC] leading-relaxed">
          <section className="glass-panel rounded-2xl p-6 sm:p-8 border border-white/5 space-y-3">
            <h2 className="text-lg font-bold text-white">1. Acceptance of Terms</h2>
            <p>
              By downloading, installing, or accessing SHIKHAR Browser, you agree to be bound by these Terms of Service. If you do not agree with any part of these terms, please discontinue use of the software.
            </p>
          </section>

          <section className="glass-panel rounded-2xl p-6 sm:p-8 border border-white/5 space-y-3">
            <h2 className="text-lg font-bold text-white">2. License Grant</h2>
            <p>
              ZAYA CODE HUB grants you a personal, non-exclusive, revocable, worldwide, royalty-free license to download and run SHIKHAR Browser for personal and commercial productivity purposes in accordance with these terms.
            </p>
          </section>

          <section className="glass-panel rounded-2xl p-6 sm:p-8 border border-white/5 space-y-3">
            <h2 className="text-lg font-bold text-white">3. Acceptable Use</h2>
            <p>
              You agree not to modify, reverse-engineer, decompile, or tamper with the security sandbox or distributed packages of SHIKHAR Browser, or utilize the software for unauthorized intrusion, denial-of-service, or unlawful activities.
            </p>
          </section>

          <section className="glass-panel rounded-2xl p-6 sm:p-8 border border-white/5 space-y-3">
            <h2 className="text-lg font-bold text-white">4. Disclaimer of Warranties</h2>
            <p>
              SHIKHAR Browser is provided on an "as-is" and "as-available" basis. While we strive to maintain top-tier stability, privacy protections, and rendering compliance, ZAYA CODE HUB disclaims all warranties, express or implied.
            </p>
          </section>
        </div>
      </main>
      <Footer />
    </div>
  );
}

