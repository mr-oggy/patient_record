import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_record/patient_data.dart';

class PatientInfoScreen extends StatefulWidget {
  @override
  _PatientInfoScreenState createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Patient Information"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: name,
              decoration: InputDecoration(
                hintText: 'Patient\'s name',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            RaisedButton(
              child: Text('Search'),
              onPressed: () {},
            ),
            StreamBuilder(
              stream: Firestore.instance
                  .collection('record')
                  // .orderBy('timeStamp')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading...');
                  default:
                    return Column(
                      children: snapshot.data.documents
                          .map(
                            (DocumentSnapshot data) => ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SinglePatientInfo(
                                      data: data,
                                    ),
                                  ),
                                );
                              },
                              leading: CachedNetworkImage(
                                imageUrl: data['beforeImage'],
                                width: 100,
                              ),
                              title: Text('Doctor: ${data['d_name']}'),
                              subtitle: Text('Patient: ${data['p_name']}'),
                            ),
                          )
                          .toList(),
                    );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
