import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optician_app/core/shered_widget/action_button_widget.dart';
import 'package:optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:optician_app/core/styles/Colors.dart';
import 'package:optician_app/features/clients_features/points.dart';
import 'package:optician_app/sqldb.dart';

class ClientProfileScreen extends StatefulWidget {
  final int clientId;

  const ClientProfileScreen({super.key, required this.clientId});

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen>
    with TickerProviderStateMixin {
  SqlDb sqlDb = SqlDb();
  Map client = {};
  int optometryCount = 0;
  int purchasesCount = 0;
  List<Map> optometryInvoices = [];
  List<Map> purchasesInvoices = [];
  List<Map> clientPoints = []; // ✅ بيانات نقاط العميل

  bool _visible = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  String getLevel(int points) {
    if (points >= 400) return "العميل الوفي";
    if (points >= 200) return "العميل الذهبي";
    if (points >= 50) return "العميل الفضي";
    return "العميل الجديد";
  }

  Future<void> loadData() async {
    List<Map> clientInfo = await sqlDb.readData(
      "SELECT * FROM Clients WHERE id = ${widget.clientId}",
    );
    if (clientInfo.isNotEmpty) {
      client = clientInfo.first;
    }

    optometryInvoices = await sqlDb.readData('''
      SELECT * FROM ClientOptometry WHERE client_id = ${widget.clientId}
    ''');

    purchasesInvoices = await sqlDb.readData('''
      SELECT * FROM ClientPurchases WHERE client_id = ${widget.clientId}
    ''');

    clientPoints = await sqlDb.readData('''
      SELECT * FROM Points WHERE client_id = ${widget.clientId}
      ORDER BY date DESC
    ''');

    setState(() {
      optometryCount = optometryInvoices.length;
      purchasesCount = purchasesInvoices.length;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _visible = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final points = client['points'] ?? 0;

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: AppColors.transparent,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                CustomAppBar(tital: "حساب العميل"),
                const SizedBox(height: 5),
                AnimatedOpacity(
                  opacity: _visible ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  "رقم العميل: ${client['id']}\n${client['name']}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text("📞 ${client['phone'] ?? ''}"),
                                const Divider(height: 20),
                                Text("⭐ عدد النقاط: $points"),
                                Text("🏆 المستوى: ${getLevel(points)}"),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ActionButtonWidget(
                              iconPath: Icons.photo_camera_front_sharp,
                              title: 'نقاط العميل',
                              width: 150.w,
                              isSolid: false,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => ClientPointsScreen(
                                          clientId: client['id'],
                                        ),
                                  ),
                                ).then((_) => loadData());
                              },
                            ),
                          ),
                        ),

                        // ✅ بطاقة إحصائية للفواتير (يمكنك حذفها إذا لم تعد بحاجة لها)
                        Row(
                          children: [
                            _buildStatCard(
                              "فواتير الفحص",
                              optometryCount,
                              LinearGradient(
                                colors: [
                                  Colors.purple.shade300,
                                  Colors.purple.shade700,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildStatCard(
                              "فواتير الشراء",
                              purchasesCount,
                              LinearGradient(
                                colors: [
                                  Colors.green.shade300,
                                  Colors.green.shade700,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ✅ تفاصيل نقاط العميل
                        _buildPointsSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    int count,
    LinearGradient gradientColors,
  ) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: gradientColors,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "$count",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPointsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: const Text(
          "تفاصيل النقاط",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children:
            clientPoints.isEmpty
                ? [
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("لا توجد نقاط لهذا العميل"),
                  ),
                ]
                : clientPoints.map((point) {
                  return ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: Text(point['task_name']),
                    subtitle: Text(
                      "الكمية: ${point['quantity']} × ${point['points_per_item']}",
                    ),
                    trailing: Text(
                      "=${point['total_points']} نقطة",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  );
                }).toList(),
      ),
    );
  }
}
