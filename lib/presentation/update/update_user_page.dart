import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realtime_database/presentation/home/home_page.dart';


class UpdateUserPage extends StatefulWidget {
  final String contactKey;
  const UpdateUserPage({super.key, required this.contactKey});

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var url;
  var url1;
  File? file;
  ImagePicker image = ImagePicker();
  DatabaseReference? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('contacts');
    contactsData();
  }

  void contactsData() async {
    DataSnapshot snapshot = await dbRef!.child(widget.contactKey).get();

    Map Contact = snapshot.value as Map;

    setState(() {
      nameController.text = Contact['name'];
      phoneController.text = Contact['number'];
      url = Contact['url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Update User'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              height: 40,
              onPressed: () {
                if (file != null) {
                  uploadFile();
                } else {
                  directUpdate();
                }
              },
              color: Colors.indigo[900],
              child: const Text(
                "Update",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      url = null;
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
      url1 = await snapshot.ref.getDownloadURL();
      setState(() {
        url1 = url1;
      });
      if (url1 != null) {
        Map<String, String> Contact = {
          'name': nameController.text,
          'number': phoneController.text,
          'url': url1,
        };

        dbRef!.child(widget.contactKey).update(Contact).whenComplete(() {
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

  directUpdate() {
    if (url != null) {
      Map<String, String> Contact = {
        'name': nameController.text,
        'number': phoneController.text,
        'url': url,
      };

      dbRef!.child(widget.contactKey).update(Contact).whenComplete(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
        );
      });
    }
  }
}