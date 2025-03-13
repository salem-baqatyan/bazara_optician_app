import 'package:optician_app/core/utils/route.dart';
import 'package:optician_app/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportsOptometryWidget extends StatefulWidget {
  const ReportsOptometryWidget({super.key});

  @override
  State<ReportsOptometryWidget> createState() => _ReportsOptometryWidgetState();
}

class _ReportsOptometryWidgetState extends State<ReportsOptometryWidget> {
  SqlDb sqlDb = SqlDb();
  bool isLoading = true;
  List list = [];

  @override
  void initState() {
    super.initState();
    readData();
  }

  Future readData() async {
    list.clear();
    List<Map> response = await sqlDb.readData(
      "SELECT * FROM ClientOptometry ORDER BY id ASC",
    );
    debugPrint('response: $response');
    list.addAll(response);
    debugPrint('list: $list');
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
          isLoading
              ? Center(child: CircularProgressIndicator()) // مؤشر تحميل
              : list.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 80, color: Colors.grey.shade400),
                    SizedBox(height: 16),
                    Text(
                      "لا توجد تقارير فواتير متاحة",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "عندما يتم إضافة فواتير, ستظهر هنا",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                      context.push(
                        AppRouter.storeRouters.kInvoiceDetailsScreen,
                        extra: [list[i]['id'], 'Optometry'],
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(list[i]['name']),
                        subtitle: Text(
                          list[i]['phone'],
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
