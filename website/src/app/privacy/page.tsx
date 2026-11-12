import React from "react";
import { Navbar } from "@/components/layout/navbar";
import { Footer } from "@/components/layout/footer";
import { Lock, HardDrive, UserX, ShieldAlert, CheckCircle } from "lucide-react";

export const metadata = {
  title: "Privacy & Security — SHIKHAR Browser",
  description: "Read our privacy-first philosophy: on-device SQLite database storage, zero mandatory cloud sync, no tracking, and complete user data sovereignty.",
};

export default function PrivacyPage() {
  return (
    <div className="min-h-screen bg-[#070D1D] text-white">
      <Navbar />
      <main className="pt-32 pb-24 max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <span className="text-xs font-bold px-3 py-1 rounded-full bg-[#8B3DFF]/20 text-[#A78BFA] border border-[#8B3DFF]/40">
            SOVEREIGNTY BY DESIGN
          </span>
          <h1 className="text-4xl sm:text-6xl font-black text-white mt-4 mb-4">
            Your Data. Your Control.
          </h1>
          <p className="text-base text-[#A7B5CC]">
            Traditional browsers make you the product by turning your history into advertising profiles. SHIKHAR was built from the ground up on local-first principles.
          </p>
        </div>

        <div className="space-y-8 text-sm text-[#A7B5CC] leading-relaxed">
          <div className="glass-panel rounded-2xl p-8 border border-white/10 space-y-4">
            <h3 className="text-xl font-bold text-white flex items-center gap-2.5">
              <HardDrive className="w-5 h-5 text-[#26D9FF]" />
              1. Local SQLite Storage Architecture
            </h3>
            <p>
              Your browsing history, bookmarks, active tabs state, and downloaded file logs are stored strictly inside a sandboxed SQLite database file residing on your physical machine. We do not host remote sync servers that store your web trails.
            </p>
          </div>

          <div className="glass-panel rounded-2xl p-8 border border-white/10 space-y-4">
            <h3 className="text-xl font-bold text-white flex items-center gap-2.5">
              <UserX className="w-5 h-5 text-[#8B3DFF]" />
              2. Zero Mandatory Accounts
            </h3>
            <p>
              You do not need to register an email address, link a phone number, or sign in to browse the web with SHIKHAR. You open the application and start browsing immediately with full features unlocked.
            </p>
          </div>

          <div className="glass-panel rounded-2xl p-8 border border-white/10 space-y-4">
            <h3 className="text-xl font-bold text-white flex items-center gap-2.5">
              <Lock className="w-5 h-5 text-emerald-400" />
              3. Private Browsing Mode
            </h3>
            <p>
              SHIKHAR includes an isolated Private Browsing mode that activates an ephemeral in-memory profile. History, temporary cookies, cache fragments, and site storage are purged the instant the private session is closed.
            </p>
          </div>
        </div>
      </main>
      <Footer />
    </div>
  );
}

