'use client';

export function SidebarSkeleton() {
  return (
    <div className="sidebar" style={{ display: 'flex', flexDirection: 'column', height: '100%' }}>
      {/* Category Tabs Skeleton */}
      <div className="category-tabs" style={{ gap: '0.5rem', overflow: 'hidden' }}>
        {Array.from({ length: 5 }).map((_, i) => (
          <div
            key={i}
            className="animate-pulse bg-neutral-800 rounded-lg"
            style={{ width: '80px', height: '36px', flexShrink: 0 }}
          />
        ))}
      </div>
      {/* Channel Grid Skeleton */}
      <div className="channel-grid mt-4" style={{ flex: 1, overflow: 'hidden', padding: '1rem' }}>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '0.75rem' }}>
          {Array.from({ length: 8 }).map((_, i) => (
            <div
              key={i}
              className="animate-pulse bg-neutral-800 rounded-xl"
              style={{ width: '100%', aspectRatio: '16/9' }}
            />
          ))}
        </div>
      </div>
    </div>
  );
}

export function ChannelGridSkeleton() {
  return (
    <div className="portal-channel-grid">
      {Array.from({ length: 12 }).map((_, i) => (
        <div
          key={i}
          className="portal-channel-card border-direct animate-pulse"
          style={{ height: '140px' }}
        >
          <div className="card-logo-container bg-neutral-800" style={{ flex: 1 }} />
          <div className="card-details bg-neutral-900" style={{ height: '40px' }} />
        </div>
      ))}
    </div>
  );
}

export function ScheduleSkeleton() {
  return (
    <div className="wc-list mt-8">
      {Array.from({ length: 6 }).map((_, i) => (
        <div
          key={i}
          className="wc-card animate-pulse bg-neutral-900 border border-neutral-800 rounded-xl p-4 flex flex-col justify-between"
          style={{ height: '140px' }}
        >
          <div className="flex justify-between items-center w-full">
            <div className="h-4 w-24 bg-neutral-800 rounded" />
            <div className="h-4 w-12 bg-neutral-800 rounded" />
          </div>
          <div className="flex justify-between items-center w-full mt-4">
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 rounded-full bg-neutral-800" />
              <div className="h-4 w-20 bg-neutral-800 rounded" />
            </div>
            <div className="text-neutral-700 font-bold">VS</div>
            <div className="flex items-center gap-2">
              <div className="h-4 w-20 bg-neutral-800 rounded" />
              <div className="w-8 h-8 rounded-full bg-neutral-800" />
            </div>
          </div>
          <div className="h-3 w-32 bg-neutral-800 rounded mt-4" />
        </div>
      ))}
    </div>
  );
}
