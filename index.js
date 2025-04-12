const express = require('express');
const mongoose = require('mongoose');

const app = express();
const post = require('./models/post');


const posts = [];
let id = 1;

app.use(express.json());

//데이터 베이스 연결
mongoose.connect('mongodb://localost:27017/boardApp', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
}).then(() => {
    console.log('MongoDB 연결 성공');
}).catch((err) => {
    console.error('MongoDB 연결 실패', err);
});

app.get('/', (req, res) => {
    res.send('게시판 실행중');
});

//게시판 목록 조회
app.get('/posts', (req, res) => {
    res.json(posts);
});

//게시판 글 작성
app.post('/posts', (req, res) => {
    const {title, content} = req.body;
    const newPost = {id: id++, title, content, createdAt: new Date()};
    posts.push(newPost);
    res.status(201).json(newPost);
});

//게시글 수정 기능
app.put('/posts/:id', (req, res) => {
    const post = posts.find(p => p.id === parseInt(req.params.id));
    if(!post) return res.status(404).json({ message: '게시글 없음' });
    post.title = req.body.title;
    post.content = req.body.content;
    res.json(post);
});

//게시글 삭제 기능
app.delete('/posts/:id', (req, res) => {
    const postIndex = posts.findIndex(p => p.id == parseInt(req.params.id));
    if(postIndex === -1) return res.status(404).json({message: '게시글 없음'});

    posts.slice(postIndex, 1);
    res.json({message: '삭제 완료'});
});



app.listen(3000, () => {
    console.log('서버가 3000번 포트에서 실행중입니다.');
});