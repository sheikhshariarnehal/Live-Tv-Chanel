module.exports = {
  apps: [
    {
      name: 'live-tv',
      script: 'node_modules/serve/bin/serve.js',
      args: 'dist -l 3000',
      exec_mode: 'fork',
      instances: 1,
      autorestart: true,
      watch: false,
      max_restarts: 10,
      restart_delay: 5000,
      env: {
        NODE_ENV: 'production'
      }
    }
  ]
};
