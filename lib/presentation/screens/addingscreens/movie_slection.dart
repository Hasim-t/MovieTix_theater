import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:theate/presentation/constants/color.dart';

import 'package:get/get.dart';
import 'package:theate/presentation/screens/addingscreens/date_time_set.dart';


class MovieSelectionScreen extends StatelessWidget {
  final int rows;
  final int columns;
  final String audiName;
  final String screenId; 
  final String ownerId;
  

  const MovieSelectionScreen({
    super.key, 
    required this.rows, 
    required this.columns, 
    required this.audiName, required this.screenId, required this.ownerId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        title: Text('Select Movie', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: MyColor().primarycolor,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('movies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: MyColor().primarycolor));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: MyColor().white)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No movies available', style: TextStyle(color: MyColor().white)));
          }

          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var movie = snapshot.data!.docs[index];
              return GestureDetector(
        onTap: () {
    Get.to(() => DateTimeSet(
      movieName: movie['name'],
      movieId: movie.id,
      rows: rows,
      columns: columns,
      audiName: audiName,
      screenId: screenId,
      ownerId: ownerId,   // Add this line, you need to get the screenId from somewhere
    ));
  },
                child: Container(
                  decoration: BoxDecoration(
                    color: MyColor().darkblue.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          movie['imageUrl'] ?? '',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              color: Colors.grey,
                              child: Icon(Icons.error, color: Colors.white),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie['name'],
                              style: TextStyle(
                                color: MyColor().white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              movie['language'],
                              style: TextStyle(color: MyColor().gray, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}