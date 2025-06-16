import 'package:flutter/material.dart';

class ClientPointsScreen extends StatefulWidget {
  @override
  _ClientPointsScreenState createState() => _ClientPointsScreenState();
}

class _ClientPointsScreenState extends State<ClientPointsScreen> {
  final List<Map<String, dynamic>> tasks = [
    {'title': 'شراء نظارة طبية', 'unitPoints': 5, 'quantity': 0},
    {'title': 'شراء نظارة شمسية', 'unitPoints': 3, 'quantity': 0},
    {'title': 'إحالة صديق', 'unitPoints': 10, 'quantity': 0},
  ];

  void increment(int index) {
    setState(() {
      tasks[index]['quantity']++;
    });
  }

  void decrement(int index) {
    setState(() {
      if (tasks[index]['quantity'] > 0) tasks[index]['quantity']--;
    });
  }

  void submitTask(int index) {
    final task = tasks[index];
    final int totalPoints = task['quantity'] * task['unitPoints'];
    // TODO: إدخال البيانات في قاعدة البيانات
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حفظ ${task['title']}، تم كسب $totalPoints نقطة'),
      ),
    );
    setState(() {
      tasks[index]['quantity'] = 0; // إعادة العداد للصفر
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('نقاط العميل')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['title'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('كل وحدة = ${task['unitPoints']} نقاط'),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () => decrement(index),
                      ),
                      Text(
                        '${task['quantity']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: () => increment(index),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed:
                            task['quantity'] == 0
                                ? null
                                : () => submitTask(index),
                        child: Text('احصل على النقاط'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
