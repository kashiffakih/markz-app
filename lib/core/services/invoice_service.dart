import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class InvoiceService {
  Future<Uint8List> generateInvoice(Map<String, dynamic> order) async {
    final pdf = pw.Document();
    final address = order['address'] ?? {};
    final orderDetails = order['order_details'] as List<dynamic>? ?? [];

    // Parse numeric values safely
    double safeParse(dynamic value) {
      if (value == null) return 0.0;
      return double.tryParse(value.toString()) ?? 0.0;
    }

    final isMaharashtra =
        address['state']?.toString().toLowerCase() == 'maharashtra';
    final orderId = order['id']?.toString() ?? '';
    final orderDate = order['created_at'] != null
        ? DateFormat('d-MMM-yy').format(DateTime.parse(order['created_at']))
        : '';

    final customerName = address['full_name']?.toString() ??
        address['name']?.toString() ??
        'Valued Customer';
    final customerAddress = [
      address['add_1'],
      address['add_2'],
      address['city'],
      address['state'],
      address['pincode'],
      'INDIA'
    ].where((e) => e != null && e.toString().isNotEmpty).join(', ');
    final customerPhone = address['phone']?.toString() ?? '';
    final customerState = address['state']?.toString() ?? 'Maharashtra';

    // Calculate values
    final totalAmount = safeParse(order['total_amount']);
    final taxAmount = safeParse(order['tax_amount']);
    final deliveryCharge = safeParse(order['delivery_amount']);
    final packingCharge = safeParse(order['packaging_amount']);
    final platformFee = safeParse(order['platform_fee']);
    final couponDiscount = safeParse(order['coupon_amount']);
    final walletUsed = safeParse(order['wallet_amount_used']);

    // Calculate taxable value (excluding taxes)
    double taxableValue = 0;
    for (var item in orderDetails) {
      final product = item['product'] ?? {};
      final quantity = safeParse(item['quantity']);
      final prices = product['product_prices'] as List<dynamic>? ?? [];
      final priceObj = prices.isNotEmpty ? prices[0] : {};
      final unitPrice = safeParse(priceObj['offer_price'] ?? priceObj['price']);
      final taxableRate = unitPrice / 1.05; // Assuming 5% tax included
      taxableValue += taxableRate * quantity;
    }

    // Helper for cell text style
    final style7 = pw.TextStyle(fontSize: 7);
    final style8 = pw.TextStyle(fontSize: 8);
    final styleBold8 =
        pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold);
    final styleBold9 =
        pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);
    final styleItalic8 = pw.TextStyle(
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
        fontStyle: pw.FontStyle.italic);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(25),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Main Invoice Container - Expanded to fill page
              pw.Expanded(
                child: pw.Container(
                  width: double.infinity,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 1),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      pw.Container(
                        alignment: pw.Alignment.center,
                        padding: const pw.EdgeInsets.symmetric(vertical: 6),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(bottom: pw.BorderSide(width: 1)),
                        ),
                        child: pw.Text('Tax Invoice',
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                                decoration: pw.TextDecoration.underline)),
                      ),

                      // Header Grid - Company Info & Invoice Details
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Left Column (Company Info)
                          pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                              padding: const pw.EdgeInsets.all(4),
                              decoration: const pw.BoxDecoration(
                                border:
                                    pw.Border(right: pw.BorderSide(width: 1)),
                              ),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('Raza Trading Co.',
                                      style: styleBold8),
                                  pw.Text(
                                      '607,Khadan Rd,Near Gupta Sizing\nLand Mark Prime Hospital,Kalyan Rd,&\nAqs Bibi Masjid,Bhiwandi',
                                      style: style7),
                                  pw.Text('27AAKPF0827G1ZX', style: style7),
                                  pw.Text('GSTIN/UIN: 27AAKPF0827G1ZX',
                                      style: style7),
                                  pw.Text('State Name : Maharashtra, Code : 27',
                                      style: style7),
                                  pw.Text('Contact : 7066009926/8600175751',
                                      style: style7),
                                  pw.Text('E-Mail : razafc9226@gmail.com',
                                      style: style7),
                                ],
                              ),
                            ),
                          ),
                          // Right Column (Invoice Details)
                          pw.Expanded(
                            flex: 1,
                            child: pw.Column(
                              children: [
                                _buildInvoiceHeaderRow('Invoice No.', orderId,
                                    'Dated', orderDate, style7),
                                _buildInvoiceHeaderRow(
                                    'Delivery Note', '', '', '', style7),
                                _buildInvoiceHeaderRow('Reference No. & Date.',
                                    '', 'Other References', '', style7),
                                _buildInvoiceHeaderRow("Buyer's Order No.", '',
                                    'Dated', '', style7),
                                _buildInvoiceHeaderRow('Dispatch Doc No.', '',
                                    'Delivery Note Date', '', style7),
                                _buildInvoiceHeaderRow('Dispatched through', '',
                                    'Destination', '', style7),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Consignee Section
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(width: 1)),
                        ),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                              flex: 1,
                              child: pw.Container(
                                padding: const pw.EdgeInsets.all(4),
                                decoration: const pw.BoxDecoration(
                                  border:
                                      pw.Border(right: pw.BorderSide(width: 1)),
                                ),
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text('Consignee (Ship to)',
                                        style: style7),
                                    pw.Text(customerName, style: styleBold8),
                                    pw.Text(customerAddress, style: style7),
                                    pw.Text(
                                        'GSTIN/UIN     :     27AAKPF0827G1ZX',
                                        style: style7),
                                    pw.Text(
                                        'State Name     :     $customerState, Code : 27',
                                        style: style7),
                                    pw.SizedBox(height: 2),
                                    pw.Text(
                                        'Contact           :     +91-$customerPhone',
                                        style: style7),
                                  ],
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Container(),
                            ),
                          ],
                        ),
                      ),

                      // Buyer Section
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(width: 1)),
                        ),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                              flex: 1,
                              child: pw.Container(
                                padding: const pw.EdgeInsets.all(4),
                                decoration: const pw.BoxDecoration(
                                  border:
                                      pw.Border(right: pw.BorderSide(width: 1)),
                                ),
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text('Buyer (Bill to)', style: style7),
                                    pw.Text(customerName, style: styleBold8),
                                    pw.Text(customerAddress, style: style7),
                                    pw.Text(
                                        'GSTIN/UIN        :     27AAKPF0827G1ZX',
                                        style: style7),
                                    pw.Text(
                                        'State Name      :     $customerState',
                                        style: style7),
                                    pw.Text(
                                        'Place of Supply :     $customerState',
                                        style: style7),
                                    pw.Text(
                                        'Contact             :     +91-$customerPhone',
                                        style: style7),
                                  ],
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Container(),
                            ),
                          ],
                        ),
                      ),

                      // Items Table Header
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(width: 1)),
                        ),
                        child: pw.Row(
                          children: [
                            _buildFlexTableHeaderCell('SI\nNo.', 1, style7,
                                borderRight: true),
                            _buildFlexTableHeaderCell(
                                'Description of Goods', 6, style7,
                                borderRight: true),
                            _buildFlexTableHeaderCell('HSN/SAC', 2, style7,
                                borderRight: true),
                            _buildFlexTableHeaderCell('Quantity', 2, style7,
                                borderRight: true),
                            _buildFlexTableHeaderCell('Rate', 2, style7,
                                borderRight: true),
                            _buildFlexTableHeaderCell('per', 1, style7,
                                borderRight: true),
                            _buildFlexTableHeaderCell('Amount', 2, style7),
                          ],
                        ),
                      ),
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(width: 1)),
                        ),
                        child: pw.SizedBox(height: 0),
                      ),

                      // Items List
                      ...List.generate(orderDetails.length, (index) {
                        final item = orderDetails[index];
                        final product = item['product'] ?? {};
                        final quantity = safeParse(item['quantity']);
                        final prices =
                            product['product_prices'] as List<dynamic>? ?? [];
                        final priceObj = prices.isNotEmpty ? prices[0] : {};
                        final unitPrice = safeParse(
                            priceObj['offer_price'] ?? priceObj['price']);
                        final taxableRate = unitPrice / 1.05;
                        final taxableAmount = taxableRate * quantity;

                        return pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildFlexTableCell(
                                (index + 1).toString(), 1, style8,
                                borderRight: true, align: pw.TextAlign.center),
                            _buildFlexTableCell(
                                product['name']?.toString() ?? '',
                                6,
                                styleBold8,
                                borderRight: true),
                            _buildFlexTableCell('', 2, style8,
                                borderRight: true, align: pw.TextAlign.center),
                            _buildFlexTableCell(
                                '${quantity.toInt()} pcs', 2, style8,
                                borderRight: true, align: pw.TextAlign.center),
                            _buildFlexTableCell(
                                taxableRate.toStringAsFixed(2), 2, style8,
                                borderRight: true, align: pw.TextAlign.right),
                            _buildFlexTableCell('pcs', 1, style8,
                                borderRight: true, align: pw.TextAlign.center),
                            _buildFlexTableCell(
                                taxableAmount.toStringAsFixed(2), 2, styleBold8,
                                align: pw.TextAlign.right),
                          ],
                        );
                      }),

                      // Extra Charges Section with Spacer to push to bottom
                      pw.Expanded(
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                          children: [
                            // CGST/SGST
                            if (isMaharashtra) ...[
                              _buildFlexChargeRow(
                                  '',
                                  'Cgst',
                                  (taxAmount / 2).toStringAsFixed(2),
                                  style8,
                                  styleItalic8),
                              _buildFlexChargeRow(
                                  '',
                                  'Sgst',
                                  (taxAmount / 2).toStringAsFixed(2),
                                  style8,
                                  styleItalic8),
                            ] else
                              _buildFlexChargeRow(
                                  '',
                                  'IGST',
                                  taxAmount.toStringAsFixed(2),
                                  style8,
                                  styleItalic8),

                            // Package Charges
                            if (packingCharge > 0)
                              _buildFlexChargeRow(
                                  '',
                                  'PACKAGE CHARGES',
                                  packingCharge.toStringAsFixed(2),
                                  style8,
                                  styleItalic8),

                            // Delivery Charges
                            if (deliveryCharge > 0)
                              _buildFlexChargeRow(
                                  '',
                                  'delivery_charges',
                                  deliveryCharge.toStringAsFixed(2),
                                  style8,
                                  styleItalic8),

                            // Coupon with "Less :" prefix
                            if (couponDiscount > 0)
                              _buildFlexChargeRow(
                                  'Less :',
                                  'Coupon Exp',
                                  '(-)${couponDiscount.toStringAsFixed(2)}',
                                  style8,
                                  styleItalic8),

                            if (platformFee > 0)
                              _buildFlexChargeRow(
                                  '',
                                  'PLATFORM FEE',
                                  platformFee.toStringAsFixed(2),
                                  style8,
                                  styleItalic8),

                            if (walletUsed > 0)
                              _buildFlexChargeRow(
                                  '',
                                  'Reward Used',
                                  '(-)${walletUsed.toStringAsFixed(2)}',
                                  style8,
                                  styleItalic8),

                            pw.SizedBox(height: 10),
                          ],
                        ),
                      ),

                      // Total Row
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(width: 1)),
                        ),
                        child: pw.Row(
                          children: [
                            _buildFlexTableCell('', 1, style8,
                                borderRight: true),
                            _buildFlexTableCell('', 6, style8,
                                borderRight: true),
                            _buildFlexTableCell('Total', 2, styleBold8,
                                borderRight: true, align: pw.TextAlign.right),
                            _buildFlexTableCell(
                                '${_calculateTotalQuantity(orderDetails, safeParse)} pcs',
                                2,
                                styleBold8,
                                borderRight: true,
                                align: pw.TextAlign.center),
                            _buildFlexTableCell('', 2, style8,
                                borderRight: true),
                            _buildFlexTableCell('', 1, style8,
                                borderRight: true),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                  children: [
                                    pw.Text('₹ ', style: styleBold9),
                                    pw.Text(totalAmount.toStringAsFixed(2),
                                        style: styleBold9),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Amount in words
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(width: 1)),
                        ),
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('Amount Chargeable (in words)',
                                      style: style7),
                                  pw.Text(
                                      'Indian Rupees ${NumberToWords.convert(totalAmount.toInt())} and ${_getPaise(totalAmount)} paise Only',
                                      style: styleBold8),
                                ],
                              ),
                            ),
                            pw.Text('E. & O.E', style: style7),
                          ],
                        ),
                      ),

                      // Tax Summary Table Header
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(width: 1)),
                        ),
                        child: pw.Row(
                          children: [
                            pw.Expanded(
                              flex: 2,
                              child: pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 4),
                                decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                      right: pw.BorderSide(width: 0.5)),
                                ),
                                child: pw.Text('HSN/SAC',
                                    style: style7,
                                    textAlign: pw.TextAlign.center),
                              ),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 4),
                                decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                      right: pw.BorderSide(width: 0.5)),
                                ),
                                child: pw.Text('Taxable\nValue',
                                    style: style7,
                                    textAlign: pw.TextAlign.center),
                              ),
                            ),
                            pw.Expanded(
                              flex: 3,
                              child: pw.Container(
                                decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                      right: pw.BorderSide(width: 0.5)),
                                ),
                                child: pw.Column(
                                  children: [
                                    pw.Container(
                                      padding: const pw.EdgeInsets.all(2),
                                      decoration: const pw.BoxDecoration(
                                        border: pw.Border(
                                            bottom: pw.BorderSide(width: 0.5)),
                                      ),
                                      child: pw.Text('CGST',
                                          style: style7,
                                          textAlign: pw.TextAlign.center),
                                    ),
                                    pw.Row(
                                      children: [
                                        pw.Expanded(
                                          child: pw.Container(
                                            padding: const pw.EdgeInsets.all(2),
                                            decoration: const pw.BoxDecoration(
                                              border: pw.Border(
                                                  right: pw.BorderSide(
                                                      width: 0.5)),
                                            ),
                                            child: pw.Text('Rate',
                                                style: style7,
                                                textAlign: pw.TextAlign.center),
                                          ),
                                        ),
                                        pw.Expanded(
                                          child: pw.Container(
                                            padding: const pw.EdgeInsets.all(2),
                                            child: pw.Text('Amount',
                                                style: style7,
                                                textAlign: pw.TextAlign.center),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 3,
                              child: pw.Container(
                                decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                      right: pw.BorderSide(width: 0.5)),
                                ),
                                child: pw.Column(
                                  children: [
                                    pw.Container(
                                      padding: const pw.EdgeInsets.all(2),
                                      decoration: const pw.BoxDecoration(
                                        border: pw.Border(
                                            bottom: pw.BorderSide(width: 0.5)),
                                      ),
                                      child: pw.Text('SGST/UTGST',
                                          style: style7,
                                          textAlign: pw.TextAlign.center),
                                    ),
                                    pw.Row(
                                      children: [
                                        pw.Expanded(
                                          child: pw.Container(
                                            padding: const pw.EdgeInsets.all(2),
                                            decoration: const pw.BoxDecoration(
                                              border: pw.Border(
                                                  right: pw.BorderSide(
                                                      width: 0.5)),
                                            ),
                                            child: pw.Text('Rate',
                                                style: style7,
                                                textAlign: pw.TextAlign.center),
                                          ),
                                        ),
                                        pw.Expanded(
                                          child: pw.Container(
                                            padding: const pw.EdgeInsets.all(2),
                                            child: pw.Text('Amount',
                                                style: style7,
                                                textAlign: pw.TextAlign.center),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 4),
                                child: pw.Text('Total\nTax Amount',
                                    style: style7,
                                    textAlign: pw.TextAlign.center),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tax Summary Data Row
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(width: 0.5)),
                        ),
                        child: pw.Row(
                          children: [
                            _buildFlexTaxDataCell('', 2, style8,
                                borderRight: true, align: pw.TextAlign.center),
                            _buildFlexTaxDataCell(
                                taxableValue.toStringAsFixed(2), 2, style8,
                                borderRight: true, align: pw.TextAlign.right),
                            _buildFlexTaxDataCell('2.50%', 1, style8,
                                borderRight: true, align: pw.TextAlign.center),
                            _buildFlexTaxDataCell(
                                (taxAmount / 2).toStringAsFixed(2), 2, style8,
                                borderRight: true, align: pw.TextAlign.right),
                            _buildFlexTaxDataCell('2.50%', 1, style8,
                                borderRight: true, align: pw.TextAlign.center),
                            _buildFlexTaxDataCell(
                                (taxAmount / 2).toStringAsFixed(2), 2, style8,
                                borderRight: true, align: pw.TextAlign.right),
                            _buildFlexTaxDataCell(
                                taxAmount.toStringAsFixed(2), 2, style8,
                                align: pw.TextAlign.right),
                          ],
                        ),
                      ),

                      // Tax Total Row
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(width: 0.5)),
                        ),
                        child: pw.Row(
                          children: [
                            _buildFlexTaxDataCell('Total', 2, styleBold8,
                                borderRight: true, align: pw.TextAlign.right),
                            _buildFlexTaxDataCell(
                                taxableValue.toStringAsFixed(2), 2, styleBold8,
                                borderRight: true, align: pw.TextAlign.right),
                            _buildFlexTaxDataCell('', 1, style8,
                                borderRight: true),
                            _buildFlexTaxDataCell(
                                (taxAmount / 2).toStringAsFixed(2),
                                2,
                                styleBold8,
                                borderRight: true,
                                align: pw.TextAlign.right),
                            _buildFlexTaxDataCell('', 1, style8,
                                borderRight: true),
                            _buildFlexTaxDataCell(
                                (taxAmount / 2).toStringAsFixed(2),
                                2,
                                styleBold8,
                                borderRight: true,
                                align: pw.TextAlign.right),
                            _buildFlexTaxDataCell(
                                taxAmount.toStringAsFixed(2), 2, styleBold8,
                                align: pw.TextAlign.right),
                          ],
                        ),
                      ),

                      // Tax Amount in words
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(width: 1)),
                        ),
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          'Tax Amount (in words)  :   Indian Rupees ${NumberToWords.convert(taxAmount.toInt())} and ${_getPaise(taxAmount)} paise Only',
                          style: style8,
                        ),
                      ),

                      // Footer with PAN and Declaration
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(width: 1)),
                        ),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                              child: pw.Container(
                                padding: const pw.EdgeInsets.all(4),
                                decoration: const pw.BoxDecoration(
                                  border:
                                      pw.Border(right: pw.BorderSide(width: 1)),
                                ),
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.RichText(
                                      text: pw.TextSpan(
                                        children: [
                                          pw.TextSpan(
                                              text: "Company's PAN",
                                              style: style7),
                                          pw.TextSpan(
                                              text: '     :  ', style: style7),
                                          pw.TextSpan(
                                              text: 'AAKPF0827G',
                                              style: styleBold8),
                                        ],
                                      ),
                                    ),
                                    pw.SizedBox(height: 8),
                                    pw.Text('Declaration',
                                        style: pw.TextStyle(
                                            fontSize: 7,
                                            decoration:
                                                pw.TextDecoration.underline)),
                                    pw.Text(
                                      'We declare that this invoice shows the actual price of the\ngoods described and that all particulars are true and correct.',
                                      style: style7,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  children: [
                                    pw.Text('for Raza Trading Co.',
                                        style: styleBold8),
                                    pw.SizedBox(height: 30),
                                    pw.Text('Authorised Signatory',
                                        style: style7),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer text below the box
              pw.SizedBox(height: 4),
              pw.Center(
                  child: pw.Text('SUBJECT TO BHIWANDI JURISDICTION',
                      style: style7)),
              pw.SizedBox(height: 2),
              pw.Center(
                  child: pw.Text('This is a Computer Generated Invoice',
                      style: style7)),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // Helper function to build invoice header row
  pw.Widget _buildInvoiceHeaderRow(String label1, String val1, String label2,
      String val2, pw.TextStyle style) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(width: 0.5)),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(2),
              decoration: const pw.BoxDecoration(
                border: pw.Border(right: pw.BorderSide(width: 0.5)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text(label1, style: style),
                  if (val1.isNotEmpty)
                    pw.Text(val1,
                        style: style.copyWith(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(2),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  if (label2.isNotEmpty) pw.Text(label2, style: style),
                  if (val2.isNotEmpty)
                    pw.Text(val2,
                        style: style.copyWith(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build flexible table header cell
  pw.Widget _buildFlexTableHeaderCell(String text, int flex, pw.TextStyle style,
      {bool borderRight = false}) {
    return pw.Expanded(
      flex: flex,
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        decoration: borderRight
            ? const pw.BoxDecoration(
                border: pw.Border(right: pw.BorderSide(width: 0.5)))
            : null,
        child: pw.Text(text, style: style, textAlign: pw.TextAlign.center),
      ),
    );
  }

  // Helper function to build flexible table cell
  pw.Widget _buildFlexTableCell(String text, int flex, pw.TextStyle style,
      {bool borderRight = false, pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Expanded(
      flex: flex,
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: borderRight
            ? const pw.BoxDecoration(
                border: pw.Border(right: pw.BorderSide(width: 0.5)))
            : null,
        child: pw.Text(text, style: style, textAlign: align),
      ),
    );
  }

  // Helper function to build flexible charge row
  pw.Widget _buildFlexChargeRow(String prefix, String label, String value,
      pw.TextStyle style, pw.TextStyle labelStyle) {
    return pw.Row(
      children: [
        pw.Expanded(flex: 1, child: pw.Text('', style: style)),
        pw.Expanded(
          flex: 6,
          child: pw.Row(
            children: [
              if (prefix.isNotEmpty) pw.Text(prefix, style: style),
              pw.SizedBox(width: 4),
            ],
          ),
        ),
        pw.Expanded(flex: 2, child: pw.Container()),
        pw.Expanded(flex: 2, child: pw.Container()),
        pw.Expanded(
          flex: 3,
          child:
              pw.Text(label, style: labelStyle, textAlign: pw.TextAlign.right),
        ),
        pw.Expanded(flex: 1, child: pw.Container()),
        pw.Expanded(
          flex: 2,
          child: pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 2),
            child: pw.Text(value, style: style, textAlign: pw.TextAlign.right),
          ),
        ),
      ],
    );
  }

  // Helper function to build flexible tax data cell
  pw.Widget _buildFlexTaxDataCell(String text, int flex, pw.TextStyle style,
      {bool borderRight = false, pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Expanded(
      flex: flex,
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: borderRight
            ? const pw.BoxDecoration(
                border: pw.Border(right: pw.BorderSide(width: 0.5)))
            : null,
        child: pw.Text(text, style: style, textAlign: align),
      ),
    );
  }

  // Helper function to calculate total quantity
  int _calculateTotalQuantity(
      List<dynamic> orderDetails, double Function(dynamic) safeParse) {
    int total = 0;
    for (var item in orderDetails) {
      total += safeParse(item['quantity']).toInt();
    }
    return total;
  }

  // Helper function to get paise from amount
  String _getPaise(double amount) {
    int paise = ((amount - amount.toInt()) * 100).round();
    return paise.toString().padLeft(2, '0');
  }
}

// Simple NumberToWords Implementation (Partial/Simplified)
class NumberToWords {
  static final _units = [
    '',
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten',
    'Eleven',
    'Twelve',
    'Thirteen',
    'Fourteen',
    'Fifteen',
    'Sixteen',
    'Seventeen',
    'Eighteen',
    'Nineteen'
  ];
  static final _tens = [
    '',
    '',
    'Twenty',
    'Thirty',
    'Forty',
    'Fifty',
    'Sixty',
    'Seventy',
    'Eighty',
    'Ninety'
  ];

  static String convert(int num) {
    if (num == 0) return 'Zero';
    return _convert(num);
  }

  static String _convert(int num) {
    if (num < 20) return _units[num];
    if (num < 100) {
      return _tens[num ~/ 10] + (num % 10 != 0 ? ' ${_units[num % 10]}' : '');
    }
    if (num < 1000) {
      return '${_units[num ~/ 100]} Hundred${num % 100 != 0 ? ' and ${_convert(num % 100)}' : ''}';
    }
    if (num < 100000) {
      return '${_convert(num ~/ 1000)} Thousand${num % 1000 != 0 ? ' ${_convert(num % 1000)}' : ''}';
    }
    if (num < 10000000) {
      return '${_convert(num ~/ 100000)} Lakh${num % 100000 != 0 ? ' ${_convert(num % 100000)}' : ''}';
    }
    return '${_convert(num ~/ 10000000)} Crore${num % 10000000 != 0 ? ' ${_convert(num % 10000000)}' : ''}';
  }
}
