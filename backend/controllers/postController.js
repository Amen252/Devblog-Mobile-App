const Post = require('../models/Post');
const User = require('../models/User');

// @desc    Get all posts
// @route   GET /api/posts
// @access  Public
const getAllPosts = async (req, res) => {
    try {
        const page = Math.max(1, parseInt(req.query.page) || 1);
        const limit = Math.max(1, parseInt(req.query.limit) || 10); // Set a reasonable default
        const skip = (page - 1) * limit;

        console.log(`Fetching posts - Page: ${page}, Limit: ${limit}, Skip: ${skip}`);

        const posts = await Post.find()
            .populate('author', 'name email')
            .sort({ createdAt: -1 })
            .skip(skip)
            .limit(limit);

        const total = await Post.countDocuments();

        console.log(`Found ${posts.length} posts. Total posts in DB: ${total}`);

        res.status(200).json({
            posts,
            total,
            pages: Math.ceil(total / limit),
            currentPage: page
        });
    } catch (error) {
        console.error('Error in getAllPosts:', error);
        res.status(500).json({ message: error.message });
    }
};

// @desc    Create a post
// @route   POST /api/posts
// @access  Private
const createPost = async (req, res) => {
    if (!req.body.title || !req.body.content) {
        return res.status(400).json({ message: 'Please provide title and content' });
    }

    try {
        console.log('--- CREATE POST ---');
        console.log('Req User:', req.user._id);

        const post = await Post.create({
            title: req.body.title,
            content: req.body.content,
            author: req.user._id,
            category: req.body.category,
        });
        console.log('Post Created with Author:', post.author);
        res.status(201).json(post);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @desc    Get single post
// @route   GET /api/posts/:id
// @access  Public
const getPostById = async (req, res) => {
    try {
        const post = await Post.findById(req.params.id).populate('author', 'name email');
        if (!post) {
            return res.status(404).json({ message: 'Post not found' });
        }
        res.status(200).json(post);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @desc    Update post
// @route   PUT /api/posts/:id
// @access  Private
const updatePost = async (req, res) => {
    try {
        const post = await Post.findById(req.params.id);
        if (!post) {
            return res.status(404).json({ message: 'Post not found' });
        }

        // Check for user
        if (!req.user) {
            return res.status(401).json({ message: 'User not found' });
        }

        // Make sure the logged in user matches the post author
        if (post.author.toString() !== req.user._id.toString()) {
            return res.status(401).json({ message: 'User not authorized to update this post' });
        }

        const updatedPost = await Post.findByIdAndUpdate(req.params.id, req.body, {
            new: true,
        });
        res.status(200).json(updatedPost);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @desc    Delete post
// @route   DELETE /api/posts/:id
// @access  Private
const deletePost = async (req, res) => {
    try {
        const post = await Post.findById(req.params.id);
        if (!post) {
            return res.status(404).json({ message: 'Post not found' });
        }

        // Check for user
        if (!req.user) {
            return res.status(401).json({ message: 'User not found' });
        }

        // Make sure the logged in user matches the post author
        console.log('--- DELETE AUTHORIZATION CHECK ---');
        console.log('Post ID:', post._id);
        console.log('Post Author (type):', typeof post.author, post.author);
        console.log('Req User ID (type):', typeof req.user._id, req.user._id);

        const postAuthorStr = post.author.toString();
        const reqUserIdStr = req.user._id.toString();

        console.log('Post Author Str:', postAuthorStr);
        console.log('Req User ID Str:', reqUserIdStr);
        console.log('Match?', postAuthorStr === reqUserIdStr);

        if (postAuthorStr !== reqUserIdStr) {
            return res.status(401).json({ message: 'User not authorized to delete this post' });
        }

        await post.deleteOne();
        res.status(200).json({ id: req.params.id });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = {
    getAllPosts,
    createPost,
    getPostById,
    updatePost,
    deletePost,
};
