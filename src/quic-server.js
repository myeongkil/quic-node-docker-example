const { createQuicSocket } = require('net');
const fs = require('fs');

const key  = fs.readFileSync('./ssl_certs/server.key');
const cert = fs.readFileSync('./ssl_certs/server.crt');
const port = process.env.PORT || 1234;
const server = createQuicSocket({ endpoint: { port: port } });

server.listen({ key, cert, alpn: 'hello' });

server.on('session', (session) => {
  session.on('stream', (stream) => {
    if (stream.bidirectional) {
      stream.write('Hello Client!');
    }
    stream.on('data', (data) => {
      let message = data.toString()
      console.log("[CLIENT] ▶️ " + message);
    });
  });
});

server.on('listening', () => {
  console.log(`⭐️ The socket is listening for sessions, on port ${port}`);
});