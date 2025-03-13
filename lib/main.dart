import 'package:optician_app/core/provider/event_provider.dart';
import 'package:optician_app/core/utils/route.dart';
import 'package:optician_app/notification_service.dart';
import 'package:optician_app/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize(); // ✅ تهيئة الإشعارات
  SqlDb sqlDb = SqlDb(); // إنشاء كائن لقاعدة البيانات
  await sqlDb.intialDb(); // تهيئة قاعدة البيانات

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => sqlDb), // 🔹 إضافة SqlDb كمزود
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(400, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, child) => MaterialApp.router(
            routerConfig: AppRouter.router,
            theme: ThemeData(
              textTheme: GoogleFonts.cairoTextTheme(
                Theme.of(context).textTheme,
              ),
              useMaterial3: false,
              scaffoldBackgroundColor: const Color(0xfffffbfb), // لون الخلفية
            ),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', 'AR'), // اللغة العربية
            ],
            locale: const Locale('ar', 'AR'),
            debugShowCheckedModeBanner: false,
          ),
    );
  }
}
