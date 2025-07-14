import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:optician_app/core/styles/Colors.dart';
import 'package:optician_app/features/clients_features/client_profile_screen.dart';
import 'package:optician_app/sqldb.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  SqlDb sqlDb = SqlDb();
  List<Map> clients = [];

  Future<void> loadData() async {
    List<Map> response = await sqlDb.readData('SELECT * FROM Clients');
    setState(() {
      clients = response;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: AppColors.transparent,

          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                CustomAppBar(tital: 'العملاء'),
                const SizedBox(height: 5),
                clients.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_add_disabled_sharp,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "لا يوجد عملاء حاليا",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "عندما يتم إضافة عملاء, ستظهر هنا",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                    : Expanded(
                      child: ListView.builder(
                        itemCount: clients.length,
                        itemBuilder: (context, index) {
                          final client = clients[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: ListTile(
                              title: Text(client['name']),
                              subtitle: Text("📞 ${client['phone']}"),
                              trailing: Text("⭐ ${client['points'] ?? 0} نقطة"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => ClientProfileScreen(
                                          clientId: client['id'],
                                        ),
                                  ),
                                ).then((_) => loadData());
                              },
                            ),
                          );
                        },
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
