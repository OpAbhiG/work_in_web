import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, String>> historyList;

  const HistoryScreen({Key? key, required this.historyList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient History',style: TextStyle(
        fontSize: 18, // Adjust font size
        fontWeight: FontWeight.bold, // Make text bold
        // fontFamily: 'Schyler', // Optional: Set a custom font family if you have one
      )),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: historyList.isEmpty
            ? const Center(child: Text('No history available.'))
            : ListView.builder(
          itemCount: historyList.length,
          itemBuilder: (context, index) {
            final history = historyList[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date and Time: ${history['dateTime']}', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Name: ${history['name']}', style: TextStyle(fontSize: 16)),
                    Text('Age: ${history['age']}', style: TextStyle(fontSize: 16)),
                    Text('Gender: ${history['gender']}', style: TextStyle(fontSize: 16)),
                    Text('Blood Pressure: ${history['bloodPressure']}', style: TextStyle(fontSize: 16)),
                    Text('Temperature: ${history['temperature']}', style: TextStyle(fontSize: 16)),
                    Text('Pulse Rate: ${history['pulseRate']}', style: TextStyle(fontSize: 16)),
                    Text('Weight: ${history['weight']}', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
