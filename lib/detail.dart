import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model/model_kosakata.dart';

class PageDetail extends StatelessWidget {
  final Datum? data;

  const PageDetail(this.data, {super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data!.arti),
        backgroundColor: Colors.cyan,
      ),

      body: ListView(
        children: [

          ListTile(
            title: Text(data?.kosakata ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),
            ),
            subtitle: Text(data?.arti??""),
          )
        ],
      ),
    );
  }
}
