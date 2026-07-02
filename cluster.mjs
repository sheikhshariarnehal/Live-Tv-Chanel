/**
 * cluster.mjs — Multi-core entrypoint for the Astro SSR server.
 *
 * Forks one worker process per CPU core. If a worker crashes,
 * it is automatically restarted after a 1-second delay.
 *
 * Usage: node cluster.mjs
 * (Replaces: node ./dist/server/entry.mjs)
 */

import cluster from 'node:cluster';
import os from 'node:os';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const NUM_WORKERS = Math.max(1, os.cpus().length);
const WORKER_SCRIPT = path.join(__dirname, 'dist', 'server', 'entry.mjs');

if (cluster.isPrimary) {
  console.log(`[Cluster] Primary PID ${process.pid} — forking ${NUM_WORKERS} workers`);

  for (let i = 0; i < NUM_WORKERS; i++) {
    cluster.fork();
  }

  cluster.on('exit', (worker, code, signal) => {
    const reason = signal || code;
    console.warn(`[Cluster] Worker ${worker.process.pid} died (${reason}). Restarting in 1s…`);
    setTimeout(() => cluster.fork(), 1000);
  });

  cluster.on('online', (worker) => {
    console.log(`[Cluster] Worker ${worker.process.pid} is online`);
  });

  // Graceful shutdown: SIGTERM → drain workers
  process.on('SIGTERM', () => {
    console.log('[Cluster] SIGTERM received — gracefully shutting down workers');
    for (const worker of Object.values(cluster.workers)) {
      worker.process.kill('SIGTERM');
    }
    process.exit(0);
  });

} else {
  // Worker: run the Astro SSR server
  const { handler } = await import(WORKER_SCRIPT);
  console.log(`[Worker ${process.pid}] Started`);
}
