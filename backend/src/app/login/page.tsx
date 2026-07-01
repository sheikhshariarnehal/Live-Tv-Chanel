'use client';

import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '../../providers/auth-provider';
import { Shield, Key } from 'lucide-react';

export default function LoginPage() {
  const { login, isAuthenticated, isLoading } = useAuth();
  const router = useRouter();
  const [loginPassword, setLoginPassword] = useState('');
  const [loginError, setLoginError] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Redirect to dashboard if already authenticated
  useEffect(() => {
    if (!isLoading && isAuthenticated) {
      router.replace('/dashboard/overview');
    }
  }, [isLoading, isAuthenticated, router]);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoginError(null);
    setIsSubmitting(true);

    const result = await login(loginPassword);

    if (result.success) {
      router.replace('/dashboard/overview');
    } else {
      setLoginError(result.error || 'Login failed');
    }

    setIsSubmitting(false);
  };

  // Don't flash login form if session is being restored
  if (isLoading) {
    return (
      <main className="min-h-screen bg-zinc-950 flex items-center justify-center">
        <div className="w-8 h-8 border-2 border-purple-500 border-t-transparent rounded-full animate-spin"></div>
      </main>
    );
  }

  // Don't render login if already authenticated (redirect will happen)
  if (isAuthenticated) return null;

  return (
    <main className="min-h-screen bg-zinc-950 flex flex-col items-center justify-center p-4 relative overflow-hidden">
      {/* Abstract Glowing shapes */}
      <div className="absolute top-1/4 left-1/4 w-80 h-80 bg-purple-500/10 rounded-full blur-3xl"></div>
      <div className="absolute bottom-1/4 right-1/4 w-80 h-80 bg-pink-500/10 rounded-full blur-3xl"></div>

      <div className="w-full max-w-md p-8 rounded-2xl glass-panel relative z-10 space-y-6">
        <div className="text-center space-y-2">
          <div className="mx-auto w-12 h-12 rounded-xl bg-purple-500/10 border border-purple-500/30 flex items-center justify-center text-purple-400">
            <Shield className="w-6 h-6 animate-pulse" />
          </div>
          <h1 className="text-2xl font-bold tracking-tight text-white">GoPlay TV Admin</h1>
          <p className="text-sm text-zinc-400">Please enter administrative secret to continue</p>
        </div>

        <form onSubmit={handleLogin} className="space-y-4">
          <div className="space-y-1">
            <label className="text-xs font-semibold text-zinc-400 flex items-center gap-1.5">
              <Key className="w-3.5 h-3.5 text-purple-400" />
              Access Secret
            </label>
            <input
              type="password"
              placeholder="••••••••••••••••"
              value={loginPassword}
              onChange={(e) => setLoginPassword(e.target.value)}
              className="w-full p-3 rounded-xl glass-input text-sm text-center font-mono tracking-widest"
              required
            />
          </div>

          {loginError && (
            <div className="text-xs text-red-400 bg-red-950/20 border border-red-900/50 p-3 rounded-xl text-center">
              ⚠️ {loginError}
            </div>
          )}

          <button
            type="submit"
            disabled={isSubmitting}
            className="w-full py-3 bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-700 hover:to-indigo-700 disabled:opacity-50 disabled:cursor-not-allowed text-white rounded-xl text-sm font-semibold transition-all duration-200 shadow-lg shadow-purple-500/20 hover:scale-[1.01]"
          >
            {isSubmitting ? 'Authenticating...' : 'Sign In'}
          </button>
        </form>

        <div className="text-center border-t border-zinc-800/80 pt-4">
          <span className="text-[10px] text-zinc-500 font-mono">v1.0.0 • GoPlay Next.js Dashboard</span>
        </div>
      </div>
    </main>
  );
}
