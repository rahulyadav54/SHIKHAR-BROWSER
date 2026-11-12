import React from "react";

export function MountainLogo({ className = "w-9 h-9" }: { className?: string }) {
  return (
    <div className={`relative flex items-center justify-center ${className}`}>
      <svg viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg" className="w-full h-full drop-shadow-[0_0_12px_rgba(38,217,255,0.4)]">
        <defs>
          <linearGradient id="shikharPrimaryGrad" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stopColor="#26D9FF" />
            <stop offset="60%" stopColor="#168BFF" />
            <stop offset="100%" stopColor="#8B3DFF" />
          </linearGradient>
          <linearGradient id="shikharPeakGrad" x1="50%" y1="0%" x2="50%" y2="100%">
            <stop offset="0%" stopColor="#FFFFFF" />
            <stop offset="100%" stopColor="#26D9FF" />
          </linearGradient>
        </defs>

        {/* Outer Hexagon Frame */}
        <polygon
          points="50,6 88,28 88,72 50,94 12,72 12,28"
          stroke="url(#shikharPrimaryGrad)"
          strokeWidth="3.5"
          fill="rgba(16, 27, 53, 0.4)"
        />

        {/* Himalayan Twin Peaks (SHIKHAR) */}
        {/* Left Peak */}
        <polygon
          points="32,70 48,34 58,70"
          fill="url(#shikharPrimaryGrad)"
          opacity="0.85"
        />

        {/* Primary Mount Everest Summit Peak */}
        <polygon
          points="46,70 56,22 76,70"
          fill="url(#shikharPeakGrad)"
        />

        {/* Mountain ridge reflection */}
        <line x1="56" y1="22" x2="62" y2="70" stroke="#FFFFFF" strokeWidth="1.5" opacity="0.6" />
      </svg>
    </div>
  );
}

