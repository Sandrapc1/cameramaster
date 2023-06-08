import 'dart:typed_data';

import 'package:camera/gallery/adapterDB.dart';
import 'package:hive/hive.dart';


class HiveService extends DBAdapter {
  @override
  Future<List<Uint8List>> getImages() async {
    var box = await Hive.openBox('imageBox');

    List<dynamic>? result = box.get('images');

    return result!.cast<Uint8List>();
  }

  @override
  Future<void> storeImage(Uint8List imageBytes) async {
    List<Uint8List> images = [];

    // Open the box
    var box = await Hive.openBox('imageBox');

    List<dynamic>? allImages = box.get('images');

    if (allImages != null) {
      images.addAll(allImages.cast<Uint8List>());
    }

    images.add(imageBytes);
    box.put("images", images);
  }
}
