import React from "react";
import { ShieldCheck, Sparkles, Lock, ArrowUpRight } from "lucide-react";
import Link from "next/link";

export function CorePromises() {
  const promises = [
    {
      icon: ShieldCheck,
      color: "text-emerald-400",
      border: "hover:border-emerald-500/40",
      glow: "group-hover:shadow-[0_0_30px_rgba(52,211,153,0.2)]",
      badge: "NO ADS • NO POPUPS",
      title: "NO ADS. NO DISTRACTIONS.",
      description:
        "Enjoy an interface free from SHIKHAR-injected advertisements and sponsored placements. Focus on reading, research, and work without noise.",
      link: "/ad-free",
    },
    {
      icon: Sparkles,
      color: "text-[#26D9FF]",
      border: "hover:border-[#26D9FF]/40",
      glow: "group-hover:shadow-[0_0_30px_rgba(38,217,255,0.2)]",
      badge: "INTEGRATED AI ASSISTANT",
      title: "YOUR AI. YOUR BROWSER.",
      description:
        "Meet SHIKHAR AI, your intelligent browsing companion built directly into the UI to summarize, analyze, translate, and explain complex topics.",
      link: "/ai",
    },
    {
      icon: Lock,
      color: "text-[#8B3DFF]",
      border: "hover:border-[#8B3DFF]/40",
      glow: "group-hover:shadow-[0_0_30px_rgba(139,61,255,0.2)]",
      badge: "LOCAL-FIRST DATA",
      title: "YOUR DATA. YOUR CONTROL.",
      description:
        "Keep your browsing experience personal with local-first encrypted storage for bookmarks, history, and downloads. Zero mandatory accounts.",
      link: "/privacy",
    },
  ];

  return (
    <section className="py-20 relative z-10">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-2xl mx-auto mb-14">
          <h2 className="text-xs uppercase font-extrabold tracking-widest text-[#26D9FF] mb-2">
            THE SHIKHAR STANDARD
          </h2>
          <p className="text-2xl sm:text-4xl font-black text-white">
            Three Core Commitments to Every Explorer
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {promises.map((p, idx) => {
            const Icon = p.icon;
            return (
              <Link
                key={idx}
                href={p.link}
                className={`group glass-panel rounded-2xl p-8 relative overflow-hidden transition-all duration-300 ${p.border} ${p.glow} flex flex-col justify-between`}
              >
                <div>
                  <div className="flex items-center justify-between mb-6">
                    <div className="p-3 rounded-xl bg-white/5 border border-white/10 group-hover:scale-110 transition-transform duration-200">
                      <Icon className={`w-6 h-6 ${p.color}`} />
                    </div>
                    <span className="text-[10px] font-bold px-2.5 py-1 rounded-full bg-white/5 border border-white/10 text-white/80">
                      {p.badge}
                    </span>
                  </div>
                  <h3 className="text-xl font-black text-white mb-3 group-hover:text-[#26D9FF] transition-colors">
                    {p.title}
                  </h3>
                  <p className="text-sm text-[#A7B5CC] leading-relaxed mb-6">
                    {p.description}
                  </p>
                </div>

                <div className="flex items-center gap-1.5 text-xs font-bold text-white group-hover:text-[#26D9FF] transition-colors pt-4 border-t border-white/5">
                  <span>Learn more</span>
                  <ArrowUpRight className="w-4 h-4 transition-transform group-hover:translate-x-0.5 group-hover:-translate-y-0.5" />
                </div>
              </Link>
            );
          })}
        </div>
      </div>
    </section>
  );
}

