import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class MedicalRecord extends HiveObject {
  @HiveField(0)
  final String fileName;

  @HiveField(1)
  final String filePath;

  @HiveField(2)
  final String recordType;

  @HiveField(3)
  final DateTime uploadDate;

  MedicalRecord({
    required this.fileName,
    required this.filePath,
    required this.recordType,
    required this.uploadDate,
  });
}
// Hive type adapter
class MedicalRecordAdapter extends TypeAdapter<MedicalRecord> {
  @override
  final int typeId = 0;

  @override
  MedicalRecord read(BinaryReader reader) {
    return MedicalRecord(
      fileName: reader.read(),
      filePath: reader.read(),
      recordType: reader.read(),
      uploadDate: DateTime.parse(reader.read()),
    );
  }

  @override
  void write(BinaryWriter writer, MedicalRecord obj) {
    writer.write(obj.fileName);
    writer.write(obj.filePath);
    writer.write(obj.recordType);
    writer.write(obj.uploadDate.toIso8601String());
  }
}