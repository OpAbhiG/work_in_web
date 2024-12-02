import 'package:flutter/material.dart';
// import 'package:login_registration_screen/models/doctor.dart';

import '../models/doctor.dart';
import 'booking_confirmation_screen.dart';
import 'doctor_nav_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key,
     Doctor? doctor,
     TimeOfDay? time,
     DateTime? date});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isCashSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A237E),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dr. Kulsum Khan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                Icon(Icons.calendar_today, size: 20),
                // SizedBox(width: 15),
                Text('Nov 23, 2024', style: TextStyle(fontSize: 15),),
                // Spacer(),
                SizedBox(width: 10),
                Icon(Icons.access_time, size: 20),
                // SizedBox(width: 10),
                Text('10:10AM', style: TextStyle(fontSize: 15),),
                SizedBox(width: 10),
                Text('Rs 199', style: TextStyle(fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),),
              ],
            ),

            SizedBox(height: 34),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: Icon(Icons.money, color: Colors.green),
                title: Text('Cash'),
                trailing: Radio(
                  value: false,
                  groupValue: isCashSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      isCashSelected = value!;
                    });
                  },
                ),
              ),
            ),
            // Spacer(),

            SizedBox(height: 80),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {


                      Navigator.push(

                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingConfirmationScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1A237E),
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text('Confirm',style: TextStyle(color: Colors.white),),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text('Cancel',style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}