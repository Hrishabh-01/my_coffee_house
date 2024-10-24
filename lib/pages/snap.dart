import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SnapPage extends StatefulWidget {
  const SnapPage({Key? key}) : super(key: key);

  @override
  State<SnapPage> createState() => _SnapPageState();
}

class _SnapPageState extends State<SnapPage> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference =
  FirebaseFirestore.instance.collection('coffee_feed');

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Coffee"),
      ),
      body: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 25, right: 25),
          child: Column(
            children: [
              TextFormField(
                controller: _controllerName,
                decoration: const InputDecoration(
                    labelText: 'Coffee Name',
                    hintText: 'Enter the name of the Coffee'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a coffee name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controllerDescription,
                decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter the description of the item'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              IconButton(
                onPressed: () async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                  await imagePicker.pickImage(source: ImageSource.camera);
                  print('${file?.path}');

                  if (file == null) return;

                  String uniqueFileName =
                  DateTime.now().microsecondsSinceEpoch.toString();

                  Reference referenceRoot = FirebaseStorage.instance
                      .refFromURL('gs://coffee-shop-cf61f.appspot.com');
                  Reference referenceDirImages =
                  referenceRoot.child('images');

                  // Create a unique reference for the image to be uploaded
                  Reference referenceImageToUpload =
                  referenceDirImages.child(uniqueFileName); // Use unique file name

                  // Handle error/success
                  try {
                    // Store the file
                    await referenceImageToUpload.putFile(File(file.path));
                    // Success
                    imageUrl = await referenceImageToUpload.getDownloadURL();
                    print("Image URL: $imageUrl"); // Log the image URL
                  } catch (error) {
                    print('Error uploading image: $error');
                  }
                },
                icon: const Icon(Icons.camera_alt),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Ensure image is uploaded and has a URL
                  if (imageUrl.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload an image')),
                    );
                    return;
                  }

                  // Check if the form is valid
                  if (key.currentState!.validate()) {
                    String coffeeName = _controllerName.text;
                    String description = _controllerDescription.text;

                    // Create map
                    Map<String, dynamic> dataToSend = {
                      'name': coffeeName,
                      'description': description,
                      'image': imageUrl,
                      'timestamp': FieldValue.serverTimestamp(), // Use Firestore server timestamp
                    };

                    // Add a new item
                    await _reference.add(dataToSend);

                    // Clear the fields after submission
                    _controllerName.clear();
                    _controllerDescription.clear();
                    imageUrl = ''; // Reset image URL
                    print('Coffee data submitted successfully!');
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
