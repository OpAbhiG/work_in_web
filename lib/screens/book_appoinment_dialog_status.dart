

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../DOCTOR_SCREEN/doctor_model.dart';
import '../models/doctor.dart';
import 'doctor_nav_screen.dart';

class BookAppointmentDialogState extends State<BookAppointmentDialog> {
  Doctor? selectedDoctor;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Book an Appointment',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildDoctorDropdown(),
          const SizedBox(height: 16),
          _buildDateTimePicker(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: selectedDoctor != null
                ? () {
              widget.onBookAppointment(selectedDoctor!, selectedDate);
              Navigator.of(context).pop();
            }
                : null,
            child: const Text('Book Appointment'),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorDropdown() {
    return DropdownButton<Doctor>(
      value: selectedDoctor,
      onChanged: (Doctor? newValue) {
        setState(() {
          selectedDoctor = newValue;
        });
      },
      hint: const Text('Select Doctor'),
      isExpanded: true,
      items: widget.doctors.map((Doctor doctor) {
        return DropdownMenuItem<Doctor>(
          value: doctor,
          child: Text(doctor.fullName),
        );
      }).toList(),
    );
  }
  Widget _buildDateTimePicker() {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (pickedDate != null) {
          setState(() {
            selectedDate = pickedDate;
          });
          // Call the time picker after selecting the date
          await _selectTime(context);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Select Date',
          border: OutlineInputBorder(),
        ),
        child: Text(DateFormat('yyyy-MM-dd HH:mm').format(selectedDate)), // Update this line to show both date and time
      ),
    );
  }
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

}
class BookAppointmentDialog extends StatefulWidget {
  final List<Doctor> doctors;
  final Function(Doctor, DateTime) onBookAppointment;

  const BookAppointmentDialog({
    super.key,
    required this.doctors,
    required this.onBookAppointment,

  });

  @override
  BookAppointmentDialogState createState() => BookAppointmentDialogState();
}


