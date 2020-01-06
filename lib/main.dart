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

  File _afterImage;
  File _beforeImage;

  bool isLoading = false;

  StorageReference _reference = FirebaseStorage.instance.ref();

  Future getImage(bool isCamera) async {
    File image;
    if (isCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    return image;
  }

  Future<List<String>> uploadImage() async {
    StorageUploadTask uploadTaskBefore =
        _reference.child(DateTime.now().toString()).putFile(_beforeImage);
    StorageUploadTask uploadTaskAfter =
        _reference.child(DateTime.now().toString()).putFile(_afterImage);
    StorageTaskSnapshot taskSnapshot1 = await uploadTaskBefore.onComplete;
    StorageTaskSnapshot taskSnapshot2 = await uploadTaskAfter.onComplete;
    String image1Url = await taskSnapshot1.ref.getDownloadURL();
    String image2Url = await taskSnapshot2.ref.getDownloadURL();
    return [image1Url, image2Url];
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
      body: Builder(
        builder: (bcontext) {
          return isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
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
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  _beforeImage = await getImage(false);
                                  setState(() {});
                                  //File file = await FilePicker.getFile();
                                },
                              ),
                              _beforeImage == null
                                  ? Container()
                                  : Image.file(
                                      _beforeImage,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
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
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();

                                  _afterImage = await getImage(false);
                                  setState(() {});
                                },

                                /*onPressed: () async {
                            File file = await FilePicker.getFile();
                            print(file.path);
                          },*/
                              ),
                              _afterImage == null
                                  ? Container()
                                  : Image.file(
                                      _afterImage,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
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
                                  print(
                                      '${dName.text} ${pName.text} ${pDes.text}');

                                  if (dName.text != null &&
                                      pName != null &&
                                      pDes != null &&
                                      _beforeImage != null &&
                                      _afterImage != null) {
                                    isLoading = true;
                                    setState(() {});
                                    uploadImage().then((List<String> url) {
                                      Firestore.instance
                                          .collection('record')
                                          .document()
                                          .setData(
                                        {
                                          'd_name': dName.text,
                                          'p_name': pName.text,
                                          'description': pDes.text,
                                          'beforeImage': url[0],
                                          'afterImage': url[1]
                                        },
                                      ).then((_) {
                                        dName.text = '';
                                        pName.text = '';
                                        pDes.text = '';
                                        _beforeImage = null;
                                        _afterImage = null;
                                        Scaffold.of(bcontext).showSnackBar(
                                          new SnackBar(
                                            content:
                                                new Text('Profile Updated'),
                                          ),
                                        );
                                        isLoading = false;
                                        setState(() {});
                                      });
                                    });
                                  } else {
                                    Scaffold.of(bcontext).showSnackBar(
                                      new SnackBar(
                                        content:
                                            new Text('Fill all required data'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
