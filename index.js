const express = require('express');
const app = express();

const posts = [];
let id = 1;

app.use(express.json());

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
    if(!post) return res.status(404).json(post);
    post.title = req.body.title;
    post.content = req.body.content;
    res.json(post);
});



app.listen(3000, () => {
    console.log('서버가 3000번 포트에서 실행중입니다.');
});