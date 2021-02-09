import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/notice_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/images_sh.dart';

class NotificationsPage extends StatelessWidget {
  final ConfigModel _configModel = locator<ConfigModel>();

  @override
  Widget build(BuildContext context) {
    final _noticeModel = Provider.of<NoticeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _noticeModel.notices == null
              ? CircularProgressIndicator()
              : Column(
                  children: _noticeModel.notices
                      .map(
                        (_notice) => Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      if (_notice.imagepath != null)
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: CircleAvatar(
                                            radius: 32,
                                            backgroundImage:
                                                _notice.imagepath == null
                                                    ? AssetImage(Images.product)
                                                    : NetworkImage(
                                                        _configModel.apiConfig[
                                                                'mediaURL'] +
                                                            _notice.imagepath,
                                                      ),
                                          ),
                                        ),
                                      if (_notice.name != null)
                                        Text(
                                          _notice.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_notice.title),
                                        Text(_notice.description),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      )
                      .toList(),
                ),
        ),
      ),
    );
  }
}
