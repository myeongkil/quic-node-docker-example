const { createQuicSocket } = require('net');
const fs = require('fs');

const key  = fs.readFileSync('./ssl_certs/server.key');
const cert = fs.readFileSync('./ssl_certs/server.crt');
const csr   = fs.readFileSync('./ssl_certs/server.csr');
const port = process.env.PORT || 1234;

const socket = createQuicSocket({
  client: {
    key,
    cert,
    csr,
    requestCert: true,
    alpn: 'hello',
    servername: 'node-quic-server'
  }
});

const req = socket.connect({
  address: 'node-quic-server',
  port,
});

req.on('secure', () => {
  const stream = req.openStream();
  // stdin -> stream
  process.stdin.pipe(stream);
  stream.on('data', (chunk) => console.log('client(on-secure): ', chunk.toString()));
  stream.on('end', () => console.log('client(on-secure): end'));
  stream.on('close', () => {
    // Graceful shutdown
    socket.close();
  });
  stream.on('error', (err) => console.error(err));
});