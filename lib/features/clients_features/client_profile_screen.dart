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
                        //TODO: هنا زر ينقلك الى شاشة النقاط
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
                                    builder: (_) => ClientPointsScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // 📊 بطاقتي عدد الفواتير
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

                        // 📋 فواتير الفحص
                        _buildInvoicesSection(
                          "فواتير فحص النظر",
                          optometryInvoices,
                          "review_date",
                        ),

                        const SizedBox(height: 10),

                        // 🕶️ فواتير الشراء
                        _buildInvoicesSection(
                          "فواتير شراء النظارات",
                          purchasesInvoices,
                          "delvery_date",
                        ),
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

  Widget _buildInvoicesSection(String title, List<Map> data, String dateField) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children:
            data.isEmpty
                ? [
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("لا توجد فواتير"),
                  ),
                ]
                : data.map((invoice) {
                  return ListTile(
                    title: Text(
                      "📅 التاريخ: ${invoice[dateField] ?? "غير متوفر"}",
                    ),
                    subtitle: Text("رقم الفاتورة: ${invoice['id']}"),
                  );
                }).toList(),
      ),
    );
  }
}
