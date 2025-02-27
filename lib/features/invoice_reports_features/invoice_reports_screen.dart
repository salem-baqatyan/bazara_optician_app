import 'package:bazara_optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:bazara_optician_app/core/styles/Colors.dart';
import 'package:bazara_optician_app/core/utils/route.dart';
import 'package:bazara_optician_app/features/invoice_reports_features/type_view_radio_widget.dart';
import 'package:bazara_optician_app/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvoiceReportsScreen extends StatefulWidget {
  const InvoiceReportsScreen({super.key});

  @override
  State<InvoiceReportsScreen> createState() => _InvoiceReportsScreenState();
}

class _InvoiceReportsScreenState extends State<InvoiceReportsScreen> {
  SqlDb sqlDb = SqlDb();
  String selectedOption = 'Optometry';
  bool isDefaultValue = true;
  bool isLoading = true;
  List list = [];

  @override
  void initState() {
    super.initState();
    readData();

    isDefaultValue = selectedOption == 'Optometry';
  }

  Future readData() async {
    if (isDefaultValue == true) {
      list.clear();
      List<Map> response = await sqlDb.readData(
        "SELECT * FROM ClientOptometry ORDER BY name ASC",
      );
      debugPrint('response: $response');
      list.addAll(response);
      debugPrint('list: $list');
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: AppColors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(tital: 'تقارير الفواتير'),
              SizedBox(height: 20.h),
              TypeViewRadioWidget(
                selectedOption: selectedOption,
                onChangedOptometry: (value) {
                  setState(() {
                    selectedOption = value!;
                    isDefaultValue = true;
                    readData();
                  });
                },
                onChangedPurchases: (value) {
                  setState(() {
                    selectedOption = value!;
                    isDefaultValue = false;
                    readData();
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteName.kInvoiceDetailsScreen,
                          arguments: {
                            'id': list[i]['id'],
                            'isDefaultValue': isDefaultValue,
                          },
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
