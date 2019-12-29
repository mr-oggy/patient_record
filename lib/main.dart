import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'all_patient_info.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: /* PatientInfoScreen() */ HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController dName = TextEditingController();
  TextEditingController pName = TextEditingController();
  TextEditingController pDes = TextEditingController();

  File _imageFile;
  bool _uploaded = false;
  StorageReference _reference =
      FirebaseStorage.instance.ref().child('myImage.jpg');

  Future getImage(bool isCamera) async {
    File image;
    if (isCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _imageFile = image;
    });
  }

  Future uploadImage() async {
    StorageUploadTask uploadTask = _reference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      _uploaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Patient Information"),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("DOCTOR'S RECORD"),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Enter Patient Information'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Get Patient Information'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientInfoScreen(),
                  ),
                );
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                /*Text(
                  "DOCTOR'S RECORD",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),*/

                SizedBox(height: 20),
                TextField(
                  controller: dName,
                  decoration: InputDecoration(
                    hintText: 'Doctor\'s name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: pName,
                  decoration: InputDecoration(
                    hintText: 'Patient\'s name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: pDes,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Patient\'s description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      child: Text(
                        'Upload Photo Before OPERATION  ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        getImage(false);
                        //File file = await FilePicker.getFile();
                      },
                    ),
                    _imageFile == null
                        ? Container()
                        : Image.file(
                            _imageFile,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                    /*Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image.network(
                          'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png'),
                    ),*/
                    SizedBox(height: 20),
                    RaisedButton(
                      child: Text(
                        ' Upload Photo After OPERATION ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        getImage(false);
                      },

                      /*onPressed: () async {
                        File file = await FilePicker.getFile();
                        print(file.path);
                      },*/
                    ),
                    _imageFile == null
                        ? Container()
                        : Image.file(
                            _imageFile,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                    /*Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image.network(
                        'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
                      ),
                    ),*/
                    RaisedButton(
                      child: Text('Submit'),
                      onPressed: () {
                        Firestore.instance
                            .collection('record')
                            .document()
                            .setData(
                          {
                            'd_name': dName.text,
                            'p_name': pName.text,
                            'description': pDes.text,
                          },
                        ).then((_) => print('pushed --> '));

                        uploadImage();
                      },
                    ),
                    _uploaded == false ? Container() : Text('Data Uploaded'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
