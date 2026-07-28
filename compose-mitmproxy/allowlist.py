from mitmproxy import http, ctx
import fnmatch

ALLOWED_DOMAINS = [
    "host.docker.internal",
    "*.anthropic.com",
    "anthropic.com",
    "platform.claude.com",
    "openai.com",
    "*.openai.com",
    "chatgpt.com",
    "*.chatgpt.com"
]

def is_allowed(host: str) -> bool:
    return any(fnmatch.fnmatch(host, pattern) for pattern in ALLOWED_DOMAINS)

def http_connect(flow: http.HTTPFlow) -> None:
    host = flow.request.host
    if is_allowed(host):
        ctx.log.info(f"[ALLOW][CONNECT] {host}")
    else:
        ctx.log.warn(f"[BLOCK][CONNECT] {host}")
        flow.response = http.Response.make(
            403, b"Blocked by proxy allowlist", {"Content-Type": "text/plain"}
        )
        flow.kill()

def request(flow: http.HTTPFlow) -> None:
    host = flow.request.pretty_host
    if is_allowed(host):
        ctx.log.info(f"[ALLOW][REQUEST] {flow.request.method} {host}{flow.request.path}")
    else:
        ctx.log.warn(f"[BLOCK][REQUEST] {flow.request.method} {host}{flow.request.path}")
        flow.response = http.Response.make(
            403, b"Blocked by proxy allowlist: " + host.encode(), {"Content-Type": "text/plain"}
        )