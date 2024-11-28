

import 'package:flutter/material.dart';

class TreatmentScreen extends StatelessWidget{
  const TreatmentScreen({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Treatment',style: TextStyle(
          fontSize: 18, // Adjust font size
          fontWeight: FontWeight.bold, // Make text bold
          // fontFamily: 'Schyler',
        )),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Treatment'),
      ),
    );
  }

}
