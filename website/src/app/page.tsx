import { Navbar } from "@/components/layout/navbar";
import { Footer } from "@/components/layout/footer";
import { Hero } from "@/components/home/hero";
import { CorePromises } from "@/components/home/core-promises";
import { AdFreeShowcase } from "@/components/home/ad-free-showcase";
import { AiShowcase } from "@/components/home/ai-showcase";
import { DownloadSection } from "@/components/home/download-section";
import { FaqSection } from "@/components/home/faq-section";
import { FinalCta } from "@/components/home/final-cta";

export default function HomePage() {
  return (
    <div className="min-h-screen bg-[#070D1D] text-white selection:bg-[#26D9FF]/30 selection:text-white">
      <Navbar />
      <main>
        <Hero />
        <CorePromises />
        <AdFreeShowcase />
        <AiShowcase />
        <DownloadSection />
        <FaqSection />
        <FinalCta />
      </main>
      <Footer />
    </div>
  );
}
