import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SinglePatientInfo extends StatelessWidget {
  final String name;
  final String image1;

  const SinglePatientInfo({Key key, this.name, this.image1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: image1,
            ),
          ],
        ));
  }
}
