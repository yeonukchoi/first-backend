const express = require('express');
const mongoose = require('mongoose');

const app = express();
const Post = require('./models/post');

app.use(express.json());

//데이터 베이스 연결
mongoose.connect('mongodb://localhost:27017/boardApp', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
}).then(() => {
    console.log('MongoDB 연결 성공');
}).catch((err) => {
    console.error('MongoDB 연결 실패', err);
});

//게시판 목록 조회
app.get('/posts', async (req, res) => {
    try {
        const posts = await Post.find();
        res.json(posts);
        //console.log(posts);
    }
    catch (err) {
        console.error('Error fetching posts:', err);
        res.status(500).json({ message: '게시글 목록 조회 실패', error: err.message });
    }
});

//게시판 글 작성
app.post('/posts', async (req, res) => {
    const {title, content} = req.body;

    try {
        const newPost = await Post.create({ 
            title,
            content,
            createdAt: new Date(),
        });
        //console.log(newPost);
        res.status(201).json(newPost);
    }

    catch (err) {
        res.status(500).json({ message: '저장 실패', error: err});
    }
});

//게시글 수정 기능
app.put('/posts/:id', async (req, res) => {
    const {id} = req.params;
    const {title, content} = req.body;

    try {
        const updatedPost = await Post.findByIdAndUpdate(
            id,
            {title, content},
            {new: true}
        );

        if (!updatedPost) {
            return res.status(404).json({ message: '게시글을 찾을 수 없습니다.'});
        }

        res.json(updatedPost);
    }
   catch (err) {
    res.status(500).json({ message: '게시글 수정 실패', error: err});
   }
});

//게시글 삭제 기능
app.delete('/posts/:id', async (req, res) => {
    const {id} = req.params;

    try {
        const deletePost = await Post.findByIdAndDelete(id);

        if(!deletePost) {
            return res.status(404).json({ message: '게시글을 찾을 수 없습니다.'});
        }

        res.json({ message: '삭제 완료', deletePost});
    }
    catch (err) {
        res.status(500).json({ message: '삭제 실패', error: err});
    }
});



app.listen(3000, () => {
    console.log('서버가 3000번 포트에서 실행중입니다.');
});