class Profile {
  int? id;
  int? companyId;
  int? userId;
  String? visitCall;
  String? markInLat;
  String? markInLng;
  String? markOutLat;
  String? markOutLng;
  String? date;
  var mobile1;
  String? email1;
  String? photo1Path;
  String? companyName;
  String? industry;
  int? employeeSize;
  String? turnover;
  String? headOffice;
  String? address;
  String? website;
  int? contact1Mobile;
  String? contact1Email;
  int? contact2Mobile;
  String? contact2Email;
  String? contact1Name;
  String? contact2Name;
  String? productOffered;
  String? dealDate;
  String? agreementDate;
  String? terms;
  String? remarks;
  String? nextMeetingDate;
  int? isActive;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? serviceFees;
  String? recruitmentFees;
  String? onboardingFees;
  String? serviceFeeOnReimbursements;
  String? serviceFeeOnIncentive;
  String? serviceFeeOnAdHoc;
  String? absorptionFee;
  String? agencyFeeForJuniorLevel;
  String? agencyFeeForMiddleLevel;
  String? agencyFeeForSeniorLevel;
  String? hajiriPerUserPerMonth;
  String? dastavejPerUserPerMonth;
  String? salesPerUserPerMonth;
  String? merchandisingPerUserPerMonth;
  String? markInAddress;
  String? markOutAddress;
  String? status;
  String? contact3Name;
  String? contact3Mobile;
  String? contact3Email;
  String? contact4Name;
  String? contact4Mobile;
  String? contact4Email;
  String? contact5Name;
  String? contact5Mobile;
  String? contact5Email;
  String? contact1VisitingCard;
  String? contact2VisitingCard;
  String? contact3VisitingCard;
  String? contact4VisitingCard;
  String? contact5VisitingCard;
  List<ProfileFollowUps>? profileFollowUps;

  Profile(
      {this.id,
      this.companyId,
      this.userId,
      this.visitCall,
      this.markInLat,
      this.markInLng,
      this.markOutLat,
      this.markOutLng,
      this.date,
      this.mobile1,
      this.email1,
      this.photo1Path,
      this.companyName,
      this.industry,
      this.employeeSize,
      this.turnover,
      this.headOffice,
      this.address,
      this.website,
      this.contact1Mobile,
      this.contact1Email,
      this.contact2Mobile,
      this.contact2Email,
      this.contact1Name,
      this.contact2Name,
      this.productOffered,
      this.dealDate,
      this.agreementDate,
      this.terms,
      this.remarks,
      this.nextMeetingDate,
      this.isActive,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.serviceFees,
      this.recruitmentFees,
      this.onboardingFees,
      this.serviceFeeOnReimbursements,
      this.serviceFeeOnIncentive,
      this.serviceFeeOnAdHoc,
      this.absorptionFee,
      this.agencyFeeForJuniorLevel,
      this.agencyFeeForMiddleLevel,
      this.agencyFeeForSeniorLevel,
      this.hajiriPerUserPerMonth,
      this.dastavejPerUserPerMonth,
      this.salesPerUserPerMonth,
      this.merchandisingPerUserPerMonth,
      this.markInAddress,
      this.markOutAddress,
      this.status,
      this.contact3Name,
      this.contact3Mobile,
      this.contact3Email,
      this.contact4Name,
      this.contact4Mobile,
      this.contact4Email,
      this.contact5Name,
      this.contact5Mobile,
      this.contact5Email,
      this.contact1VisitingCard,
      this.contact2VisitingCard,
      this.contact3VisitingCard,
      this.contact4VisitingCard,
      this.contact5VisitingCard,
      this.profileFollowUps});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    visitCall = json['visit_call'];
    markInLat = json['mark_in_lat'];
    markInLng = json['mark_in_lng'];
    markOutLat = json['mark_out_lat'];
    markOutLng = json['mark_out_lng'];
    date = json['date'];
    mobile1 = json['mobile_1'];
    email1 = json['email_1'];
    photo1Path = json['photo_1_path'];
    companyName = json['company_name'];
    industry = json['industry'];
    employeeSize = json['employee_size'];
    turnover = json['turnover'];
    headOffice = json['head_office'];
    address = json['address'];
    website = json['website'];
    contact1Mobile = json['contact_1_mobile'];
    contact1Email = json['contact_1_email'];
    contact2Mobile = json['contact_2_mobile'];
    contact2Email = json['contact_2_email'];
    contact1Name = json['contact_1_name'];
    contact2Name = json['contact_2_name'];
    productOffered = json['product_offered'];
    dealDate = json['deal_date'];
    agreementDate = json['agreement_date'];
    terms = json['terms'];
    remarks = json['remarks'];
    nextMeetingDate = json['next_meeting_date'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    serviceFees = json['service_fees'];
    recruitmentFees = json['recruitment_fees'];
    onboardingFees = json['onboarding_fees'];
    serviceFeeOnReimbursements = json['service_fee_on_reimbursements'];
    serviceFeeOnIncentive = json['service_fee_on_incentive'];
    serviceFeeOnAdHoc = json['service_fee_on_ad_hoc'];
    absorptionFee = json['absorption_fee'];
    agencyFeeForJuniorLevel = json['agency_fee_for_junior_level'];
    agencyFeeForMiddleLevel = json['agency_fee_for_middle_level'];
    agencyFeeForSeniorLevel = json['agency_fee_for_senior_level'];
    hajiriPerUserPerMonth = json['hajiri_per_user_per_month'];
    dastavejPerUserPerMonth = json['dastavej_per_user_per_month'];
    salesPerUserPerMonth = json['sales_per_user_per_month'];
    merchandisingPerUserPerMonth = json['merchandising_per_user_per_month'];
    markInAddress = json['mark_in_address'];
    markOutAddress = json['mark_out_address'];
    status = json['status'];
    contact3Name = json['contact_3_name'];
    contact3Mobile = json['contact_3_mobile'];
    contact3Email = json['contact_3_email'];
    contact4Name = json['contact_4_name'];
    contact4Mobile = json['contact_4_mobile'];
    contact4Email = json['contact_4_email'];
    contact5Name = json['contact_5_name'];
    contact5Mobile = json['contact_5_mobile'];
    contact5Email = json['contact_5_email'];
    contact1VisitingCard = json['contact_1_visiting_card'];
    contact2VisitingCard = json['contact_2_visiting_card'];
    contact3VisitingCard = json['contact_3_visiting_card'];
    contact4VisitingCard = json['contact_4_visiting_card'];
    contact5VisitingCard = json['contact_5_visiting_card'];
    if (json['profile_follow_ups'] != null) {
      profileFollowUps = <ProfileFollowUps>[];
      json['profile_follow_ups'].forEach((v) {
        profileFollowUps!.add(new ProfileFollowUps.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['visit_call'] = this.visitCall;
    data['mark_in_lat'] = this.markInLat;
    data['mark_in_lng'] = this.markInLng;
    data['mark_out_lat'] = this.markOutLat;
    data['mark_out_lng'] = this.markOutLng;
    data['date'] = this.date;
    data['mobile_1'] = this.mobile1;
    data['email_1'] = this.email1;
    data['photo_1_path'] = this.photo1Path;
    data['company_name'] = this.companyName;
    data['industry'] = this.industry;
    data['employee_size'] = this.employeeSize;
    data['turnover'] = this.turnover;
    data['head_office'] = this.headOffice;
    data['address'] = this.address;
    data['website'] = this.website;
    data['contact_1_mobile'] = this.contact1Mobile;
    data['contact_1_email'] = this.contact1Email;
    data['contact_2_mobile'] = this.contact2Mobile;
    data['contact_2_email'] = this.contact2Email;
    data['contact_1_name'] = this.contact1Name;
    data['contact_2_name'] = this.contact2Name;
    data['product_offered'] = this.productOffered;
    data['deal_date'] = this.dealDate;
    data['agreement_date'] = this.agreementDate;
    data['terms'] = this.terms;
    data['remarks'] = this.remarks;
    data['next_meeting_date'] = this.nextMeetingDate;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['service_fees'] = this.serviceFees;
    data['recruitment_fees'] = this.recruitmentFees;
    data['onboarding_fees'] = this.onboardingFees;
    data['service_fee_on_reimbursements'] = this.serviceFeeOnReimbursements;
    data['service_fee_on_incentive'] = this.serviceFeeOnIncentive;
    data['service_fee_on_ad_hoc'] = this.serviceFeeOnAdHoc;
    data['absorption_fee'] = this.absorptionFee;
    data['agency_fee_for_junior_level'] = this.agencyFeeForJuniorLevel;
    data['agency_fee_for_middle_level'] = this.agencyFeeForMiddleLevel;
    data['agency_fee_for_senior_level'] = this.agencyFeeForSeniorLevel;
    data['hajiri_per_user_per_month'] = this.hajiriPerUserPerMonth;
    data['dastavej_per_user_per_month'] = this.dastavejPerUserPerMonth;
    data['sales_per_user_per_month'] = this.salesPerUserPerMonth;
    data['merchandising_per_user_per_month'] =
        this.merchandisingPerUserPerMonth;
    data['mark_in_address'] = this.markInAddress;
    data['mark_out_address'] = this.markOutAddress;
    data['status'] = this.status;
    data['contact_3_name'] = this.contact3Name;
    data['contact_3_mobile'] = this.contact3Mobile;
    data['contact_3_email'] = this.contact3Email;
    data['contact_4_name'] = this.contact4Name;
    data['contact_4_mobile'] = this.contact4Mobile;
    data['contact_4_email'] = this.contact4Email;
    data['contact_5_name'] = this.contact5Name;
    data['contact_5_mobile'] = this.contact5Mobile;
    data['contact_5_email'] = this.contact5Email;
    data['contact_1_visiting_card'] = this.contact1VisitingCard;
    data['contact_2_visiting_card'] = this.contact2VisitingCard;
    data['contact_3_visiting_card'] = this.contact3VisitingCard;
    data['contact_4_visiting_card'] = this.contact4VisitingCard;
    data['contact_5_visiting_card'] = this.contact5VisitingCard;
    if (this.profileFollowUps != null) {
      data['profile_follow_ups'] =
          this.profileFollowUps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfileFollowUps {
  int? id;
  int? companyId;
  int? userId;
  int? profileId;
  String? remarks;
  String? nextMeetingDate;
  String? visitCall;
  String? markInAddress;
  String? markOutAddress;
  String? markInLat;
  String? markInLng;
  String? markOutLat;
  String? markOutLng;
  String? status;
  String? meetingType;
  int? isActive;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;

  ProfileFollowUps(
      {this.id,
      this.companyId,
      this.userId,
      this.profileId,
      this.remarks,
      this.nextMeetingDate,
      this.visitCall,
      this.markInAddress,
      this.markOutAddress,
      this.markInLat,
      this.markInLng,
      this.markOutLat,
      this.markOutLng,
      this.status,
      this.meetingType,
      this.isActive,
      this.isDeleted,
      this.createdAt,
      this.updatedAt});

  ProfileFollowUps.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    profileId = json['profile_id'];
    remarks = json['remarks'];
    nextMeetingDate = json['next_meeting_date'];
    visitCall = json['visit_call'];
    markInAddress = json['mark_in_address'];
    markOutAddress = json['mark_out_address'];
    markInLat = json['mark_in_lat'];
    markInLng = json['mark_in_lng'];
    markOutLat = json['mark_out_lat'];
    markOutLng = json['mark_out_lng'];
    status = json['status'];
    meetingType = json['meeting_type'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['profile_id'] = this.profileId;
    data['remarks'] = this.remarks;
    data['next_meeting_date'] = this.nextMeetingDate;
    data['visit_call'] = this.visitCall;
    data['mark_in_address'] = this.markInAddress;
    data['mark_out_address'] = this.markOutAddress;
    data['mark_in_lat'] = this.markInLat;
    data['mark_in_lng'] = this.markInLng;
    data['mark_out_lat'] = this.markOutLat;
    data['mark_out_lng'] = this.markOutLng;
    data['status'] = this.status;
    data['meeting_type'] = this.meetingType;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
