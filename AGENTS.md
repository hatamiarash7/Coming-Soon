# Coming Soon

- Keep `src/` self-contained; Docker serves it directly, without a frontend build. Use root-relative asset URLs so the page also works on nested paths.
- Keep the `PAGE_TITLE` token literal in `src/index.html`. The entrypoint escapes the configured title for Nginx and HTML before `sub_filter` replaces the token. It changes the browser tab title, not the visible heading.
- Verify the working tree with `docker build -t coming-soon:local .` and `sh tests/smoke.sh coming-soon:local`. Use the locally built image when refreshing `.github/sc.png`.
