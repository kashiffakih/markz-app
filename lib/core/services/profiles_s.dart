import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sales_app/core/models/profile.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:http/http.dart' as http;

class ProfilesService {
  final ConfigModel _configModel = locator<ConfigModel>();

  // Get Profiles
  late List<Profile> _profiles;

  getProfiles() async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    int userId = _configModel.user.id!;

    http.Response _response = await http.get(
      Uri.parse('${_apiConfig['baseURL']}/profiles?userId=$userId'),
      headers: _apiConfig['headers'],
    );

    Map<String, dynamic> _responseData = json.decode(_response.body);
    if (_responseData['success']) {
      _profiles = [];
      _responseData['data'].forEach((_notice) {
        _profiles.add(Profile.fromJson(_notice));
      });
    }

    return _profiles;
  }

  profileCreate({@required Profile? profile}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    User user = _configModel.user;

    profile!.userId = user.id;
    profile.isActive = 1;
    profile.isDeleted = 0;

    if (profile.id == null) {
      if (_configModel.file.file != null) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${_apiConfig['baseURL']}/profiles'),
        )
          ..fields['date'] = profile.date.toString()
          ..fields['user_id'] = profile.userId.toString()
          ..fields['visit_call'] = profile.visitCall.toString()
          ..fields['mark_in_lat'] =
              profile.markInLat != null ? profile.markInLat.toString() : ''
          ..fields['mark_in_lng'] =
              profile.markInLng != null ? profile.markInLng.toString() : ''
          ..fields['mark_out_lat'] =
              profile.markOutLat != null ? profile.markOutLat.toString() : ''
          ..fields['mark_out_lng'] =
              profile.markOutLng != null ? profile.markOutLng.toString() : ''
          ..fields['mobile_1'] = profile.mobile1.toString()
          ..fields['email_1'] = profile.email1.toString()
          ..fields['company_name'] = profile.companyName.toString()
          ..fields['industry'] =
              profile.industry != null ? profile.industry.toString() : ''
          ..fields['employee_size'] = profile.employeeSize.toString()
          ..fields['turnover'] = profile.turnover.toString()
          ..fields['head_office'] = profile.headOffice.toString()
          ..fields['address'] = profile.address.toString()
          ..fields['website'] = profile.website.toString()
          ..fields['contact_1_name'] = profile.contact1Name.toString()
          ..fields['contact_1_mobile'] = profile.contact1Mobile.toString()
          ..fields['contact_1_email'] = profile.contact1Email.toString()
          ..fields['contact_2_name'] = profile.contact2Name.toString()
          ..fields['contact_2_mobile'] = profile.contact2Mobile.toString()
          ..fields['contact_2_email'] = profile.contact2Email.toString()
          ..fields['contact_3_name'] = profile.contact3Name.toString()
          ..fields['contact_3_mobile'] = profile.contact3Mobile.toString()
          ..fields['contact_3_email'] = profile.contact3Email.toString()
          ..fields['contact_4_name'] = profile.contact4Name.toString()
          ..fields['contact_4_mobile'] = profile.contact4Mobile.toString()
          ..fields['contact_4_email'] = profile.contact4Email.toString()
          ..fields['contact_5_name'] = profile.contact5Name.toString()
          ..fields['contact_5_mobile'] = profile.contact5Mobile.toString()
          ..fields['contact_5_email'] = profile.contact5Email.toString()
          ..fields['product_offered'] = profile.productOffered != null
              ? profile.productOffered.toString()
              : ''
          ..fields['service_fees'] = profile.serviceFees ?? ''
          ..fields['recruitment_fees'] = profile.recruitmentFees ?? ''
          ..fields['recruitment_fees'] = profile.onboardingFees ?? ''
          ..fields['service_fee_on_reimbursements'] =
              profile.serviceFeeOnReimbursements ?? ''
          ..fields['service_fee_on_incentive'] =
              profile.serviceFeeOnIncentive ?? ''
          ..fields['service_fee_on_ad_hoc'] = profile.serviceFeeOnAdHoc ?? ''
          ..fields['absorption_fee'] = profile.absorptionFee ?? ''
          ..fields['agency_fee_for_junior_level'] =
              profile.agencyFeeForJuniorLevel ?? ''
          ..fields['agency_fee_for_middle_level'] =
              profile.agencyFeeForMiddleLevel ?? ''
          ..fields['agency_fee_for_senior_level'] =
              profile.agencyFeeForSeniorLevel ?? ''
          ..fields['hajiri_per_user_per_month'] =
              profile.hajiriPerUserPerMonth ?? ''
          ..fields['dastavej_per_user_per_month'] =
              profile.dastavejPerUserPerMonth ?? ''
          ..fields['sales_per_user_per_month'] =
              profile.salesPerUserPerMonth ?? ''
          ..fields['merchandising_per_user_per_month'] =
              profile.merchandisingPerUserPerMonth ?? ''
          ..fields['terms'] = profile.terms.toString()
          ..fields['remarks'] = profile.remarks.toString()
          ..fields['deal_date'] =
              profile.dealDate != null ? profile.dealDate.toString() : ''
          ..fields['agreement_date'] = profile.agreementDate != null
              ? profile.agreementDate.toString()
              : ''
          ..fields['next_meeting_date'] = profile.nextMeetingDate != null
              ? profile.nextMeetingDate.toString()
              : ''
          ..fields['filename'] = _configModel.file.fileName ?? ''
          ..files.add(await http.MultipartFile.fromPath(
              'photoPath', _configModel.file.file.toString()))
          ..headers.addAll(_apiConfig['headers']);
        http.StreamedResponse _response = await request.send();
        var response = await http.Response.fromStream(_response);
        Map<String, dynamic> _responseData = json.decode(response.body);
        // _configModel.file = null;
      } else {
        http.Response _response = await http.post(
          Uri.parse('${_apiConfig['baseURL']}/profiles'),
          body: json.encode(profile.toJson()),
          headers: _apiConfig['headers'],
        );
        Map<String, dynamic> _responseData = json.decode(_response.body);
      }
    } else {
      if (_configModel.file.file != null) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${_apiConfig['baseURL']}/profiles'),
        )
          ..fields['id'] = profile.id.toString()
          ..fields['date'] = profile.date.toString()
          ..fields['user_id'] = profile.userId.toString()
          ..fields['visit_call'] = profile.visitCall.toString()
          ..fields['mark_in_lat'] =
              profile.markInLat != null ? profile.markInLat.toString() : ''
          ..fields['mark_in_lng'] =
              profile.markInLng != null ? profile.markInLng.toString() : ''
          ..fields['mark_out_lat'] =
              profile.markOutLat != null ? profile.markOutLat.toString() : ''
          ..fields['mark_out_lng'] =
              profile.markOutLng != null ? profile.markOutLng.toString() : ''
          ..fields['mobile_1'] = profile.mobile1.toString()
          ..fields['email_1'] = profile.email1.toString()
          ..fields['company_name'] = profile.companyName.toString()
          ..fields['industry'] =
              profile.industry != null ? profile.industry.toString() : ''
          ..fields['employee_size'] = profile.employeeSize.toString()
          ..fields['turnover'] = profile.turnover.toString()
          ..fields['head_office'] = profile.headOffice.toString()
          ..fields['address'] = profile.address.toString()
          ..fields['website'] = profile.website.toString()
          ..fields['contact_1_name'] = profile.contact1Name.toString()
          ..fields['contact_1_mobile'] = profile.contact1Mobile.toString()
          ..fields['contact_1_email'] = profile.contact1Email.toString()
          ..fields['contact_2_name'] = profile.contact2Name.toString()
          ..fields['contact_2_mobile'] = profile.contact2Mobile.toString()
          ..fields['contact_2_email'] = profile.contact2Email.toString()
          ..fields['contact_3_name'] = profile.contact3Name.toString()
          ..fields['contact_3_mobile'] = profile.contact3Mobile.toString()
          ..fields['contact_3_email'] = profile.contact3Email.toString()
          ..fields['contact_4_name'] = profile.contact4Name.toString()
          ..fields['contact_4_mobile'] = profile.contact4Mobile.toString()
          ..fields['contact_4_email'] = profile.contact4Email.toString()
          ..fields['contact_5_name'] = profile.contact5Name.toString()
          ..fields['contact_5_mobile'] = profile.contact5Mobile.toString()
          ..fields['contact_5_email'] = profile.contact5Email.toString()
          ..fields['product_offered'] = profile.productOffered != null
              ? profile.productOffered.toString()
              : ''
          ..fields['service_fees'] = profile.serviceFees ?? ''
          ..fields['recruitment_fees'] = profile.recruitmentFees ?? ''
          ..fields['recruitment_fees'] = profile.onboardingFees ?? ''
          ..fields['service_fee_on_reimbursements'] =
              profile.serviceFeeOnReimbursements ?? ''
          ..fields['service_fee_on_incentive'] =
              profile.serviceFeeOnIncentive ?? ''
          ..fields['service_fee_on_ad_hoc'] = profile.serviceFeeOnAdHoc ?? ''
          ..fields['absorption_fee'] = profile.absorptionFee ?? ''
          ..fields['agency_fee_for_junior_level'] =
              profile.agencyFeeForJuniorLevel ?? ''
          ..fields['agency_fee_for_middle_level'] =
              profile.agencyFeeForMiddleLevel ?? ''
          ..fields['agency_fee_for_senior_level'] =
              profile.agencyFeeForSeniorLevel ?? ''
          ..fields['hajiri_per_user_per_month'] =
              profile.hajiriPerUserPerMonth ?? ''
          ..fields['dastavej_per_user_per_month'] =
              profile.dastavejPerUserPerMonth ?? ''
          ..fields['sales_per_user_per_month'] =
              profile.salesPerUserPerMonth ?? ''
          ..fields['merchandising_per_user_per_month'] =
              profile.merchandisingPerUserPerMonth ?? ''
          ..fields['terms'] = profile.terms.toString()
          ..fields['remarks'] = profile.remarks.toString()
          ..fields['deal_date'] =
              profile.dealDate != null ? profile.dealDate.toString() : ''
          ..fields['agreement_date'] = profile.agreementDate != null
              ? profile.agreementDate.toString()
              : ''
          ..fields['next_meeting_date'] = profile.nextMeetingDate != null
              ? profile.nextMeetingDate.toString()
              : ''
          ..fields['filename'] = _configModel.file.fileName ?? ''
          ..files.add(await http.MultipartFile.fromPath(
              'photoPath', _configModel.file.file.toString()))
          ..headers.addAll(_apiConfig['headers']);
        http.StreamedResponse _response = await request.send();
        http.Response response = await http.Response.fromStream(_response);
        Map<String, dynamic> _responseData = json.decode(response.body);
        print(_responseData);
        // _configModel.file = null;
      } else {
        http.Response _response = await http.patch(
          Uri.parse('${_apiConfig['baseURL']}/profiles/${profile.id}'),
          body: json.encode(profile.toJson()),
          headers: _apiConfig['headers'],
        );
        Map<String, dynamic> _responseData = json.decode(_response.body);
      }
    }
  }

  profileFollowupCreate(
      {@required Profile? profile,
      @required ProfileFollowUps? profileFollowup}) async {
    Map<String, dynamic> _apiConfig = _configModel.apiConfig;

    User user = _configModel.user;

    profileFollowup!.userId = user.id;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${_apiConfig['baseURL']}/profile_follow_ups'),
    )
      ..fields['user_id'] = profileFollowup.userId.toString()
      ..fields['profile_id'] = profile!.id.toString()
      ..fields['remarks'] = profileFollowup.remarks ?? ''
      ..fields['next_meeting_date'] = profileFollowup.nextMeetingDate ?? ''
      // ..fields['filename'] = _configModel.file.fileName ?? ''
      // ..files.add(
      //   await http.MultipartFile.fromPath(
      //     'imagepath',
      //     _configModel.file.file.toString(),
      //   ),
      // )
      ..headers.addAll(_apiConfig['headers']);
    http.StreamedResponse _response = await request.send();
    var response = await http.Response.fromStream(_response);

    // _configModel.file = null;
  }
}
