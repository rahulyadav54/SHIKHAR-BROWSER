import React from "react";
import { Navbar } from "@/components/layout/navbar";
import { Footer } from "@/components/layout/footer";
import { MountainLogo } from "@/components/ui/mountain-logo";
import { siteConfig } from "@/config/site";
import { Target, Flag, Code2, Users, Heart } from "lucide-react";

export const metadata = {
  title: "About SHIKHAR Browser — The Vision",
  description: "Learn about the story, development team, and vision behind SHIKHAR Browser. Developed by ZAYA CODE HUB.",
};

export default function AboutPage() {
  return (
    <div className="min-h-screen bg-[#070D1D] text-white">
      <Navbar />
      <main className="pt-32 pb-24 max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="w-16 h-16 mx-auto mb-4">
            <MountainLogo className="w-full h-full" />
          </div>
          <span className="text-xs font-bold px-3 py-1 rounded-full bg-[#168BFF]/20 text-[#26D9FF] border border-[#26D9FF]/40">
            OUR STORY & PHILOSOPHY
          </span>
          <h1 className="text-4xl sm:text-6xl font-black text-white mt-4 mb-4">
            Crafting the Summit of Browsing.
          </h1>
          <p className="text-base text-[#A7B5CC]">
            "SHIKHAR" is the Sanskrit and Nepali word for the highest mountain peak or summit. We set out to build a browser that reaches higher standards of speed, dignity, and user respect.
          </p>
        </div>

        <div className="space-y-12 text-sm text-[#A7B5CC] leading-relaxed">
          <div className="glass-panel rounded-2xl p-8 border border-white/10 space-y-4">
            <h3 className="text-xl font-bold text-white flex items-center gap-2">
              <Target className="w-5 h-5 text-[#26D9FF]" />
              The ZAYA CODE HUB Mission
            </h3>
            <p>
              Developed by <strong>{siteConfig.developer}</strong>, SHIKHAR Browser began with a simple frustration: modern commercial browsers have turned into invasive ad networks. They inject sponsored shopping links, pre-load clickbait newsfeeds, track users across the web, and force cloud telemetry onto every action.
            </p>
            <p>
              SHIKHAR returns to the original spirit of the personal computer: software that serves its user faithfully without compromise.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div className="glass-panel rounded-2xl p-6 border border-white/5">
              <h4 className="font-bold text-white mb-2 flex items-center gap-2 text-base">
                <Flag className="w-5 h-5 text-emerald-400" />
                Cultural Heritage & Identity
              </h4>
              <p className="text-xs text-[#A7B5CC] leading-relaxed">
                SHIKHAR celebrates Himalayan heritage, featuring an authentic cultural introduction video with traditional instrumental music, paying tribute to the beauty and resilience of the mountains.
              </p>
            </div>

            <div className="glass-panel rounded-2xl p-6 border border-white/5">
              <h4 className="font-bold text-white mb-2 flex items-center gap-2 text-base">
                <Code2 className="w-5 h-5 text-[#8B3DFF]" />
                Modern Engineering Stack
              </h4>
              <p className="text-xs text-[#A7B5CC] leading-relaxed">
                Built with Flutter and high-performance native Chromium WebViews (WebView2 on Windows, Android WebKit on mobile), providing blistering frame rates, fluid gesture physics, and complete hardware acceleration.
              </p>
            </div>
          </div>
        </div>
      </main>
      <Footer />
    </div>
  );
}

