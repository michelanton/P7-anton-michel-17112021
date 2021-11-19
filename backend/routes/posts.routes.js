const express = require("express");
const router = express.Router();
const postCtrl = require("../controllers/posts");
const auth = require('../middleware/auth');
const multer = require('../middleware/multer-config');

// GET tout les posts
router.get('/posts', auth,  postCtrl.allPosts);  
// GET un post
router.get('/posts/:id', auth, postCtrl.postIdCtrl);
// GET tout les posts d'un user
router.get('/posts/user/:id', auth, postCtrl.postUserIdCtrl); 
// POST un post
router.post('/posts', auth, multer, postCtrl.createPost); 
// DELETE un post
router.delete('/posts/:id', auth, postCtrl.supPostCtrl); 
// GET tout les comments d'un user
router.get('/posts/user/comment/:id',  auth, postCtrl.commentUserIdCtrl);
// GET tout les comments
router.get('/comments',  auth, postCtrl.commentAllCtrl);
// DELETE un comment d'un USER
router.delete('/comments/:id', auth, postCtrl.supCommentCtrl);
// GET tout les comments d'un post
router.get('/posts/comments/:id', auth, postCtrl.commentsIdCtrl); 
// GET un user par son id
router.get('/post/comment/:id', auth, postCtrl.commentPostCtrl); 
// DELETE un comment par son id
router.delete('/post/comment/:id', auth, postCtrl.supComment); 
// POST un comment
router.post('/posts/comments/:id', auth, postCtrl.writeCommentCtrl);  


module.exports = router;