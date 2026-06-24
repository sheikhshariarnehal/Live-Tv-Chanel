'use client';

import { useState, useEffect } from 'react';
import Header from '@/components/Header';
import NewsTicker from '@/components/NewsTicker';
import Link from 'next/link';

interface Match {
  id: string;
  date: string;
  group: string;
  home: string;
  away: string;
  venue: string;
  stage: string;
}

interface UpcomingPageClientProps {
  matches: Match[];
}

const MATCH_DURATION_MS = 2.5 * 60 * 60 * 1000; // 150 mins
const BD_OFFSET_MIN = 6 * 60;

const DAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
const MONTHS = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

const TEAM_FLAG: Record<string, string> = {
  Mexico: 'mx',
  'South Africa': 'za',
  'South Korea': 'kr',
  Czechia: 'cz',
  Canada: 'ca',
  'Bosnia and Herzegovina': 'ba',
  'United States': 'us',
  Paraguay: 'py',
  Qatar: 'qa',
  Switzerland: 'ch',
  Brazil: 'br',
  Morocco: 'ma',
  Haiti: 'ht',
  Scotland: 'gb_sct',
  Australia: 'au',
  Türkiye: 'tr',
  Germany: 'de',
  Curaçao: 'cw',
  Netherlands: 'nl',
  Japan: 'jp',
  'Ivory Coast': 'ci',
  Ecuador: 'ec',
  Sweden: 'se',
  Tunisia: 'tn',
  Spain: 'es',
  'Cape Verde': 'cv',
  Belgium: 'be',
  Egypt: 'eg',
  'Saudi Arabia': 'sa',
  Uruguay: 'uy',
  Iran: 'ir',
  'New Zealand': 'nz',
  France: 'fr',
  Senegal: 'sn',
  Iraq: 'iq',
  Norway: 'no',
  Argentina: 'ar',
  Algeria: 'dz',
  Austria: 'at',
  Jordan: 'jo',
  Portugal: 'pt',
  'DR Congo': 'cd',
  England: 'gb_eng',
  Croatia: 'hr',
  Ghana: 'gh',
  Panama: 'pa',
  Uzbekistan: 'uz',
  Colombia: 'co',
};

function flagUrl(name: string): string {
  const code = TEAM_FLAG[name];
  return code ? `/assets/flags/${code}.svg` : '';
}

function toBangladeshParts(iso: string) {
  const d = new Date(iso);
  const bd = new Date(d.getTime() + BD_OFFSET_MIN * 60 * 1000);
  return {
    year: bd.getUTCFullYear(),
    month: bd.getUTCMonth(),
    date: bd.getUTCDate(),
    day: bd.getUTCDay(),
    hours: bd.getUTCHours(),
    minutes: bd.getUTCMinutes(),
  };
}

function pad(n: number) {
  return n < 10 ? '0' + n : '' + n;
}

function bdTimeLabel(iso: string) {
  const p = toBangladeshParts(iso);
  return `${DAYS[p.day]}, ${pad(p.date)} ${MONTHS[p.month]} ${p.year}`;
}

function bdClockHours(iso: string) {
  const p = toBangladeshParts(iso);
  const hours12 = p.hours % 12 || 12;
  return `${pad(hours12)}:${pad(p.minutes)}`;
}

function bdClockAmPm(iso: string) {
  const p = toBangladeshParts(iso);
  return p.hours >= 12 ? 'PM' : 'AM';
}

function bdClock(iso: string) {
  return `${bdClockHours(iso)} ${bdClockAmPm(iso)}`;
}

function formatMini(diff: number) {
  const h = Math.floor(diff / 3600000);
  const m = Math.floor((diff % 3600000) / 60000);
  return `${h}h ${m}m`;
}

export default function UpcomingPageClient({ matches }: UpcomingPageClientProps) {
  const [now, setNow] = useState<number | null>(null);
  const [activeFilter, setActiveFilter] = useState('upcoming');

  // Spotlight match states
  const [spotlightMatch, setSpotlightMatch] = useState<Match | null>(null);
  const [isSpotlightLive, setIsSpotlightLive] = useState(false);
  const [countdown, setCountdown] = useState({ d: '00', h: '00', m: '00', s: '00' });

  // Update clock every second
  useEffect(() => {
    setNow(Date.now());
    const timer = setInterval(() => {
      setNow(Date.now());
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  // Tick calculation for Spotlight & schedule states
  useEffect(() => {
    if (!now) return;

    let nextUpcoming: Match | null = null;
    let liveMatch: Match | null = null;

    for (const m of matches) {
      const target = new Date(m.date).getTime();
      const diff = target - now;

      if (diff > 0) {
        if (!nextUpcoming || target < new Date(nextUpcoming!.date).getTime()) {
          nextUpcoming = m;
        }
      } else if (Math.abs(diff) < MATCH_DURATION_MS) {
        if (!liveMatch || target > new Date(liveMatch!.date).getTime()) {
          liveMatch = m;
        }
      }
    }

    const active = liveMatch || nextUpcoming;
    setSpotlightMatch(active);
    setIsSpotlightLive(!!liveMatch);

    if (!liveMatch && nextUpcoming) {
      const targetTime = new Date(nextUpcoming.date).getTime();
      const diff = targetTime - now;
      if (diff > 0) {
        const d = Math.floor(diff / 86400000);
        const h = Math.floor((diff % 86400000) / 3600000);
        const m = Math.floor((diff % 3600000) / 60000);
        const s = Math.floor((diff % 60000) / 1000);
        setCountdown({
          d: String(d).padStart(2, '0'),
          h: String(h).padStart(2, '0'),
          m: String(m).padStart(2, '0'),
          s: String(s).padStart(2, '0'),
        });
      }
    }
  }, [now, matches]);

  const handleFilterClick = (filter: string) => {
    setActiveFilter(filter);
  };

  const nowBd = now ? new Date(now + BD_OFFSET_MIN * 60 * 1000) : null;
  const todayYear = nowBd ? nowBd.getUTCFullYear() : null;
  const todayMonth = nowBd ? nowBd.getUTCMonth() : null;
  const todayDate = nowBd ? nowBd.getUTCDate() : null;

  // Filter matches list
  const filteredMatches = matches.filter((m) => {
    if (!now) return true;
    const target = new Date(m.date).getTime();

    if (activeFilter === 'all') return true;
    if (activeFilter === 'upcoming') return target + MATCH_DURATION_MS > now;
    if (activeFilter === 'Group Stage') return m.stage === 'Group Stage';
    return m.stage === activeFilter;
  });

  return (
    <div className="portal-layout min-h-screen flex flex-col bg-[#0a0a0a] text-white">
      <Header />
      <NewsTicker />

      <main className="main-container flex-1">
        <div className="wc-wrapper">
          {/* Hero Spotlight */}
          <header className="wc-hero">
            <div className="wc-hero-inner">
              <div className="wc-hero-tag">⚽ 11 June – 19 July 2026 · Canada · Mexico · USA</div>
              <h1 className="wc-hero-title">FIFA World Cup 2026™</h1>
              <p className="wc-hero-subtitle">
                Complete match schedule with live countdown timers. All times shown in{' '}
                <strong>Bangladesh Time (BST, UTC+6)</strong>.
              </p>

              {spotlightMatch && (
                <div className={`wc-next ${isSpotlightLive ? 'is-live' : ''}`} id="nextMatchCard">
                  <div className="wc-next-label">
                    <span className="live-dot"></span>{' '}
                    <span>{isSpotlightLive ? 'Match is Live Now' : 'Next Match Kick-off In'}</span>
                  </div>
                  
                  <div className="wc-next-teams">
                    <div className="wc-next-team">
                      <div className="wc-next-flag-wrapper">
                        {flagUrl(spotlightMatch.home) ? (
                          // eslint-disable-next-line @next/next/no-img-element
                          <img
                            src={flagUrl(spotlightMatch.home)}
                            alt={spotlightMatch.home}
                            className="wc-flag"
                          />
                        ) : (
                          <span className="wc-flag-ph">?</span>
                        )}
                      </div>
                      <span className="wc-next-name">{spotlightMatch.home}</span>
                    </div>
                    
                    <div className="wc-next-vs">VS</div>
                    
                    <div className="wc-next-team">
                      <div className="wc-next-flag-wrapper">
                        {flagUrl(spotlightMatch.away) ? (
                          // eslint-disable-next-line @next/next/no-img-element
                          <img
                            src={flagUrl(spotlightMatch.away)}
                            alt={spotlightMatch.away}
                            className="wc-flag"
                          />
                        ) : (
                          <span className="wc-flag-ph">?</span>
                        )}
                      </div>
                      <span className="wc-next-name">{spotlightMatch.away}</span>
                    </div>
                  </div>

                  {!isSpotlightLive ? (
                    <div className="wc-countdown" id="heroCountdown">
                      <div className="cd-unit">
                        <span className="cd-num">{countdown.d}</span>
                        <span className="cd-lab">Days</span>
                      </div>
                      <div className="cd-sep">:</div>
                      <div className="cd-unit">
                        <span className="cd-num">{countdown.h}</span>
                        <span className="cd-lab">Hrs</span>
                      </div>
                      <div className="cd-sep">:</div>
                      <div className="cd-unit">
                        <span className="cd-num">{countdown.m}</span>
                        <span className="cd-lab">Min</span>
                      </div>
                      <div className="cd-sep">:</div>
                      <div className="cd-unit">
                        <span className="cd-num">{countdown.s}</span>
                        <span className="cd-lab">Sec</span>
                      </div>
                    </div>
                  ) : (
                    <Link href="/watch/world-cup-2026" className="wc-hero-watch-btn">
                      Watch Live Stream →
                    </Link>
                  )}

                  <div className="wc-next-meta">
                    {spotlightMatch.stage} · Kick-off{' '}
                    {isSpotlightLive ? 'was' : ''} {bdClock(spotlightMatch.date)} BST ·{' '}
                    {bdTimeLabel(spotlightMatch.date)}
                  </div>
                </div>
              )}
            </div>
          </header>

          {/* Schedule Filters */}
          <div className="wc-filters" id="wcFilters">
            {[
              { id: 'upcoming', label: '⏰ Upcoming' },
              { id: 'all', label: 'All Matches' },
              { id: 'Group Stage', label: 'Group Stage' },
              { id: 'Round of 32', label: 'Round of 32' },
              { id: 'Round of 16', label: 'Round of 16' },
              { id: 'Quarter-final', label: 'Quarter-finals' },
              { id: 'Semi-final', label: 'Semi-finals' },
              { id: 'Final', label: 'Final' },
            ].map((f) => (
              <button
                key={f.id}
                className={`wc-filter ${activeFilter === f.id ? 'active' : ''}`}
                onClick={() => handleFilterClick(f.id)}
              >
                {f.label}
              </button>
            ))}
          </div>

          {/* Schedule List */}
          <div className="wc-list" id="wcList">
            {filteredMatches.map((m) => {
              const target = new Date(m.date).getTime();
              const diff = target - (now || Date.now());
              
              let matchState: 'upcoming' | 'live' | 'finished' = 'upcoming';
              if (diff > 0) {
                matchState = 'upcoming';
              } else if (Math.abs(diff) < MATCH_DURATION_MS) {
                matchState = 'live';
              } else {
                matchState = 'finished';
              }

              // Check if scheduled for today in BD time
              const matchBd = new Date(target + BD_OFFSET_MIN * 60 * 1000);
              const isToday =
                todayYear !== null &&
                matchBd.getUTCFullYear() === todayYear &&
                matchBd.getUTCMonth() === todayMonth &&
                matchBd.getUTCDate() === todayDate;

              const homeFlag = flagUrl(m.home);
              const awayFlag = flagUrl(m.away);

              return (
                <article
                  key={m.id}
                  className={`wc-card is-${matchState}`}
                  data-stage={m.stage}
                  data-group={m.group}
                >
                  <div className="wc-card-body">
                    <div className="wc-teams-matchup">
                      <div className="wc-team wc-team-home">
                        <div className="wc-flag-wrapper">
                          {homeFlag ? (
                            // eslint-disable-next-line @next/next/no-img-element
                            <img src={homeFlag} alt={`${m.home} flag`} className="wc-flag" />
                          ) : (
                            <span className="wc-flag-ph">?</span>
                          )}
                        </div>
                        <span className="wc-team-name">{m.home}</span>
                      </div>

                      <div className="wc-vs-container">
                        <span className="wc-vs-label">VS</span>
                      </div>

                      <div className="wc-team wc-team-away">
                        <div className="wc-flag-wrapper">
                          {awayFlag ? (
                            // eslint-disable-next-line @next/next/no-img-element
                            <img src={awayFlag} alt={`${m.away} flag`} className="wc-flag" />
                          ) : (
                            <span className="wc-flag-ph">?</span>
                          )}
                        </div>
                        <span className="wc-team-name">{m.away}</span>
                      </div>
                    </div>
                  </div>

                  <div className="wc-card-footer">
                    <div className="wc-time-main">
                      <span className="wc-bd-clock">{bdClockHours(m.date)}</span>
                      <span className="wc-bd-tag">{bdClockAmPm(m.date)}</span>
                    </div>

                    <div className="wc-footer-right">
                      {matchState === 'upcoming' && isToday ? (
                        <span className="wc-countdown-mini">
                          ⏱ {formatMini(diff)}
                        </span>
                      ) : matchState === 'live' ? (
                        <Link href="/watch/world-cup-2026" className="wc-watch-link flex">
                          Watch Live →
                        </Link>
                      ) : (
                        <span className="wc-time-date">{bdTimeLabel(m.date)}</span>
                      )}
                    </div>
                  </div>
                </article>
              );
            })}
          </div>
        </div>
      </main>
    </div>
  );
}
