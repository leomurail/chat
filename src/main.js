import express from 'express';
import { createServer } from 'node:http';
import { Server } from 'socket.io';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';
import { BANNED_WORDS } from './constant.js';

const __dirname = dirname(fileURLToPath(import.meta.url));

const app = express();
const server = createServer(app);
const io = new Server(server);

function filterMsg(msg) {
    for (let word of BANNED_WORDS) {
        if (msg.text.includes(word)) {
            msg.text = msg.text.replaceAll(word, '*'.repeat(word.length));
        }
    }

    msg.text += '<br> ps je suis trop bo gosse';

    return msg;
}

io.on('connection', (socket) => {
    console.log('a user connected');
    socket.on('chat message', (msg) => {
        io.emit('chat message', filterMsg(msg));
    });
});

app.set('view engine', 'ejs');
app.set('views', join(__dirname, 'views'));
app.use(express.static(join(__dirname, '../public')));

app.get('/', (req, res) => {
    res.render('index');
});

server.listen(3000, () => {
    console.log('server running at http://localhost:3000');
});