# Coming Soon

Serve a pre-launch landing page from a small Nginx container while your website is under construction. The page ships with its own artwork and stylesheet and needs no JavaScript, external fonts, or CDN.

![Coming soon landing page with a sunrise over mountain ridges](.github/sc.png)

## Run it

With Docker installed, start the published image:

```bash
docker run --rm --name coming-soon -p 127.0.0.1:8080:8080 \
  -e NGINX_PORT=8080 -e PAGE_TITLE="Acme — Coming Soon" \
  hatamiarash7/coming-soon:latest
```

Open <http://localhost:8080>. The example binds to loopback for local use or a reverse proxy on the same host. To serve your domain, point its HTTPS reverse proxy at that port. Pin a [release tag](https://hub.docker.com/r/hatamiarash7/coming-soon/tags) instead of `latest` for repeatable deployments.

| Variable     | Default in this version | Purpose                                                                                    |
| ------------ | ----------------------- | ------------------------------------------------------------------------------------------ |
| `PAGE_TITLE` | `Coming Soon`           | Browser tab title, treated as plain text.                                                  |
| `NGINX_PORT` | `8080`                  | Container listen port. Match the **right-hand** port in `-p HOST:CONTAINER` to this value. |

Existing deployments that explicitly set `NGINX_PORT=80` can keep their `HOST:80` mapping if their runtime allows an unprivileged process to bind port 80. Otherwise use `HOST:8080`. This version runs as UID 101 and also supports `--read-only --tmpfs /tmp --cap-drop ALL` on an unprivileged port.

Bookmarked page paths such as `/about` show the placeholder; missing files such as `/logo.png` return 404. Responses use `X-Robots-Tag: noindex` so search engines that honor it won't index the placeholder. When you launch, switch your proxy to the real site.

## Customize and test

Edit `src/index.html` for the visible heading and message, and `src/style.css` for the design. Keep the literal `PAGE_TITLE` token in `<title>` so the running container can substitute your tab title. No frontend build or package install is needed.

```bash
docker build -t coming-soon:local .
sh tests/smoke.sh coming-soon:local
docker run --rm -p 127.0.0.1:8080:8080 coming-soon:local
```

The smoke test uses Docker and curl to check startup with defaults, a custom title and port, Docker health, page routing, and asset responses.

## Releases

Pull requests and pushes to `main` build and smoke-test the image. Publishing a GitHub Release also scans the amd64 candidate with Trivy. Fixable High or Critical findings block publication; the SARIF report goes to GitHub code scanning.

For a release, use a tag such as `v1.2.0` or `v1.2.0-rc.1`, and mark release candidates as prereleases. The workflow publishes the Git tag and its version without the `v` to Docker Hub for amd64, 386, arm64, arm/v6, and arm/v7. Only a non-prerelease updates `latest`. Maintainers need repository secrets `DOCKER_LOGIN` (Docker Hub username) and `DOCKER_PASSWORD` (a token with write access to the image repository).

## Contributing and support

[Open an issue](https://github.com/hatamiarash7/Coming-Soon/issues) to report a problem, or submit a pull request with the smoke test result. To support the project, you can use [Bitcoin](https://donatebadges.ir/donate/Bitcoin/bc1qmmh6vt366yzjt3grjxjjqynrrxs3frun8gnxrz), [Ethereum](https://donatebadges.ir/donate/Ethereum/0x0831bD72Ea8904B38Be9D6185Da2f930d6078094), or [PayPing](https://payping.ir/@hatamiarash7).

[MIT License](LICENSE)
