// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class EditPostView extends StatelessWidget {
  const EditPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
        elevation: 5,
      ),
    );
  }
}
