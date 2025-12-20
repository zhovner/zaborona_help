#!/usr/bin/env python3

from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
import ssl
import os

HOST = "0.0.0.0"
PORT = 8443

FILES_DIR = "/root"

ALLOWED_FILES = {
    "mikrotik-add-ranges.txt",
    "keenetic-add-ranges-cli.txt",
    "keenetic-add-ranges-web.txt",
}

# Токен авторизации
API_TOKEN = "CHANGE_ME_SUPER_SECRET_TOKEN"

CERT_FILE = "/root/sslweb/server.crt"
KEY_FILE  = "/root/sslweb/server.key"


class FileServer(BaseHTTPRequestHandler):

    def _unauthorized(self):
        self.send_response(401)
        self.end_headers()
        self.wfile.write(b"Unauthorized")

    def do_GET(self):
        # ---- Проверка токена ----
        token = self.headers.get("X-Auth-Token")

        if token != API_TOKEN:
            self._unauthorized()
            return

        parsed = urlparse(self.path)
        params = parse_qs(parsed.query)

        if "file" not in params:
            self.send_error(400, "Parameter 'file' is required")
            return

        filename = params["file"][0]

        if filename not in ALLOWED_FILES:
            self.send_error(403, "File not allowed")
            return

        filepath = os.path.join(FILES_DIR, filename)

        if not os.path.isfile(filepath):
            self.send_error(404, "File not found")
            return

        with open(filepath, "rb") as f:
            data = f.read()

        self.send_response(200)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Disposition", f'attachment; filename="{filename}"')
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)


def main():
    httpd = HTTPServer((HOST, PORT), FileServer)

    context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    context.load_cert_chain(certfile=CERT_FILE, keyfile=KEY_FILE)

    httpd.socket = context.wrap_socket(httpd.socket, server_side=True)

    print(f"HTTPS server started on https://{HOST}:{PORT}")
    httpd.serve_forever()


if __name__ == "__main__":
    main()
