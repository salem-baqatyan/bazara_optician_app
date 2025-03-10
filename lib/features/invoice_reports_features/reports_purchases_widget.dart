import 'package:bazara_optician_app/core/utils/route.dart';
import 'package:bazara_optician_app/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportsPurchasesWidget extends StatefulWidget {
  const ReportsPurchasesWidget({super.key});

  @override
  State<ReportsPurchasesWidget> createState() => _ReportsPurchasesWidgetState();
}

class _ReportsPurchasesWidgetState extends State<ReportsPurchasesWidget> {
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
      "SELECT * FROM ClientPurchases ORDER BY name ASC",
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
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              context.push(
                AppRouter.storeRouters.kInvoiceDetailsScreen,
                extra: [list[i]['id'], 'Purchases'],
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
