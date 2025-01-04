

import 'package:flutter/material.dart';

class TreatmentScreen extends StatefulWidget{
  const TreatmentScreen({super.key});

  @override
  State<TreatmentScreen> createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends State<TreatmentScreen> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF243B6D),
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: const Text('Treatment',style: TextStyle(
          fontSize: 18, // Adjust font size
          fontWeight: FontWeight.bold, // Make text bold
        )),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Treatment'),
      ),
    );
  }
}
