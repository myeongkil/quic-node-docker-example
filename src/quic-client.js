const { createQuicSocket } = require('net');
const fs = require('fs');

const key  = fs.readFileSync('./ssl_certs/server.key');
const cert = fs.readFileSync('./ssl_certs/server.crt');
const ca   = fs.readFileSync('./ssl_certs/server.csr');
const port = process.env.PORT || 1234;
const servername = 'node-quic-example'

const socket = createQuicSocket({
  client: {
    key,
    cert,
    ca,
    requestCert: true,
    alpn: 'hello',
    servername: servername
  }
});

(async function() {
    console.log(`⭐️ The socket is connected with session : ${servername}:${port}`);
    const client = await socket.connect({
        address: servername,
        port: port,
    });
    client.on('secure', async () => {
        const str = await client.openStream();
        process.stdin.pipe(str);
        str.on('data', (result) => {
            console.log(`[SERVER] ▶️ ${result.toString()}`);
        });
        str.on('close', () => {
            console.log('timeout - socket.close()');
            socket.close();
        });
    });
})();