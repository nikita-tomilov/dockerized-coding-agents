from mitmproxy import http
import fnmatch

ALLOWED_DOMAINS = [
    "*.anthropic.com",
    "anthropic.com",
]

def is_allowed(host: str) -> bool:
    return any(fnmatch.fnmatch(host, pattern) for pattern in ALLOWED_DOMAINS)

def http_connect(flow: http.HTTPFlow) -> None:
    # Handles the CONNECT method for HTTPS tunneling
    host = flow.request.host
    if not is_allowed(host):
        flow.response = http.Response.make(
            403, b"Blocked by proxy allowlist", {"Content-Type": "text/plain"}
        )
        flow.kill()

def request(flow: http.HTTPFlow) -> None:
    # Handles plain HTTP requests (and HTTPS after CONNECT tunnel is set up)
    host = flow.request.pretty_host
    if not is_allowed(host):
        flow.response = http.Response.make(
            403, b"Blocked by proxy allowlist: " + host.encode(), {"Content-Type": "text/plain"}
        )