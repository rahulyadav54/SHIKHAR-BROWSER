import React from "react";
import { Navbar } from "@/components/layout/navbar";
import { Footer } from "@/components/layout/footer";
import { Sparkles, Bot, BrainCircuit, FileSearch, HelpCircle, Code, Globe2, ShieldCheck } from "lucide-react";
import Link from "next/link";

export const metadata = {
  title: "SHIKHAR AI — Intelligent Browsing Assistant",
  description: "Meet SHIKHAR AI, your built-in browser intelligence for real-time webpage summarization, code explanation, research synthesis, and notes generation.",
};

export default function AiPage() {
  const capabilities = [
    {
      icon: FileSearch,
      title: "Real-time Webpage Summarization",
      desc: "Distill 20-minute editorial essays, research papers, or documentation pages into concise, bulleted action points in seconds.",
    },
    {
      icon: Code,
      title: "Developer & Code Explanation",
      desc: "Select tricky algorithms, APIs, or stack traces on GitHub and StackOverflow to receive step-by-step walkthroughs and fixes.",
    },
    {
      icon: BrainCircuit,
      title: "Concept Simplification",
      desc: "Turn complicated legal disclaimers, financial terms, or medical studies into clear, everyday language anyone can understand.",
    },
    {
      icon: Globe2,
      title: "Contextual Translation & Synthesis",
      desc: "Break language barriers with contextual foreign language translations that preserve nuance and domain-specific terminology.",
    },
  ];

  return (
    <div className="min-h-screen bg-[#070D1D] text-white">
      <Navbar />
      <main className="pt-32 pb-24 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <span className="text-xs font-bold px-3 py-1 rounded-full bg-[#8B3DFF]/20 text-[#A78BFA] border border-[#8B3DFF]/40">
            INTEGRATED ASSISTANT ARCHITECTURE
          </span>
          <h1 className="text-4xl sm:text-6xl font-black text-white mt-4 mb-4">
            Meet SHIKHAR AI.
          </h1>
          <p className="text-base text-[#A7B5CC]">
            Engineered as an integral layer of the browser interface, not an external tab. Instant answers, webpage context, and zero tab-switching friction.
          </p>
        </div>

        {/* Capabilities Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-20">
          {capabilities.map((c, idx) => {
            const Icon = c.icon;
            return (
              <div key={idx} className="glass-panel rounded-2xl p-8 border border-white/5 hover:border-[#8B3DFF]/40 transition-all">
                <div className="p-3 rounded-xl bg-[#8B3DFF]/15 border border-[#8B3DFF]/30 text-[#A78BFA] w-fit mb-5">
                  <Icon className="w-6 h-6" />
                </div>
                <h3 className="text-xl font-bold text-white mb-2">{c.title}</h3>
                <p className="text-sm text-[#A7B5CC] leading-relaxed">{c.desc}</p>
              </div>
            );
          })}
        </div>

        {/* Transparency Banner */}
        <div className="glass-panel rounded-2xl p-8 border border-white/10 bg-[#101B35]/60 text-xs text-[#A7B5CC] max-w-4xl mx-auto leading-relaxed space-y-3">
          <div className="flex items-center gap-2 text-white font-bold text-sm">
            <ShieldCheck className="w-5 h-5 text-emerald-400" />
            <span>AI Architecture & Privacy Transparency</span>
          </div>
          <p>
            SHIKHAR AI uses a secure abstraction connecting to verified language models (such as Google Gemini). Webpage content is only analyzed when you explicitly open the assistant and click summarize or ask a question.
          </p>
          <p>
            SHIKHAR does not claim to have trained an independent foundation model from scratch. We focus on delivering the fastest, most convenient browsing integration with on-device API key support.
          </p>
        </div>
      </main>
      <Footer />
    </div>
  );
}

