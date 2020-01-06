import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SinglePatientInfo extends StatelessWidget {
  final DocumentSnapshot data;

  const SinglePatientInfo({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['p_name']),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                'Patient Description',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Text(data['description']),
              SizedBox(height: 20),
              Divider(
                thickness: 2,
              ),
              SizedBox(height: 10),
              Text(
                'Before operation image',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              CachedNetworkImage(
                imageUrl: data['beforeImage'],
              ),
              SizedBox(height: 20),
              Divider(
                thickness: 2,
              ),
              SizedBox(height: 10),
              Text(
                'After operation image',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              CachedNetworkImage(
                imageUrl: data['afterImage'],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
