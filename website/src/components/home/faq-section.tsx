"use client";

import React, { useState } from "react";
import { ChevronDown } from "lucide-react";

export function FaqSection() {
  const [openIdx, setOpenIdx] = useState<number | null>(0);

  const faqs = [
    {
      q: "What is SHIKHAR Browser?",
      a: "SHIKHAR Browser is a modern, high-performance web browser powered by the Chromium engine, designed specifically for Windows 10/11 and Android devices. It combines a 100% ad-free browser UI, a custom AI assistant, and a local-first privacy architecture.",
    },
    {
      q: "Is SHIKHAR Browser completely free?",
      a: "Yes. SHIKHAR Browser is completely free to download and use. It does not gate core browser features behind paywalls or sell user telemetry data.",
    },
    {
      q: "Does SHIKHAR display advertisements?",
      a: "No. SHIKHAR will never inject advertisements, sponsored affiliate tiles, banner popups, or paid recommendations into your browser interface or homepage. Your browser canvas remains clean and distraction-free.",
    },
    {
      q: "Does SHIKHAR block advertisements on websites?",
      a: "Yes. SHIKHAR includes built-in ad-blocking filters that suppress known web ad trackers, banner networks, and intrusive media overlays (including automated YouTube ad skipping). While third-party websites constantly evolve their ad technology, our engine actively targets high-friction ads.",
    },
    {
      q: "What is SHIKHAR AI?",
      a: "SHIKHAR AI is our custom-designed browsing intelligence integrated directly into the browser. It allows you to summarize long articles, ask questions about webpage content, understand code snippets, translate text, and generate structured notes without leaving your tab.",
    },
    {
      q: "Which AI models power SHIKHAR AI?",
      a: "SHIKHAR AI is engineered with a modular provider abstraction. It currently utilizes Google Gemini API models through an opt-in consent model, with support for user-supplied API keys stored securely in on-device keystores.",
    },
    {
      q: "Is my browsing history stored locally?",
      a: "Yes. All your bookmarks, history records, downloaded files metadata, and custom homepage shortcuts are stored in an encrypted SQLite database stored locally on your device. Zero remote telemetry is collected.",
    },
    {
      q: "Does SHIKHAR require an account to browse?",
      a: "No. You can download, install, and browse the web immediately without creating an account or logging into any cloud service.",
    },
    {
      q: "Is SHIKHAR available for both Windows and Android?",
      a: "Yes! SHIKHAR has dedicated native applications for Windows (64-bit standalone executable) and Android smartphones (ARM64 APK). Both builds share the same ad-free commitment and privacy architecture.",
    },
  ];

  return (
    <section id="faq" className="py-24 relative bg-[#070D1D]">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-xs uppercase font-extrabold tracking-widest text-[#26D9FF] mb-2">
            ANSWERS & TRANSPARENCY
          </h2>
          <p className="text-3xl sm:text-4xl font-black text-white">
            Frequently Asked Questions
          </p>
        </div>

        <div className="space-y-4">
          {faqs.map((faq, idx) => {
            const isOpen = openIdx === idx;
            return (
              <div
                key={idx}
                className="glass-panel rounded-2xl overflow-hidden border border-white/5 transition-colors"
              >
                <button
                  onClick={() => setOpenIdx(isOpen ? null : idx)}
                  className="w-full px-6 py-5 flex items-center justify-between text-left font-bold text-white text-sm sm:text-base hover:text-[#26D9FF] transition-colors"
                >
                  <span>{faq.q}</span>
                  <ChevronDown
                    className={`w-5 h-5 text-[#26D9FF] transition-transform duration-200 shrink-0 ml-4 ${
                      isOpen ? "rotate-180" : ""
                    }`}
                  />
                </button>
                {isOpen && (
                  <div className="px-6 pb-6 text-sm text-[#A7B5CC] leading-relaxed border-t border-white/5 pt-4">
                    {faq.a}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}

