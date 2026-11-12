"use client";

import React, { useState } from "react";
import { Navbar } from "@/components/layout/navbar";
import { Footer } from "@/components/layout/footer";
import { Mail, MessageSquare, Send, CheckCircle, ShieldCheck } from "lucide-react";

export default function ContactPage() {
  const [submitted, setSubmitted] = useState(false);
  const [formData, setFormData] = useState({ name: "", email: "", subject: "", message: "" });
  const [error, setError] = useState("");

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.name || !formData.email || !formData.message) {
      setError("Please complete all required fields.");
      return;
    }
    setError("");
    setSubmitted(true);
  };

  return (
    <div className="min-h-screen bg-[#070D1D] text-white">
      <Navbar />
      <main className="pt-32 pb-24 max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-2xl mx-auto mb-16">
          <span className="text-xs font-bold px-3 py-1 rounded-full bg-[#168BFF]/20 text-[#26D9FF] border border-[#26D9FF]/40">
            CONNECT WITH THE CREATORS
          </span>
          <h1 className="text-4xl sm:text-5xl font-black text-white mt-4 mb-4">
            Contact & Support
          </h1>
          <p className="text-base text-[#A7B5CC]">
            Have feature suggestions, bug reports, or partnership inquiries? Reach out directly to the SHIKHAR development team.
          </p>
        </div>

        <div className="glass-panel rounded-3xl p-8 sm:p-12 border border-white/10 shadow-2xl">
          {submitted ? (
            <div className="text-center py-12 space-y-4">
              <div className="w-16 h-16 mx-auto rounded-full bg-emerald-500/20 text-emerald-400 flex items-center justify-center border border-emerald-500/30">
                <CheckCircle className="w-8 h-8" />
              </div>
              <h3 className="text-2xl font-bold text-white">Message Received!</h3>
              <p className="text-sm text-[#A7B5CC] max-w-md mx-auto">
                Thank you for contacting ZAYA CODE HUB. Our engineering team reviews all community reports and suggestions.
              </p>
              <button
                onClick={() => {
                  setSubmitted(false);
                  setFormData({ name: "", email: "", subject: "", message: "" });
                }}
                className="mt-4 px-6 py-2.5 rounded-full text-xs font-bold bg-[#101B35] text-white hover:bg-[#168BFF] transition-colors"
              >
                Send Another Message
              </button>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-6">
              {error && (
                <div className="p-4 rounded-xl bg-red-500/10 border border-red-500/30 text-xs text-red-300">
                  {error}
                </div>
              )}

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
                <div>
                  <label className="block text-xs font-bold text-white mb-2">Your Name *</label>
                  <input
                    type="text"
                    required
                    value={formData.name}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    placeholder="e.g. Alex Sharma"
                    className="w-full px-4 py-3 rounded-xl bg-[#070D1D] border border-white/10 text-white text-sm focus:border-[#26D9FF] focus:outline-none"
                  />
                </div>
                <div>
                  <label className="block text-xs font-bold text-white mb-2">Email Address *</label>
                  <input
                    type="email"
                    required
                    value={formData.email}
                    onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                    placeholder="alex@example.com"
                    className="w-full px-4 py-3 rounded-xl bg-[#070D1D] border border-white/10 text-white text-sm focus:border-[#26D9FF] focus:outline-none"
                  />
                </div>
              </div>

              <div>
                <label className="block text-xs font-bold text-white mb-2">Subject</label>
                <input
                  type="text"
                  value={formData.subject}
                  onChange={(e) => setFormData({ ...formData, subject: e.target.value })}
                  placeholder="Bug Report, Feature Request, or General Feedback"
                  className="w-full px-4 py-3 rounded-xl bg-[#070D1D] border border-white/10 text-white text-sm focus:border-[#26D9FF] focus:outline-none"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-white mb-2">Message *</label>
                <textarea
                  required
                  rows={5}
                  value={formData.message}
                  onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                  placeholder="Provide details about your inquiry or suggestions..."
                  className="w-full px-4 py-3 rounded-xl bg-[#070D1D] border border-white/10 text-white text-sm focus:border-[#26D9FF] focus:outline-none resize-none"
                />
              </div>

              <button
                type="submit"
                className="w-full py-4 rounded-xl font-bold text-sm text-white bg-gradient-to-r from-[#168BFF] to-[#8B3DFF] shadow-lg shadow-[#168BFF]/30 hover:opacity-95 transition-all flex items-center justify-center gap-2"
              >
                <Send className="w-4 h-4" />
                <span>Submit Feedback to ZAYA CODE HUB</span>
              </button>
            </form>
          )}
        </div>
      </main>
      <Footer />
    </div>
  );
}

