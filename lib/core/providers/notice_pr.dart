import 'package:flutter/material.dart';
import 'package:sales_app/core/models/notice.dart';
import 'package:sales_app/core/services/notice_s.dart';
import 'package:sales_app/locator.dart';

class NoticeModel with ChangeNotifier {
  final NoticeService _noticeService = locator<NoticeService>();

  // Day Summary
  List<Notice> _notices;

  set notices(List<Notice> newNotices) {
    _notices = newNotices;
    notifyListeners();
  }

  List<Notice> get notices => _notices;

  getNotices() async {
    notices = await _noticeService.getNotices();
  }
}
