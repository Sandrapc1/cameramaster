
import 'dart:io';

import 'package:camera/gallery/adapterDB.dart';
import 'package:camera/gallery/funcrtions.dart';
import 'package:camera/screens/gallery.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


  void main() async {
  await Hive.initFlutter();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  File? Imagefile;
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gallery',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(
        title: 'gallery',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DBAdapter adapter = HiveService();
  int _selectedIndex = 0;
  static TextStyle optionStyle = const TextStyle(fontSize: 20);
  // ignore: prefer_final_fields
  static List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Text(
        'Click Camera icon to take a photo',
        style: optionStyle,
      ),
    ),
    Container(child: const GalleryCamera()),
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Gallery',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 223, 133, 16),
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Take a photo',
        child: const Icon(Icons.camera_alt_outlined),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      //     if (_selectedIndex == 1) {
      //       Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const GalleryCamera()),
      // );

      //     }
    });
  }

  Future<void> _pickImage() async {
    File? image1;

    // Image = File(image.path);
   ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    Uint8List imageBytes = await image.readAsBytes();
    setState(() {
      adapter.storeImage(imageBytes);
    });
    PermissionStatus cameraStatus = await Permission.camera.request();

    if (cameraStatus == PermissionStatus.granted) {
      //todo
    }
    if (cameraStatus == PermissionStatus.denied) {
      print('permission denied');
    }
    if (cameraStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }

    PermissionStatus storageStatus = await Permission.storage.request();

    if (storageStatus == PermissionStatus.granted) {
      //todo
    }
    if (storageStatus == PermissionStatus.denied) {
      print('object');
    }
    if (storageStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
    ////////create folder/////////
    final folderName = "sandra";
    final path = Directory("storage/emulated/0/$folderName");
    if ((await path.exists())) {
      // TODO:
      print("exist");
    } else {
      // TODO:
      print("not exist");
      path.create();
      print('file created');
    }
    image1 = File(image.path);
    saveImage(image1);
  }

  saveImage(File Image) async {
    // Step 3: Get directory where we can duplicate selected file.
    final String path = (await getApplicationDocumentsDirectory()).path;

    File convertedImg = File(Image.path);

    final fluttiepath = "storage/emulated/0/sandra";

    // Step 4: Copy the file to a application document directory.
    // final fileName = basename(convertedImg.path);
    final String fileName = DateTime.now().toString().trim();
    final File localImage =
        await convertedImg.copy('$fluttiepath/$fileName.jpg');
    print("Saved image under: $path/$fileName");
  }
}
