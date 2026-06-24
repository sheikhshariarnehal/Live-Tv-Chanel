'use client';

import Link from 'next/link';
import Image from 'next/image';
import { usePathname } from 'next/navigation';
import { useState } from 'react';
import MobileMenu from './MobileMenu';

interface HeaderProps {
  showChannelListBtn?: boolean;
  onOpenChannelList?: () => void;
}

export default function Header({ showChannelListBtn = false, onOpenChannelList }: HeaderProps) {
  const pathname = usePathname();
  const [navOpen, setNavOpen] = useState(false);

  const isChannels = pathname === '/' || pathname.startsWith('/watch') || pathname.startsWith('/channel') || pathname.startsWith('/category');
  const isSchedule = pathname === '/upcoming';

  return (
    <>
      <header className="header">
        <div className="header-content">
          <Link href="/" className="logo">
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

          {/* Desktop Nav */}
          <nav className="nav-menu">
            <Link href="/" className={`nav-link${isChannels ? ' active' : ''}`}>
              <span>Channels</span>
            </Link>
            <Link href="/upcoming" className={`nav-link${isSchedule ? ' active' : ''}`}>
              <span>Schedule</span>
            </Link>
          </nav>

          <div className="header-actions">
            {showChannelListBtn && (
              <button
                className="btn-icon mobile-menu-toggle"
                id="mobileMenuBtn"
                title="Channels List"
                onClick={onOpenChannelList}
              >
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <line x1="8" y1="6" x2="21" y2="6" />
                  <line x1="8" y1="12" x2="21" y2="12" />
                  <line x1="8" y1="18" x2="21" y2="18" />
                  <line x1="3" y1="6" x2="3.01" y2="6" />
                  <line x1="3" y1="12" x2="3.01" y2="12" />
                  <line x1="3" y1="18" x2="3.01" y2="18" />
                </svg>
              </button>
            )}
            <button
              className="btn-icon nav-toggle-btn"
              id="navToggleBtn"
              title="Navigation Menu"
              onClick={() => setNavOpen(true)}
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <line x1="3" y1="12" x2="21" y2="12" />
                <line x1="3" y1="6" x2="21" y2="6" />
                <line x1="3" y1="18" x2="21" y2="18" />
              </svg>
            </button>
          </div>
        </div>
      </header>

      <MobileMenu isOpen={navOpen} onClose={() => setNavOpen(false)} />
    </>
  );
}
