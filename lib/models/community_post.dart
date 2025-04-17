class CommunityPost {
  final String id; // Unique identifier (Firebase document ID)
  final String content; // The post content
  final DateTime timestamp;
  final Map<String, int>
      reactions; // Reactions like "I feel you", "You’re not alone"

  CommunityPost({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.reactions,
  });

  // Converts Firestore document to CommunityPost object
  factory CommunityPost.fromFirestore(String id, Map<String, dynamic> data) {
    return CommunityPost(
      id: id,
      content: data['text'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      reactions: Map<String, int>.from(data['reactions']),
    );
  }

  // Converts CommunityPost object to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'text': content,
      'timestamp': timestamp,
      'reactions': reactions,
    };
  }
}
