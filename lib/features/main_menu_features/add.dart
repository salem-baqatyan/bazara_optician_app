import 'package:bazara_optician_app/core/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddEventScreen extends StatefulWidget {
  final DateTime initialDate;

  AddEventScreen({required this.initialDate});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  late TextEditingController _dateController;
  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
      text: DateFormat(
        "yyyy/MM/dd",
      ).format(widget.initialDate), // ضبط التاريخ تلقائيًا
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة حدث جديد")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: "التاريخ",
                border: OutlineInputBorder(),
              ),
              readOnly: true, // جعل الحقل غير قابل للتعديل يدويًا
            ),
            SizedBox(height: 10),
            TextField(
              controller: _eventController,
              decoration: InputDecoration(
                labelText: "أدخل اسم الحدث",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text("إضافة الحدث")),
          ],
        ),
      ),
    );
  }
}
