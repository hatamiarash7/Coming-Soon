#!/bin/sh
set -eu

image=${1:-coming-soon:local}
container=''
cleanup() {
	if [ -n "$container" ]; then docker rm -f "$container" >/dev/null; fi
}
trap cleanup EXIT

start() {
	port=$1
	shift
	container=$(docker run -d --read-only --tmpfs /tmp --cap-drop ALL \
		--health-interval=1s -p "127.0.0.1::$port" "$@" "$image")
	origin="http://$(docker port "$container" "$port/tcp")"
	for _ in $(seq 1 20); do
		if [ "$(docker inspect -f '{{.State.Health.Status}}' "$container")" = healthy ]; then return; fi
		sleep 1
	done
	docker logs "$container" >&2
	exit 1
}

start 8080
test "$(docker exec "$container" id -u)" != 0
curl -fsS "$origin/" | grep -F '<title>Coming Soon</title>'
curl -fsSI "$origin/style.css" | grep -i '^Content-Type: text/css'
curl -fsSI "$origin/horizon.svg" | grep -i '^Content-Type: image/svg+xml'
test "$(curl -sS -o /dev/null -w '%{http_code}' "$origin/missing.css")" = 404
cleanup

start 8888 -e NGINX_PORT=8888 -e "PAGE_TITLE=Sam's \"R&D\" <Preview> / \$site"
curl -fsS "$origin/previous/page" | grep -F '<title>Sam&#39;s &quot;R&amp;D&quot; &lt;Preview&gt; / &#36;site</title>'

if docker run --rm -e NGINX_PORT=65536 "$image" nginx -t; then
	echo 'Expected startup to reject an out-of-range port' >&2
	exit 1
fi
