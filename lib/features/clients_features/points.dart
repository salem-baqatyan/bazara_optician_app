import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:optician_app/sqldb.dart';

class ClientPointsScreen extends StatefulWidget {
  final int clientId;

  const ClientPointsScreen({super.key, required this.clientId});

  @override
  State<ClientPointsScreen> createState() => _ClientPointsScreenState();
}

class _ClientPointsScreenState extends State<ClientPointsScreen> {
  SqlDb sqlDb = SqlDb();

  List<Map<String, dynamic>> tasksList = [];

  int get totalPoints {
    return tasksList.fold<int>(0, (sum, task) {
      final count = task['count'] ?? 0;
      final points = task['points'] ?? 0;
      return sum + (count as int) * (points as int);
    });
  }

  Future<void> loadTasksFromDatabase() async {
    final List<Map<String, dynamic>> result = List<Map<String, dynamic>>.from(
      await sqlDb.readData("SELECT * FROM Tasks"),
    );

    tasksList =
        result.map((task) {
          return {
            "id": task['id'],
            "name": task['name'],
            "points": task['points'],
            "count": 0,
          };
        }).toList();

    setState(() {});
  }

  Future<void> savePoints() async {
    final now = DateFormat('yyyy-MM-dd').format(DateTime.now());

    int totalEarned = 0;

    for (var item in tasksList) {
      if (item['count'] > 0) {
        int subtotal = item['count'] * item['points'];
        totalEarned += subtotal;

        await sqlDb.insertData('''
          INSERT INTO Points (client_id, task_name, quantity, points_per_item, total_points, date)
          VALUES (${widget.clientId}, "${item['name']}", ${item['count']}, ${item['points']}, $subtotal, "$now")
        ''');
      }
    }

    if (totalEarned > 0) {
      await sqlDb.updateData('''
        UPDATE Clients SET points = points + $totalEarned WHERE id = ${widget.clientId}
      ''');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ تم حفظ النقاط بنجاح')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('⚠️ لم يتم اختيار أي مهمة')));
    }
  }

  @override
  void initState() {
    super.initState();
    loadTasksFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("نقاط العميل")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child:
                  tasksList.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                        itemCount: tasksList.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final task = tasksList[index];
                          return ListTile(
                            title: Text(task['name']),
                            subtitle: Text("عدد النقاط: ${task['points']}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      if (task['count'] > 0) task['count']--;
                                    });
                                  },
                                ),
                                Text(
                                  "${task['count']}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      task['count']++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
            const SizedBox(height: 10),
            Text(
              "الإجمالي: $totalPoints نقطة",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: savePoints,
              icon: const Icon(Icons.save),
              label: const Text("حفظ النقاط"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
