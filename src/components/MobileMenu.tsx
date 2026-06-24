'use client';

import Link from 'next/link';
import Image from 'next/image';
import { usePathname } from 'next/navigation';
import { useEffect } from 'react';

interface MobileMenuProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function MobileMenu({ isOpen, onClose }: MobileMenuProps) {
  const pathname = usePathname();

  const isChannels = pathname === '/' || pathname.startsWith('/watch') || pathname.startsWith('/channel') || pathname.startsWith('/category');
  const isSchedule = pathname === '/upcoming';

  // Close on route change
  useEffect(() => {
    onClose();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [pathname]);

  // Close on ESC key
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose();
    };
    if (isOpen) document.addEventListener('keydown', onKey);
    return () => document.removeEventListener('keydown', onKey);
  }, [isOpen, onClose]);

  // Prevent body scroll when open
  useEffect(() => {
    document.body.style.overflow = isOpen ? 'hidden' : '';
    return () => { document.body.style.overflow = ''; };
  }, [isOpen]);

  return (
    <div
      className={`mobile-nav-overlay${isOpen ? ' active' : ''}`}
      id="mobileNavOverlay"
      onClick={(e) => { if (e.target === e.currentTarget) onClose(); }}
    >
      <div className="mobile-nav-drawer">
        <div className="mobile-nav-header">
          <Link href="/" className="logo" onClick={onClose}>
            <Image
              src="/assets/logo.webp"
              alt="Vibestream Logo"
              className="logo-img"
              width={32}
              height={32}
              priority
            />
            <div className="logo-text-group">
              <span className="logo-text">Vibestream</span>
              <span className="logo-subtitle">Live TV &amp; IPTV</span>
            </div>
          </Link>
          <button className="btn-close-nav" id="closeNavBtn" title="Close Menu" onClick={onClose}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <line x1="18" y1="6" x2="6" y2="18" />
              <line x1="6" y1="6" x2="18" y2="18" />
            </svg>
          </button>
        </div>
        <nav className="mobile-nav-menu">
          <Link href="/" className={`mobile-nav-link${isChannels ? ' active' : ''}`} onClick={onClose}>
            <svg className="nav-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <rect x="2" y="2" width="20" height="15" rx="2.18" ry="2.18" />
              <line x1="7" y1="22" x2="17" y2="22" />
              <line x1="12" y1="17" x2="12" y2="22" />
            </svg>
            <span>Channels</span>
          </Link>
          <Link href="/upcoming" className={`mobile-nav-link${isSchedule ? ' active' : ''}`} onClick={onClose}>
            <svg className="nav-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <circle cx="12" cy="12" r="10" />
              <polyline points="12 6 12 12 16 14" />
            </svg>
            <span>Schedule</span>
          </Link>
        </nav>
        <div className="mobile-nav-footer">
          <p>© 2026 Vibestream. All rights reserved.</p>
        </div>
      </div>
    </div>
  );
}
