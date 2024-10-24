import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_soffee/pages/snap.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  FeedPage({Key? key}) : super(key: key) {
    _stream = _reference.orderBy('timestamp', descending: true).snapshots();
  }

  CollectionReference _reference =
  FirebaseFirestore.instance.collection('coffee_feed');

  late Stream<QuerySnapshot> _stream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coffee Feed"),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const SnapPage()));
            },
            child: const Icon(Icons.send_rounded)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Some error occurred ${snapshot.error}'),
            );
          }

          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;
            print('Number of documents: ${documents.length}');

            List<Map> items = documents.map((e) => e.data() as Map).toList();

            if (items.isEmpty) {
              return const Center(child: Text("No posts available"));
            }

            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  // Get the item at this index
                  Map thisItem = items[index];
                  // Return the widget for the list items
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Post header (profile image and username)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(
                                  'assets/images/profile.jpeg'), // Replace with actual image
                            ),
                            SizedBox(width: 10),
                            Text(
                              'CoffeeLover123', // Username
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Icon(Icons.more_vert),
                          ],
                        ),
                      ),

                      // Coffee post image
                      Container(
                        height: 300, // Set the height of the post image
                        child: thisItem.containsKey('image')
                            ? Image.network('${thisItem['image']}')
                            : Container(),
                      ),

                      // Post actions (like, comment, share)
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.favorite_border),
                            SizedBox(width: 16),
                            Icon(Icons.comment_outlined),
                            SizedBox(width: 16),
                            Icon(Icons.send),
                            Spacer(),
                            Icon(Icons.bookmark_border),
                          ],
                        ),
                      ),

                      // Post likes and caption
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Liked by CoffeeFan and 124 others', // Likes text
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'CoffeeLover123 ',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                    'Enjoying this amazing coffee at my favorite spot!',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'View all 20 comments', // Comments text
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '2 hours ago', // Timestamp
                              style:
                              TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
