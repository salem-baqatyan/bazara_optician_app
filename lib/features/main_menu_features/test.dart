// import 'package:optician_app/notification_service.dart';
// import 'package:flutter/material.dart';

// class AlarmScreen extends StatefulWidget {
//   @override
//   _AlarmScreenState createState() => _AlarmScreenState();
// }

// class _AlarmScreenState extends State<AlarmScreen> {
//   TimeOfDay? selectedTime;

//   @override
//   void initState() {
//     super.initState();
//     NotificationService.initialize();
//     NotificationService.requestNotificationPermission();
//   }

//   Future<void> _pickTime() async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (picked != null) {
//       setState(() {
//         selectedTime = picked;
//       });

//       await NotificationService.scheduleNotification(picked);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('✅ تم تعيين المنبّه الساعة ${picked.format(context)}'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('إعداد منبّه')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _pickTime,
//               child: const Text('🔔 اختر وقت التنبيه'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


/*
        name = TextEditingController(text: list.isEmpty ? '' : list[0]['name']);
        phone = TextEditingController(
          text: list.isEmpty ? '' : list[0]['phone'] ?? '',
        );
        message = TextEditingController(text: messageType);



      if (isDefaultValue == true) {
      messageType =
          'موعد مراجعة فحص نظرك قد اقترب حفاظا على صحة عينيك يرجى زيارتنا...';
    } else {
      messageType = 'نظارتك تم تجهيزها يرجى الحضور لستلامها...';
    }

*/