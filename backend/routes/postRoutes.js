const express = require('express');
const router = express.Router();
const {
    getAllPosts,
    createPost,
    getPostById,
    updatePost,
    deletePost,
} = require('../controllers/postController');

const { protect } = require('../middleware/authMiddleware');

router.route('/').get(getAllPosts).post(protect, createPost);
router.route('/:id').get(getPostById).put(protect, updatePost).delete(protect, deletePost);

module.exports = router;
