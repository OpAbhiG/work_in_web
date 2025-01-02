import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  bool isLoading = true;
  bool isInvoiceAvailable = false;
  Map<String, dynamic> invoiceData = {};

  @override
  void initState() {
    super.initState();
    fetchInvoice();
  }
  Future<void> fetchInvoice() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Example API call to fetch invoice data
      final response = await http.get(Uri.parse('https://api.example.com/invoice'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['invoice'] != null) {
          setState(() {
            isInvoiceAvailable = true;
            invoiceData = data['invoice']; // Assign fetched invoice data
            isLoading = false;
          });
        } else {
          setState(() {
            isInvoiceAvailable = false;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isInvoiceAvailable = false;
          isLoading = false;
        });
        showError('Failed to fetch invoice.');
      }
    } catch (e) {
      setState(() {
        isInvoiceAvailable = false;
        isLoading = false;
      });
      showError('Error fetching invoice: $e');
    }
  }
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
          'Invoice',
          style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator(color: Color(0xFF243B6D),)
            : isInvoiceAvailable
            ? InvoiceDetails(invoice: invoiceData)
            : Text(
          'No invoice found.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class InvoiceDetails extends StatelessWidget {
  final Map<String, dynamic> invoice;
  const InvoiceDetails({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text('Invoice Number: ${invoice['invoice_number']}'),
          // Text('Date: ${invoice['date']}'),
          // Text('Amount: \$${invoice['amount']}'),
          // Add more fields as per the invoice structure
        ],
      ),
    );
  }
}
