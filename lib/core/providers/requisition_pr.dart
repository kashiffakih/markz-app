import 'package:flutter/material.dart';
import 'package:sales_app/core/models/requisition.dart';
import 'package:sales_app/core/services/requisition_s.dart';
import 'package:sales_app/locator.dart';

class RequisitionModel with ChangeNotifier {
  final RequistionService _requisitionService = locator<RequistionService>();

  // Get Requisitions
  late List<Requisition> _requisitions;

  set requisitions(List<Requisition> newRequisitions) {
    _requisitions = newRequisitions;
    notifyListeners();
  }

  List<Requisition> get requisitions => _requisitions;

  getRequisitions() async {
    requisitions = await _requisitionService.getRequisitions();
    print(requisitions);
  }

  // Create a requisition
  Future<void> requisitionCreate({@required Requisition? requisition}) async {
    await _requisitionService.requisitionCreate(requisition: requisition);
  }

  // Update a requistion
  late Requisition _requisition;

  set requisition(Requisition newRequisition) {
    _requisition = newRequisition;
    notifyListeners();
  }

  Requisition get requisition => _requisition;

  Future<void> requisitionId({@required int? requisitionId}) async {
    requisition = await _requisitionService.requisitionId(
      requisitionId: requisitionId,
    );
  }

  Future<void> requisitionUpdate({@required Requisition? requisition}) async {
    _requisitionService.requisitionUpdate(requisition: requisition);
  }
}
