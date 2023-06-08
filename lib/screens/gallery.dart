

import 'package:camera/gallery/adapterDB.dart';
import 'package:camera/gallery/funcrtions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GalleryCamera extends StatefulWidget {
  const GalleryCamera({super.key});

  @override
  State<GalleryCamera> createState() => _GalleryCameraState();
}

class _GalleryCameraState extends State<GalleryCamera> {
  final DBAdapter adapter = HiveService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Uint8List>?>(
        future: _readImagesFromDatabase(),
        builder: (context, AsyncSnapshot<List<Uint8List>?> snapshot) {
          if (snapshot.hasError) {
            return Text("Error appeared ${snapshot.error}");
          }

          if (snapshot.hasData) {
            if (snapshot.data == null) return const Text("Nothing to show");

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 5,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => Image.memory(
                snapshot.data![index],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<List<Uint8List>?> _readImagesFromDatabase() async {
    return await adapter.getImages();
    
  }
  
}
