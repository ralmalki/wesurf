import 'package:cloud_firestore/cloud_firestore.dart';

class CommentData {
  CommentData({this.commentUID});
  final String commentUID;

  final CollectionReference commentCollection =
      FirebaseFirestore.instance.collection('comments');

  Future<String> createComment(
      String userUID, String postUID, String content) async {
    String timestamp = DateTime.now().toString();
    String commentUID = postUID + timestamp;
    await commentCollection.doc(commentUID).set({
      'userUID': userUID,
      'postUID': postUID,
      'content': content,
      'timestamp': timestamp
    });
    return commentUID;
  }
}