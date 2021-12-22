import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/analytics_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:url_launcher/url_launcher.dart';

class InvoiceDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _analyticsModel = Provider.of<AnalyticsModel>(context);
    final _configModel = locator<ConfigModel>();
    DateFormat format = DateFormat('MMMM yy');
    String month = format.format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Details | ' + month),
      ),
      body: _analyticsModel.invoiceDetail == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Card(
                elevation: 10,
                child: Column(
                  children: [
                    Container(
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Invoice No',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Outlet Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Invoice Date',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Total Value',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ..._analyticsModel.invoiceDetail.invoices!
                        .map(
                          (_invoice) => InkWell(
                            onTap: () async {
                              print(_configModel.apiConfig['baseURL']);
                              await launch(_configModel.apiConfig['baseURL'] +
                                  '/orders/generate_invoice?orderId=' +
                                  _invoice.id.toString());
                            },
                            child: Container(
                              decoration: _invoice.status == 1
                                  ? BoxDecoration(
                                      color: Colors.green[300],
                                      border: Border.all(),
                                    )
                                  : BoxDecoration(
                                      color: Colors.red[300],
                                      border: Border.all(),
                                    ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            _invoice.invoiceNo.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            _invoice.outletName.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                              _invoice.invoiceDate.toString()),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child:
                                              Text(_invoice.value.toString()),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  // Divider(),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList()
                  ],
                ),
              ),
            ),
    );
  }
}
