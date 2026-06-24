import { useState, useEffect } from 'react';

export function useHydratedStore<T, U>(
  store: (selector: (state: T) => U) => U,
  selector: (state: T) => U
): U | undefined {
  const [hydrated, setHydrated] = useState(false);
  const result = store(selector);

  useEffect(() => {
    setHydrated(true);
  }, []);

  return hydrated ? result : undefined;
}
