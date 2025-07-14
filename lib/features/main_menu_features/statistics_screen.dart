import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optician_app/core/compent/drawer.dart';
import 'package:optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:optician_app/features/calendar_dates_features/calender_dates_screen.dart';
import 'package:optician_app/sqldb.dart'; // تأكد من صحة المسار

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final SqlDb sqlDb = SqlDb();

  late Future<Map<String, dynamic>> statisticsFuture;

  @override
  void initState() {
    super.initState();
    statisticsFuture = fetchStatistics();
  }

  Future<Map<String, dynamic>> fetchStatistics() async {
    try {
      // تحديد بداية اليوم (منتصف الليل) بصيغة yyyy-MM-dd
      var today = DateTime.now();
      var todayMidnight = DateTime(today.year, today.month, today.day);

      // جلب كل التذكيرات (حتى التواريخ غير صحيحة سيتم معالجتها في Dart)
      var allReminders = await sqlDb.readData('''
      SELECT client_name, type_invoice, date_reminder
      FROM Process
      WHERE date_reminder IS NOT NULL
    ''');

      // تصفية التذكيرات التي لم تنتهِ (أي تاريخها >= اليوم)
      List<Map<String, dynamic>> validReminders = [];

      for (var reminder in allReminders) {
        try {
          String rawDate = (reminder['date_reminder'] as String).replaceAll(
            '/',
            '-',
          );
          DateTime parsedDate = DateTime.parse(rawDate);

          if (!parsedDate.isBefore(todayMidnight)) {
            validReminders.add(reminder);
          }
        } catch (e) {
          print('خطأ في تحويل التاريخ: ${reminder['date_reminder']}');
        }
      }

      // ترتيب حسب التاريخ وأخذ أول 3 فقط
      validReminders.sort((a, b) {
        DateTime aDate = DateTime.parse(
          (a['date_reminder'] as String).replaceAll('/', '-'),
        );
        DateTime bDate = DateTime.parse(
          (b['date_reminder'] as String).replaceAll('/', '-'),
        );
        return aDate.compareTo(bDate);
      });

      var reminderList = validReminders.take(3).toList();

      // --- باقي الكود كما هو بدون تغيير كبير ---

      var lastClientList = await sqlDb.readData(
        'SELECT * FROM Process ORDER BY id DESC LIMIT 1',
      );

      var uniqueClientsList = await sqlDb.readData(
        'SELECT DISTINCT client_name FROM Process',
      );

      var activeClientsList = await sqlDb.readData('''
      SELECT client_name, client_phone, COUNT(*) as total
      FROM Process
      GROUP BY client_name
      ORDER BY total DESC
    ''');

      Map<String, dynamic>? activeClientData;
      int purchasesForActiveCount = 0;
      int optometryForActiveCount = 0;

      if (activeClientsList.isNotEmpty) {
        int topCount = activeClientsList[0]['total'];
        int countWithTopTotal =
            activeClientsList
                .where((client) => client['total'] == topCount)
                .length;

        if (countWithTopTotal == 1) {
          activeClientData = activeClientsList[0];
          String activePhone = activeClientData!['client_name'];

          var purchasesCountList = await sqlDb.readData('''
          SELECT COUNT(*) as count FROM Process
          WHERE client_name = "$activePhone" AND type_invoice = "Purchases"
        ''');

          purchasesForActiveCount =
              (purchasesCountList.isNotEmpty &&
                      purchasesCountList[0]['count'] != null)
                  ? purchasesCountList[0]['count']
                  : 0;

          var optometryCountList = await sqlDb.readData('''
          SELECT COUNT(*) as count FROM Process
          WHERE client_name = "$activePhone" AND type_invoice = "Optometry"
        ''');

          optometryForActiveCount =
              (optometryCountList.isNotEmpty &&
                      optometryCountList[0]['count'] != null)
                  ? optometryCountList[0]['count']
                  : 0;
        } else {
          activeClientData = null;
        }
      }

      var totalPurchasesList = await sqlDb.readData('''
      SELECT COUNT(*) as count FROM Process
      WHERE type_invoice = "Purchases"
    ''');

      int totalPurchasesCount =
          (totalPurchasesList.isNotEmpty &&
                  totalPurchasesList[0]['count'] != null)
              ? totalPurchasesList[0]['count']
              : 0;

      var totalOptometryList = await sqlDb.readData('''
      SELECT COUNT(*) as count FROM Process
      WHERE type_invoice = "Optometry"
    ''');

      int totalOptometryCount =
          (totalOptometryList.isNotEmpty &&
                  totalOptometryList[0]['count'] != null)
              ? totalOptometryList[0]['count']
              : 0;

      return {
        'reminders': reminderList,
        'lastClient': lastClientList.isNotEmpty ? lastClientList[0] : null,
        'uniqueClientsCount': uniqueClientsList.length,
        'activeClient': activeClientData,
        'purchasesCount': purchasesForActiveCount,
        'optometryCount': optometryForActiveCount,
        'totalPurchases': totalPurchasesCount,
        'totalOptometry': totalOptometryCount,
      };
    } catch (e) {
      print('Error fetching statistics: $e');
      return {
        'lastClient': null,
        'uniqueClientsCount': 0,
        'activeClient': null,
        'purchasesCount': 0,
        'optometryCount': 0,
        'totalPurchases': 0,
        'totalOptometry': 0,
        'reminders': [],
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<Map<String, dynamic>>(
          future: statisticsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // عرض رسالة خطأ أكثر تفصيلاً إذا أمكن
              return Center(
                child: Text('حدث خطأ أثناء جلب البيانات: ${snapshot.error}'),
              );
            }
            // هنا لا نحتاج للتحقق من snapshot.data == null لأننا نتعامل معه في fetchStatistics
            // ونستخدم snapshot.data! بأمان نسبي الآن، لكن التحقق أفضل
            else if (!snapshot.hasData) {
              // هذا الشرط قد لا يتم الوصول إليه إذا أرجعنا دائماً map من fetchStatistics
              return const Center(child: Text('لا توجد بيانات حالياً.'));
            }

            // الوصول الآمن للبيانات
            var data =
                snapshot
                    .data ?? // توفير قيم افتراضية هنا أيضاً كإجراء احترازي إضافي
                {
                  'lastClient': null,
                  'uniqueClientsCount': 0,
                  'activeClient': null,
                  'purchasesCount': 0,
                  'optometryCount': 0,
                  'totalPurchases': 0,
                  'totalOptometry': 0,
                };

            // --- باقي الكود الخاص بـ build ---
            // تأكد من أن الكود داخل build يتعامل أيضاً مع القيم التي قد تكون null
            // مثلاً عند عرض بيانات activeClient:
            // data['activeClient'] != null ? Text(...) : Text('لا يوجد زبون نشط')

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  _buildCard(
                    title: '🔔 أهم التذكيرات',
                    child: Column(
                      children:
                          (data['reminders'] as List).isNotEmpty
                              ? (data['reminders'] as List).map<Widget>((
                                reminder,
                              ) {
                                // تعديل التنسيق إذا كان هناك "/" بدلًا من "-"
                                String rawDate = reminder['date_reminder']
                                    .replaceAll('/', '-');
                                DateTime reminderDate;
                                try {
                                  reminderDate = DateTime.parse(rawDate);
                                } catch (e) {
                                  print(
                                    'Error parsing date: ${reminder['date_reminder']}',
                                  );
                                  reminderDate = DateTime.now(); // بديل
                                }

                                final DateTime today = DateTime.now();
                                final DateTime nowAtMidnight = DateTime(
                                  today.year,
                                  today.month,
                                  today.day,
                                );

                                final Duration difference = reminderDate
                                    .difference(nowAtMidnight);
                                final int daysLeft = difference.inDays;

                                String remainingText;
                                if (daysLeft < 0) {
                                  remainingText = "انتهى التذكير";
                                } else if (daysLeft == 0) {
                                  remainingText = "اليوم هو موعد التذكير";
                                } else if (daysLeft == 1) {
                                  remainingText = "باقي يوم";
                                } else if (daysLeft == 2) {
                                  remainingText = "باقي يومان";
                                } else if (daysLeft <= 30) {
                                  remainingText = "باقي $daysLeft أيام";
                                } else {
                                  int monthsLeft = (daysLeft / 30).floor();
                                  if (monthsLeft == 1) {
                                    remainingText = "باقي شهر";
                                  } else if (monthsLeft == 2) {
                                    remainingText = "باقي شهران";
                                  } else {
                                    remainingText = "باقي $monthsLeft أشهر";
                                  }
                                }
                                return InkWell(
                                  onTap: () {
                                    final rawDate = reminder['date_reminder']
                                        .replaceAll('/', '-');
                                    DateTime focusedDate;

                                    try {
                                      focusedDate = DateTime.parse(rawDate);
                                    } catch (e) {
                                      focusedDate =
                                          DateTime.now(); // بديل في حال فشل التحويل
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => CalenderDatesScreen(
                                              focusedDay: focusedDate,
                                            ),
                                      ),
                                    );
                                  },

                                  child: ListTile(
                                    title: Text(
                                      reminder['client_name'] ?? 'غير معروف',
                                    ),
                                    subtitle: Text(
                                      'نوع الفاتورة: ${reminder['type_invoice'] == "Purchases" ? "شراء نظارة" : "فحص نظر"}',
                                    ),
                                    trailing: Text(remainingText),
                                  ),
                                );
                              }).toList()
                              : [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('لا توجد تذكيرات حالياً.'),
                                ),
                              ],
                    ),
                  ),

                  SizedBox(height: 10.h),
                  _buildCard(
                    title: '🧍‍♂️ آخر زبون',
                    child:
                        data['lastClient'] != null
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // استخدام ?? لتوفير قيمة افتراضية إذا كان الاسم null
                                  'الاسم: ${data['lastClient']['client_name'] ?? 'غير معروف'}',
                                ),
                                Text(
                                  'رقم العملية: ${data['lastClient']['id']}',
                                ),
                              ],
                            )
                            : const Text('لا يوجد عملاء بعد.'), // رسالة أوضح
                  ),
                  SizedBox(height: 10.h),
                  _buildCard(
                    title: '👑 الزبون الأكثر نشاطًا',
                    child:
                        data['activeClient'] != null
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // استخدام ?? للتعامل مع اسم قد يكون null
                                  '${data['activeClient']['client_name'] ?? 'زبون غير معروف'} - عدد الفواتير: ${data['purchasesCount'] + data['optometryCount']}',
                                ),
                                const SizedBox(height: 8),
                                Text('فواتير شراء: ${data['purchasesCount']}'),
                                Text('فواتير فحص: ${data['optometryCount']}'),
                              ],
                            )
                            : const Text(
                              'لا يوجد زبون نشط حالياً.',
                            ), // رسالة أوضح
                  ),
                  SizedBox(height: 10.h),
                  _buildCard(
                    title: '👥 عدد الزبائن',
                    // التأكد من أن القيمة رقمية صحيحة
                    child: Text('${data['uniqueClientsCount'] ?? 0} زبون'),
                  ),
                  SizedBox(height: 10.h),
                  _buildCard(
                    title: '📈 الإحصائية البيانية',
                    // التحقق إذا كانت القيمتان صفر قبل عرض الرسم
                    child:
                        (data['totalPurchases'] == 0 &&
                                data['totalOptometry'] == 0)
                            ? const Center(
                              child: Text('لا توجد فواتير لعرض الرسم البياني.'),
                            )
                            : AspectRatio(
                              aspectRatio: 1.3,
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 5,
                                  centerSpaceRadius: 40,
                                  sections: _buildPieChartSections(
                                    data,
                                  ), // استدعاء دالة لإنشاء الأقسام
                                ),
                              ),
                            ),
                  ),
                  SizedBox(height: 120.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء أقسام الرسم البياني
  List<PieChartSectionData> _buildPieChartSections(Map<String, dynamic> data) {
    List<PieChartSectionData> sections = [];
    double totalPurchases = (data['totalPurchases'] ?? 0).toDouble();
    double totalOptometry = (data['totalOptometry'] ?? 0).toDouble();

    // إضافة قسم الشراء فقط إذا كانت قيمته أكبر من صفر
    if (totalPurchases > 0) {
      sections.add(
        PieChartSectionData(
          value: totalPurchases,
          title: 'شراء (${data['totalPurchases']})', // إضافة العدد للعنوان
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white, // لون للنص لضمان الوضوح
          ),
          gradient: LinearGradient(
            colors: [Colors.green.shade300, Colors.green.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      );
    }

    // إضافة قسم الفحص فقط إذا كانت قيمته أكبر من صفر
    if (totalOptometry > 0) {
      sections.add(
        PieChartSectionData(
          value: totalOptometry,
          title: 'فحص (${data['totalOptometry']})', // إضافة العدد للعنوان
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white, // لون للنص لضمان الوضوح
          ),
          gradient: LinearGradient(
            colors: [Colors.purple.shade300, Colors.purple.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      );
    }

    // إذا كان كلاهما صفرًا، يمكن إضافة قسم افتراضي أو ترك القائمة فارغة
    if (sections.isEmpty) {
      // يمكنك إزالة هذا إذا كنت تعرض رسالة نصية بدلاً من الرسم البياني الفارغ
      // sections.add(PieChartSectionData(
      //   value: 1,
      //   title: 'لا بيانات',
      //   radius: 60,
      //   color: Colors.grey,
      // ));
    }

    return sections;
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20, thickness: 1.5),
            child,
          ],
        ),
      ),
    );
  }
}
