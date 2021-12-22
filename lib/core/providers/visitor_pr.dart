import 'package:flutter/foundation.dart';
import 'package:sales_app/core/models/visitor.dart';
import 'package:sales_app/core/services/visitor_s.dart';
import 'package:sales_app/locator.dart';

class VisitorModel with ChangeNotifier {
  final VisitorService _visitorService = locator<VisitorService>();

  // Get Visitors
  List<Visitor>? _visitors;

  set visitors(List<Visitor>? newVisitors) {
    _visitors = newVisitors;
    notifyListeners();
  }

  List<Visitor>? get visitors => _visitors;

  getVisitors({@required retailerId}) async {
    visitors = await _visitorService.getVisitors(retailerId: retailerId);
  }

  // Create a visitor
  Future<void> visitorCreate({@required Visitor? visitor}) async {
    await _visitorService.visitorCreate(visitor: visitor);
  }

  // Update a visitor
  late Visitor _visitor;

  set visitor(Visitor newVisitor) {
    _visitor = newVisitor;
    notifyListeners();
  }

  Visitor get visitor => _visitor;

  Future<void> visitorId({@required int? visitorId}) async {
    visitor = await _visitorService.visitorId(
      visitorId: visitorId,
    );
  }

  visitorUpdate({@required Visitor? visitor}) {
    _visitorService.visitorUpdate(visitor: visitor);
  }
}
