import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/reference_plan.dart';
import 'package:sales_app/core/providers/asset_pr.dart';
import 'package:sales_app/core/providers/reference_plan_pr.dart';

class AssetsPage extends StatefulWidget {
  final arguments; // beat, outlet

  AssetsPage({@required this.arguments});

  @override
  _AssetsPageState createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  bool isUploadingImage = false;

  @override
  Widget build(BuildContext context) {
    final _assetModel = Provider.of<AssetModel>(context);
    final _referencePlanModel = Provider.of<ReferencePlanModel>(context);

    ReferencePlan _referencePlan = _referencePlanModel.referencePlans
        .firstWhere((_rf) => _rf.id == widget.arguments['beat'].id);

    Retailers _retailer = _referencePlan.retailers!
        .firstWhere((_r) => _r.id == widget.arguments['outlet'].id);

    return Scaffold(
      appBar: AppBar(
        title: Text(_retailer.name! + ' Asset Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
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
                              'Sr. No.',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              'Asset',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              'Status',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              'Description',
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
                  if (_assetModel.assets != null)
                    ..._assetModel.assets
                        .map(
                          (_asset) => Container(
                            decoration:
                                _assetModel.assets.indexOf(_asset) % 2 != 0
                                    ? BoxDecoration(color: Colors.grey[400])
                                    : BoxDecoration(color: Colors.white),
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            (_assetModel.assets
                                                            .indexOf(_asset) +
                                                        1)
                                                    .toString() +
                                                '. ',
                                          ),
                                        ),
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.cyan,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/assetEdit',
                                                  arguments: {
                                                    'beat': _referencePlan,
                                                    'outlet': _retailer,
                                                    'asset': _asset,
                                                  });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      _asset.assetName.toString(),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      _asset.status.toString(),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      _asset.description.toString(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList()
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        child: new Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/assetCreate', arguments: {
            'beat': _referencePlan,
            'outlet': _retailer,
          });
        },
      ),
    );
  }
}
