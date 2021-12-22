import 'package:flutter/material.dart';
import 'package:sales_app/core/models/competitor_data.dart';
import 'package:sales_app/core/models/customer.dart';
import 'package:sales_app/core/services/competitor_data_s.dart';
import 'package:sales_app/locator.dart';

class CompetitorDataModel with ChangeNotifier {
  final CompetitorDataService _competitorDataService =
      locator<CompetitorDataService>();

  bool competitorDatasLoader = true;

  List<CompetitorData> _competitorDatas = [];
  set competitotDatas(List<CompetitorData> newCustomers) {
    _competitorDatas = newCustomers;
    competitorDatasLoader = false;
    notifyListeners();
  }

  List<CompetitorData> get competitotDatas => _competitorDatas;

  getCompetitorDatas() async {
    competitotDatas = await _competitorDataService.getCompetitorDatas();
  }

  Future<void> competitorDataCreate(
      {@required CompetitorData? competitorData}) async {
    await _competitorDataService.competitorDataCreate(
        competitorData: competitorData);
  }
}
