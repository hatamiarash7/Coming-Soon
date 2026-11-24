# Coming Soon

- Docker copies `src/` directly into the Nginx document root; there is no frontend build. The browser loads particles.js from jsDelivr and its settings from the local `src/particle.json`.
- Keep `PAGE_TITLE` literal in `src/index.html`. At container startup, the Nginx entrypoint expands `config/default.conf.template`; Nginx then replaces the token when serving HTML. This sets the browser tab title, not the visible `<h1>`.
- Set `NGINX_PORT` explicitly and map the host port to that container port. The health check defaults to `80`, but the `listen` directive has no fallback.

## Verify a local change

Build the working tree rather than running the published `:latest` image from the README. There is no automated test suite; `.github/workflows/release.yml` runs only when a release is published.

```sh
docker build -t coming-soon:local .
docker run --rm -p 127.0.0.1:8080:80 -e NGINX_PORT=80 -e PAGE_TITLE='Smoke check' coming-soon:local
```

From another terminal, run `curl -fsS http://127.0.0.1:8080/ | grep -F '<title>Smoke check</title>'`. For asset changes, check the response content as well: `try_files` falls back to `index.html`, so a missing asset can return HTTP 200.
