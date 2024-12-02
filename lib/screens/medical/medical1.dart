import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'medical2.dart';
// import '../models/medical_record.dart';



class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  _MedicalRecordsScreenState createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  final List<String> recordTypes = [
    'Blood Test',
    'Scanning',
    'ECG',
    'X-Ray',
    'Miscellaneous'
  ];
  String? selectedType;
  File? selectedFile;
  late Box<MedicalRecord> recordsBox;
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    recordsBox = Hive.box<MedicalRecord>('medical_records');
  }



  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        File file = File(result.files.single.path!);
        // Check file size (5MB limit)
        if (await file.length() > 5 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File size must be less than 5MB')),
          );
          return;
        }
        setState(() {
          selectedFile = file;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> uploadFile() async {
    if (selectedFile == null || selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both file and record type')),
      );
      return;
    }

    try {
      // Copy file to app directory
      Directory appDir = await getApplicationDocumentsDirectory();
      String fileName = selectedFile!.path.split('/').last;
      String newPath = '${appDir.path}/$fileName';
      await selectedFile!.copy(newPath);



      // Save record to Hive
      final record = MedicalRecord(
        fileName: fileName,
        filePath: newPath,
        recordType: selectedType!,
        uploadDate: DateTime.now(),
      );
      await recordsBox.add(record);

      // Reset state
      setState(() {
        selectedFile = null;
        selectedType = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File uploaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }

  Future<void> deleteRecord(MedicalRecord record) async {
    try {
      // Delete file
      File file = File(record.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      // Delete record from Hive
      await record.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Record deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting record: $e')),
      );
    }
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
          'Medical Records',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload Medical Records',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1A237E),
                        ),
                        onPressed: pickFile,
                        child: Text('Choose File'),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedFile?.path.split('/').last ?? 'No File Chosen',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Note - Maximum upload file size : 5 MB',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Medical Record Type *',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedType,
                    items: recordTypes.map((String type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1A237E),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: uploadFile,
                      child: Text('Upload'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Color(0xFF1A237E),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  recordTypes.length,
                      (index) => InkWell(
                    onTap: () {
                      setState(() {
                        selectedTabIndex = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selectedTabIndex == index
                                ? Colors.orange
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        recordTypes[index],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'File',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                ),
                Text(
                  'Action',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: recordsBox.listenable(),
              builder: (context, Box<MedicalRecord> box, _) {
                final records = box.values
                    .where((record) =>
                record.recordType == recordTypes[selectedTabIndex])
                    .toList();

                if (records.isEmpty) {
                  return Center(child: Text('No Records Found'));
                }

                return ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return ListTile(
                      leading: Icon(Icons.file_present),
                      title: Text(record.fileName),
                      subtitle: Text(
                        record.uploadDate.toString().split('.')[0],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.download, color: Colors.orange),
                            onPressed: () async {
                              // Implement file download
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteRecord(record),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}