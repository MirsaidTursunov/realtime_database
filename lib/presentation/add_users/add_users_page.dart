import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realtime_database/presentation/home/home_page.dart';

class AddUsersPage extends StatefulWidget {
  const AddUsersPage({super.key});

  @override
  State<AddUsersPage> createState() => _AddUsersPAgeState();
}

class _AddUsersPAgeState extends State<AddUsersPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  File? file;
  ImagePicker image = ImagePicker();
  var url;
  DatabaseReference? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('contacts');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Users'),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            file == null
                ? GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: const CircleAvatar(
                      minRadius: 60,
                      maxRadius: 60,
                      child: Icon(Icons.person, size: 50),
                    ),
                  )
                : MaterialButton(
                    height: 100,
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                        child: Image.file(
                          file!,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    onPressed: () {
                      getImage();
                    },
                  ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Phone number',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
            ),
            MaterialButton(
              color: Colors.blue,
              onPressed: () {
                if ((file != null) && (nameController.text.isNotEmpty)) {
                  uploadFile();
                }
              },
              child: const Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });

    // print(file);
  }

  uploadFile() async {
    try {
      var imagefile = FirebaseStorage.instance
          .ref()
          .child("contact_photo")
          .child("/${nameController.text}.jpg");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
      if (url != null) {
        Map<String, String> Contact = {
          'name': nameController.text,
          'number': phoneController.text,
          'url': url,
        };

        dbRef!.push().set(Contact).whenComplete(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const HomePage(),
            ),
          );
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
