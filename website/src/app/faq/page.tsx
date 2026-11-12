import React from "react";
import { Navbar } from "@/components/layout/navbar";
import { Footer } from "@/components/layout/footer";
import { FaqSection } from "@/components/home/faq-section";

export const metadata = {
  title: "FAQ — SHIKHAR Browser",
  description: "Frequently asked questions about SHIKHAR Browser, ad blocking, AI assistant features, local privacy, and release builds.",
};

export default function FaqPage() {
  return (
    <div className="min-h-screen bg-[#070D1D] text-white">
      <Navbar />
      <main className="pt-24 pb-20">
        <FaqSection />
      </main>
      <Footer />
    </div>
  );
}

