import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'HistoryScreen.dart';

class PatientDetailsForm extends StatefulWidget {
  @override
  _PatientDetailsFormState createState() => _PatientDetailsFormState();
}

class _PatientDetailsFormState extends State<PatientDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, dynamic> appointment;  // Add this line to accept appointment data
  String? name, age, gender;
  String? bloodPressure, temperature, pulseRate, weight;

  // List to store the submitted details
  static List<Map<String, String>> historyList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Vitals Details',
        style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Card(
          elevation: 4,
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onSaved: (value) => name = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Age'),
                  onSaved: (value) => age = value,
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  onChanged: (value) => setState(() => gender = value),
                  items: ['Male', 'Female', 'Other']
                      .map((label) => DropdownMenuItem(
                    value: label,
                    child: Text(label),
                  ))
                      .toList(),
                ),
                // Vitals section
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Blood Pressure'),
                  onSaved: (value) => bloodPressure = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Temperature'),
                  onSaved: (value) => temperature = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Pulse Rate'),
                  onSaved: (value) => pulseRate = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Weight'),
                  onSaved: (value) => weight = value,
                ),
                SizedBox(height: 20),
                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState?.save();
                    String dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
                    setState(() {
                      // Add the details to the history list with date and time
                      historyList.add({
                        'dateTime': dateTime,
                        'name': name!,
                        'age': age!,
                        'gender': gender!,
                        'bloodPressure': bloodPressure!,
                        'temperature': temperature!,
                        'pulseRate': pulseRate!,
                        'weight': weight!,
                      });
                    });

                    // Show the success dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Center(child: Text('Vitals',style: TextStyle(fontSize: 20),)),
                        content: Text('Patient Vitals Map Created Successfully',style: TextStyle(fontSize: 18)),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Center(child: Text('OK',style: TextStyle(fontSize: 10))),
                          ),
                        ],
                      ),
                    );

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => HistoryScreen(historyList: historyList),
                    //   ),
                    // );



                    // Reset form and clear fields after submission
                    _formKey.currentState?.reset();
                    setState(() {
                      name = null;
                      age = null;
                      gender = null;
                      bloodPressure = null;
                      temperature = null;
                      pulseRate = null;
                      weight = null;
                    });

                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>HistoryScreen(historyList: historyList),));

                  },
                  child: const Text('Submit'),
                ),

                SizedBox(height: 18,),
                // View History Button

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VitalHistoryScreen(slotId:appointment['slot_id']),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  child: const Text('View History'),
                ),


                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Once you click "Submit", the details will be added to your history.',
                    style: TextStyle(color: Colors.green,fontSize: 10),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

