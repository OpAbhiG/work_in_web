import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {

  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle_rounded, // Icon to indicate success
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Your appointment has been booked!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Thank you for choosing us. We look forward to seeing you!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            // Button to navigate back to Home
            ElevatedButton(
              onPressed: () {
                // Navigate back to Home Screen
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
