import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:theate/presentation/constants/color.dart';

class MovieEdit extends StatelessWidget {
  final String ownerId;
  final String screenId;
  final Map<String, dynamic> screenData;

  const MovieEdit(
      {Key? key,
      required this.ownerId,
      required this.screenId,
      required this.screenData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        title: Text('Edit Movie'),
        backgroundColor: MyColor().primarycolor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('movies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No movies available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var movie = snapshot.data!.docs[index];
              return ListTile(
                title: Text(movie['name'],
                    style: TextStyle(color: MyColor().white)),
                subtitle: Text(movie['language'],
                    style: TextStyle(color: MyColor().gray)),
                leading: Image.network(movie['imageUrl'] ?? '',
                    width: 50, height: 50, fit: BoxFit.cover),
                onTap: () => _updateMovie(movie.id, movie['name']),
              );
            },
          );
        },
      ),
    );
  }

  void _updateMovie(String movieId, String movieName) async {
    try {
      await FirebaseFirestore.instance
          .collection('owners')
          .doc(ownerId)
          .collection('screens')
          .doc(screenId)
          .update({
        'movieId': movieId,
        'movieName': movieName,
      });

      
       Get.back();
      Get.snackbar('Success', 'Movie updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update movie: $e');
    }
  }
}
