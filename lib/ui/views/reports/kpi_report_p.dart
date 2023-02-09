import 'package:flutter/material.dart';
import 'package:sales_app/ui/shared/images_sh.dart';

class KpiReportPage extends StatefulWidget {
  const KpiReportPage({Key? key}) : super(key: key);

  @override
  State<KpiReportPage> createState() => _KpiReportPageState();
}

class _KpiReportPageState extends State<KpiReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KPI'),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.backgroundImg),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Card(
                elevation: 20,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text('No of Call Made:'),
                            ),
                            Expanded(
                              child: Text('6'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 20,
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey[400]),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text('No of visits:'),
                            ),
                            Expanded(
                              child: Text('4'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
