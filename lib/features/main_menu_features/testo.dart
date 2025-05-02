import 'package:flutter/material.dart';

class Testo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpansionTile Example',
      home: Scaffold(
        appBar: AppBar(title: Text('ExpansionTile Example')),
        body: ListView(
          children: [
            ExpansionTile(
              title: Text('معلومات المستخدم'),
              leading: Icon(Icons.person),
              children: [
                ListTile(title: Text('الاسم: أحمد')),
                ListTile(title: Text('البريد الإلكتروني: ahmed@example.com')),
              ],
            ),
            ExpansionTile(
              title: Text('الطلبات'),
              leading: Icon(Icons.shopping_cart),
              children: [
                InkWell(
                  onTap: () {
                    print('0');
                  },
                  child: ListTile(title: Text('طلب رقم 1')),
                ),
                ListTile(title: Text('طلب رقم 2')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
