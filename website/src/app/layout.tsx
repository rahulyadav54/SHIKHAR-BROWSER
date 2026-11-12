import type { Metadata } from "next";
import { siteConfig } from "@/config/site";
import { ThemeProvider } from "@/components/theme/theme-provider";
import "./globals.css";

export const metadata: Metadata = {
  metadataBase: new URL(siteConfig.url),
  title: {
    default: "SHIKHAR Browser — Ad-Free, AI-Powered, Built For You",
    template: "%s | SHIKHAR Browser",
  },
  description: siteConfig.description,
  keywords: [
    "SHIKHAR Browser",
    "Ad-Free Browser",
    "AI Browser",
    "Chromium Browser",
    "Browser for Windows",
    "Browser for Android",
    "Fast Privacy Browser",
    "ZAYA CODE HUB",
  ],
  authors: [{ name: siteConfig.developer }],
  creator: siteConfig.developer,
  openGraph: {
    type: "website",
    locale: "en_US",
    url: siteConfig.url,
    title: siteConfig.name,
    description: siteConfig.description,
    siteName: siteConfig.name,
  },
  twitter: {
    card: "summary_large_image",
    title: siteConfig.name,
    description: siteConfig.description,
  },
  robots: {
    index: true,
    follow: true,
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="dark scroll-smooth" suppressHydrationWarning>
      <head>
        <script
          dangerouslySetInnerHTML={{
            __html: `
              try {
                var storedTheme = localStorage.getItem('shikhar-theme');
                if (storedTheme === 'light' || (!storedTheme && window.matchMedia('(prefers-color-scheme: light)').matches)) {
                  document.documentElement.classList.remove('dark');
                  document.documentElement.classList.add('light');
                } else {
                  document.documentElement.classList.remove('light');
                  document.documentElement.classList.add('dark');
                }
              } catch (_) {}
            `,
          }}
        />
      </head>
      <body className="bg-[#070D1D] text-white antialiased min-h-screen">
        <ThemeProvider>
          {children}
        </ThemeProvider>
      </body>
    </html>
  );
}
