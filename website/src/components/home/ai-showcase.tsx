"use client";

import React, { useState } from "react";
import { Sparkles, Bot, ArrowRight, FileText, Code2, BookOpen, MessageSquare, Send } from "lucide-react";

export function AiShowcase() {
  const [activeTab, setActiveTab] = useState<"summary" | "code" | "research">("summary");

  const scenarios = {
    summary: {
      user: "Summarize the key architectural benefits of Chromium on multi-core processors.",
      ai: "1. Multi-Process Architecture: Every tab and extension runs in isolated render processes.\n2. Sandboxing & Memory Safety: Crashes in one tab don't bring down your entire browsing session.\n3. Hardware Acceleration: Offloads WebGL, Canvas, and video decoding directly to your GPU.\n4. Fluid Thread Scheduling: UI remains responsive even during heavy background tasks.",
    },
    code: {
      user: "How do I implement custom CSS glassmorphism in Tailwind v4?",
      ai: "Use backdrop-blur combined with semi-transparent background color:\n\n.glass {\n  background: rgba(16, 27, 53, 0.65);\n  backdrop-filter: blur(16px);\n  border: 1px solid rgba(38, 217, 255, 0.15);\n}\n\nThis delivers high performance on both Chromium and WebView engines.",
    },
    research: {
      user: "Extract the core conclusions from this scientific research paper.",
      ai: "The authors conclude that local-first computational models reduce telemetry exposure by 98% while improving query response latency from 1.4s to under 120ms through direct on-device caching.",
    },
  };

  return (
    <section className="py-24 relative overflow-hidden bg-[#050A17]">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#8B3DFF]/20 border border-[#8B3DFF]/40 text-[#A78BFA] text-xs font-bold mb-4">
            <Sparkles className="w-3.5 h-3.5" />
            <span>BUILT-IN INTELLIGENCE</span>
          </div>
          <h2 className="text-3xl sm:text-5xl font-black text-white mb-4">
            NOT JUST A BROWSER. <br />
            <span className="text-gradient">YOUR INTELLIGENT COMPANION.</span>
          </h2>
          <p className="text-base text-[#A7B5CC]">
            Meet <strong className="text-white">SHIKHAR AI</strong> — your custom browsing assistant designed to summarize webpages, explain technical docs, clarify difficult topics, and accelerate research in real-time.
          </p>
        </div>

        {/* Interactive AI Preview Sandbox */}
        <div className="max-w-4xl mx-auto glass-panel rounded-2xl overflow-hidden border border-[#26D9FF]/20 shadow-2xl">
          {/* Top Panel Bar */}
          <div className="bg-[#0C152B] px-6 py-4 flex flex-wrap items-center justify-between border-b border-white/10 gap-3">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-[#168BFF] to-[#8B3DFF] flex items-center justify-center text-white">
                <Bot className="w-4 h-4" />
              </div>
              <div>
                <h4 className="text-sm font-bold text-white flex items-center gap-2">
                  SHIKHAR AI Panel
                  <span className="text-[10px] px-2 py-0.5 rounded-full bg-emerald-500/20 text-emerald-400 font-mono">
                    ONLINE
                  </span>
                </h4>
                <p className="text-[10px] text-[#A7B5CC]">Context: Active Webpage Inspector</p>
              </div>
            </div>

            {/* Quick Actions Tabs */}
            <div className="flex items-center gap-2 bg-[#070D1D] p-1 rounded-xl border border-white/5 text-xs">
              <button
                onClick={() => setActiveTab("summary")}
                className={`px-3 py-1 rounded-lg font-medium transition-colors ${
                  activeTab === "summary"
                    ? "bg-[#168BFF] text-white font-bold"
                    : "text-[#A7B5CC] hover:text-white"
                }`}
              >
                Summarize
              </button>
              <button
                onClick={() => setActiveTab("code")}
                className={`px-3 py-1 rounded-lg font-medium transition-colors ${
                  activeTab === "code"
                    ? "bg-[#168BFF] text-white font-bold"
                    : "text-[#A7B5CC] hover:text-white"
                }`}
              >
                Code Assist
              </button>
              <button
                onClick={() => setActiveTab("research")}
                className={`px-3 py-1 rounded-lg font-medium transition-colors ${
                  activeTab === "research"
                    ? "bg-[#168BFF] text-white font-bold"
                    : "text-[#A7B5CC] hover:text-white"
                }`}
              >
                Research
              </button>
            </div>
          </div>

          {/* Conversation Body */}
          <div className="p-6 sm:p-8 space-y-6 min-h-[300px] bg-[#070D1D]/90">
            {/* User message */}
            <div className="flex items-start justify-end gap-3">
              <div className="max-w-lg p-4 rounded-2xl rounded-tr-sm bg-[#168BFF]/25 border border-[#168BFF]/40 text-sm text-white">
                {scenarios[activeTab].user}
              </div>
              <div className="w-8 h-8 rounded-full bg-slate-700 flex items-center justify-center text-xs font-bold text-white shrink-0">
                You
              </div>
            </div>

            {/* AI Response */}
            <div className="flex items-start gap-3">
              <div className="w-8 h-8 rounded-full bg-gradient-to-br from-[#26D9FF] to-[#8B3DFF] flex items-center justify-center text-white shrink-0 shadow-lg shadow-[#26D9FF]/30">
                <Sparkles className="w-4 h-4" />
              </div>
              <div className="max-w-xl p-5 rounded-2xl rounded-tl-sm bg-[#101B35] border border-white/10 text-sm text-[#A7B5CC] leading-relaxed whitespace-pre-line shadow-inner">
                <span className="font-semibold text-white block mb-2 text-xs uppercase tracking-wider">
                  SHIKHAR AI Response
                </span>
                {scenarios[activeTab].ai}
              </div>
            </div>
          </div>

          {/* Simulated Input Bar */}
          <div className="bg-[#0A1224] p-4 border-t border-white/10 flex items-center gap-3">
            <input
              type="text"
              readOnly
              value="Ask SHIKHAR AI anything about this page or topic..."
              className="flex-1 bg-[#070D1D] border border-white/10 rounded-xl px-4 py-2.5 text-xs text-[#A7B5CC] focus:outline-none"
            />
            <button className="p-2.5 rounded-xl bg-gradient-to-r from-[#168BFF] to-[#8B3DFF] text-white shadow-md">
              <Send className="w-4 h-4" />
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}

