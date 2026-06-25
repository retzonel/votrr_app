import 'package:flutter/material.dart';

class VotePage extends StatelessWidget {
  const VotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Vote', style: TextStyle(fontSize: 24))),
    );
  }
}