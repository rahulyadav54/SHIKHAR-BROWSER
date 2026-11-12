"use client";

import React, { useEffect, useState } from "react";
import { Sun, Moon } from "lucide-react";
import { useTheme } from "./theme-provider";

interface ThemeToggleProps {
  className?: string;
  showLabel?: boolean;
}

export function ThemeToggle({ className = "", showLabel = false }: ThemeToggleProps) {
  const { theme, toggleTheme } = useTheme();
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return (
      <div className={`p-2 rounded-xl bg-white/5 border border-white/10 ${className}`}>
        <div className="w-5 h-5 opacity-0" />
      </div>
    );
  }

  const isLight = theme === "light";

  return (
    <button
      onClick={toggleTheme}
      type="button"
      aria-label={isLight ? "Switch to Dark Mode" : "Switch to Light Mode"}
      title={isLight ? "Switch to Dark Mode" : "Switch to Light Mode"}
      className={`relative inline-flex items-center gap-2 p-2 sm:px-3 sm:py-2 rounded-xl transition-all duration-300 ${
        isLight
          ? "bg-slate-200/80 hover:bg-slate-300 text-slate-800 border border-slate-300 shadow-sm"
          : "bg-[#101B35]/80 hover:bg-[#101B35] text-[#26D9FF] border border-[#26D9FF]/20 shadow-[0_0_15px_rgba(38,217,255,0.15)]"
      } ${className}`}
    >
      <div className="relative w-5 h-5 flex items-center justify-center">
        {isLight ? (
          <Moon className="w-4 h-4 text-amber-600 transition-transform duration-300 rotate-0 scale-100" />
        ) : (
          <Sun className="w-4 h-4 text-[#26D9FF] transition-transform duration-300 rotate-0 scale-100" />
        )}
      </div>

      {showLabel && (
        <span className="text-xs font-semibold">
          {isLight ? "Dark Mode" : "Light Mode"}
        </span>
      )}
    </button>
  );
}

