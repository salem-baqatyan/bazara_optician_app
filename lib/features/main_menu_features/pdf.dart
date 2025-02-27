import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfPrinterScreen extends StatefulWidget {
  @override
  _PdfPrinterScreenState createState() => _PdfPrinterScreenState();
}

class _PdfPrinterScreenState extends State<PdfPrinterScreen> {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    // التقاط صورة للويدجت
    final Uint8List? capturedImage = await screenshotController.capture();
    if (capturedImage == null) {
      print("❌ لم يتم التقاط الصورة");
      return;
    }

    // تحويل الصورة إلى كائن من مكتبة image
    img.Image? image = img.decodeImage(capturedImage);
    if (image == null) {
      print("❌ فشل في تحليل الصورة");
      return;
    }

    // تدوير 180 درجة
    img.Image rotatedImage = img.copyRotate(image, angle: 180);

    // عكس أفقيًا بعد التدوير
    img.Image flippedImage = img.flipHorizontal(rotatedImage);

    // تحويل الصورة إلى صيغة PNG
    final Uint8List finalImage = Uint8List.fromList(
      img.encodePng(flippedImage),
    );

    // إضافة الصورة إلى ملف PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(child: pw.Image(pw.MemoryImage(finalImage)));
        },
      ),
    );

    // طباعة أو معاينة PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("طباعة PDF مع دعم العربية")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Screenshot(
            controller: screenshotController,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16),
              color: Colors.blueAccent,
              child: Text(
                "هذا نص باللغة العربية!",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: _generatePdf, child: Text("طباعة PDF")),
        ],
      ),
    );
  }
}
