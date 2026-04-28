import 'package:flutter/material.dart';
import 'package:unik_mobile/screens/lab1/page.dart';
import 'package:unik_mobile/screens/lab2/page.dart';
import 'package:unik_mobile/widgets/lab_list_tile.dart';

class LabsPage extends StatelessWidget {
  const LabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Labs')),
      body: ListView(
        children: <Widget>[
          LabListTile(
            title: 'Lab 1',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const Lab1Page(title: 'Magic Counter'),
                ),
              );
            },
          ),
          LabListTile(
            title: 'Lab 2',
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute<void>(builder: (_) => const Lab2Page()));
            },
          ),
        ],
      ),
    );
  }
}
