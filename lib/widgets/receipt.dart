import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../ticket.dart';

class PaymentReceiptPdf extends pw.StatelessWidget {
  final BusTicket ticket;
  final String paymentMethod;
  final DateTime paymentDate;
  final pw.ThemeData theme;

  PaymentReceiptPdf( {
    required this.ticket,
    required this.paymentMethod,
    required this.paymentDate,
    required this.theme
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Theme(
      data: theme,
      child: pw.Container(
        padding: pw.EdgeInsets.all(10),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Төлем туралы түбіртек',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Билет туралы ақпарат:'),
            pw.Text('ID: ${ticket.id}'),
            pw.Text('Автобус нөмірі: ${ticket.busId}'),
            pw.Text('Цена: ${ticket.price} тенге.'),
            pw.Text('Қайда: ${ticket.from}'),
            pw.Text('Қайда: ${ticket.to}'),
            pw.Text('Қашықтық: ${ticket.distance} км'),
            pw.SizedBox(height: 20),
            pw.Text('Төлем туралы ақпарат:'),
            pw.Text('Төлем тәсілі: $paymentMethod'),
            pw.Text('төлем күні: ${paymentDate.toString()}'),
          ],
        ),
      ),
    );
  }

  pw.Document generatePdf() {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: build));
    return pdf;
  }
}

