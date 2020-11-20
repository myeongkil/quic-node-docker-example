const { createQuicSocket } = require('net');
const fs = require('fs');

const key  = fs.readFileSync('./ssl_certs/server.key');
const cert = fs.readFileSync('./ssl_certs/server.crt');
const port = process.env.PORT || 1234;

const server = createQuicSocket({ endpoint: { port } });
server.listen({ key, cert, alpn: 'hello' });

server.on('session', (session) => {
  session.on('stream', (stream) => {
    stream.pipe(stream);
  });
});

server.on('listening', () => {
  console.log(`listening on ${port}...`);
  console.log('input something!');
});