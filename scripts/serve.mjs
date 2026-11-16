import http from 'node:http';
import fs from 'node:fs/promises';
import path from 'node:path';
const root = path.resolve('build/web');
const mime = {'.html':'text/html', '.js':'text/javascript', '.json':'application/json',
  '.wasm':'application/wasm', '.png':'image/png', '.ttf':'font/ttf', '.otf':'font/otf'};
const server = http.createServer(async (req, res) => {
  try {
    const url = new URL(req.url, 'http://127.0.0.1');
    const file = path.resolve(root, '.' + decodeURIComponent(url.pathname === '/' ? '/index.html' : url.pathname));
    if (!file.startsWith(root + path.sep)) {res.writeHead(403).end(); return;}
    const body = await fs.readFile(file);
    res.writeHead(200, {'Content-Type':mime[path.extname(file)] ?? 'application/octet-stream', 'Cache-Control':'no-cache'});
    res.end(body);
  } catch { res.writeHead(404).end('Bulunamadı'); }
});
server.listen(8080, '127.0.0.1', () => console.log('Mini Katalog: http://127.0.0.1:8080'));
