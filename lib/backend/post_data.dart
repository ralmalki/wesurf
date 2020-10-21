import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  PostData({this.postUID});
  final String postUID;

  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  Future<String> createPost(String userUID, String locationUID, String content, String imageURL, String mood) async {
    //record the current time as post uid to link with location
    //also can be used to record time later on
    String timestamp = DateTime.now().toString();
    String postUID = userUID + timestamp;
    await postCollection.doc(postUID).set({
      'userUID' : userUID,
      'locationUID' : locationUID,
      'content' : content,
      'image' : imageURL,
      'mood' : mood,
      'timestamp' : timestamp
    });
    return postUID;
  }

  Future getPostOwner() async {
    // return await postCollection.doc()
  }

}