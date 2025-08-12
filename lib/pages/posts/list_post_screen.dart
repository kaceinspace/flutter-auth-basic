import 'package:flutter/material.dart';
import 'package:xii_rpl_3/models/post_model.dart';
import 'package:xii_rpl_3/services/post_service.dart';
import 'package:xii_rpl_3/pages/posts/detail_posts_screen.dart';
import 'package:xii_rpl_3/pages/posts/create_post_screen.dart';

class ListPostScreen extends StatefulWidget {
  const ListPostScreen({super.key});

  @override
  State<ListPostScreen> createState() => _ListPostScreenState();
}

class _ListPostScreenState extends State<ListPostScreen> {
  late Future<PostModel> _futurePosts;

  @override
  void initState() {
    super.initState();
    _futurePosts = PostService.listPosts();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _refreshPosts() {
    setState(() {
      _futurePosts = PostService.listPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Icon(Icons.article, color: Colors.white, size: 24.0),
            ),
            const SizedBox(width: 12.0),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'My Posts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Manage your content',
                  style: TextStyle(color: Colors.white70, fontSize: 12.0),
                ),
              ],
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurple.shade600,
                Colors.deepPurple.shade800,
                Colors.indigo.shade800,
              ],
            ),
          ),
        ),
        elevation: 8,
        shadowColor: Colors.deepPurple.withOpacity(0.3),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: IconButton(
              onPressed: _refreshPosts,
              icon: const Icon(Icons.refresh, color: Colors.white),
              tooltip: 'Refresh Posts',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatePostScreen(),
                  ),
                );

                if (result == true) {
                  // Post was created successfully, refresh the list
                  _refreshPosts();
                }
              },
              icon: Icon(Icons.add, color: Colors.deepPurple.shade700),
              tooltip: 'Add New Post',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade50, Colors.white],
          ),
        ),
        child: FutureBuilder<PostModel>(
          future: _futurePosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading posts...',
                      style: TextStyle(
                        color: Colors.deepPurple.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _refreshPosts,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade600,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            final posts = snapshot.data!.data ?? [];

            if (posts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 80,
                      color: Colors.deepPurple.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Posts Yet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start creating your first post!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.deepPurple.shade400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreatePostScreen(),
                          ),
                        );

                        if (result == true) {
                          _refreshPosts();
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create First Post'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _refreshPosts();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailScreen(post: post),
                          ),
                        );

                        if (result == true) {
                          // Post was updated or deleted, refresh the list
                          _refreshPosts();
                        }
                      },
                      borderRadius: BorderRadius.circular(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with title and ID
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              16.0,
                              16.0,
                              16.0,
                              8.0,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    post.title ?? 'No Title',
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Text(
                                    '#${post.id}',
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Photo if available
                          if (post.foto != null && post.foto!.isNotEmpty)
                            Container(
                              width: double.infinity,
                              height: 200,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.grey.shade200,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  'http://127.0.0.1:8000/storage/${post.foto!}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          height: 200,
                                          color: Colors.grey.shade200,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 200,
                                      color: Colors.grey.shade200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.broken_image,
                                            size: 48,
                                            color: Colors.grey.shade400,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Failed to load image',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                          // Content
                          if (post.content != null && post.content!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                16.0,
                                12.0,
                                16.0,
                                8.0,
                              ),
                              child: Text(
                                post.content!,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black87,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                          // Details row
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              16.0,
                              8.0,
                              16.0,
                              16.0,
                            ),
                            child: Row(
                              children: [
                                // Status badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (post.status == 1)
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Text(
                                    (post.status == 1) ? 'Published' : 'Draft',
                                    style: TextStyle(
                                      color: (post.status == 1)
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                // Created date
                                if (post.createdAt != null)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14.0,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        _formatDate(post.createdAt!),
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
