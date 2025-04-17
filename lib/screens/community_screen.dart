import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController _postController = TextEditingController();
  final CollectionReference _postsCollection =
      FirebaseFirestore.instance.collection('community_posts');

  void _addPost(String text) async {
    await _postsCollection.add({
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'reactions': {
        'I feel you': 0,
        'You’re not alone': 0,
        'Stay strong': 0,
      },
    });
    _postController.clear();
  }

  void _addReaction(String postId, String reaction) async {
    final postRef = _postsCollection.doc(postId);
    await postRef.update({
      'reactions.$reaction': FieldValue.increment(1),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anonymous Community'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _postController,
              decoration: InputDecoration(
                labelText: "Share how you're feeling...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_postController.text.isNotEmpty) {
                _addPost(_postController.text);
              }
            },
            child: Text('Post'),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _postsCollection
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No posts yet.'));
                }
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['text'],
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:
                                  (data['reactions'] as Map<String, dynamic>)
                                      .keys
                                      .map((reaction) {
                                return GestureDetector(
                                  onTap: () => _addReaction(doc.id, reaction),
                                  child: Column(
                                    children: [
                                      Icon(Icons.favorite,
                                          color: Colors.red, size: 20),
                                      Text(
                                          '$reaction (${data['reactions'][reaction]})'),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
