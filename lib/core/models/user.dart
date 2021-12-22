class User {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  int? active;
  int? phone;
  String? apiToken;
  String? doj;
  String? dob;
  String? companyDesignationId;
  String? companyStateBranchId;
  String? pfNo;
  String? uanNo;
  String? esiNo;
  String? createdAt;
  String? updatedAt;
  String? salary;
  String? imagePath;
  String? employeeCode;
  String? asmArea;
  String? asmName;
  String? uidNo;
  String? termsAccepted;
  String? companyStateId;
  String? address;
  String? uniqueId;
  String? appointmentLetter;
  String? contractExpiry;
  String? resumePath;
  String? photoPath;
  String? residentialProofPath;
  String? educationProofPath;
  String? panCardPath;
  String? adhaarCardPath;
  String? esiCardPath;
  String? cancelledChequePath;
  String? salarySlipPath;
  String? birthCertificatePath;
  String? passportPath;
  String? drivingLicensePath;
  String? schoolLeavingCertificatePath;
  String? markSheetPath;
  String? experienceCertificatePath;
  String? prevEmpAppLetterPath;
  String? form2Path;
  String? form11Path;
  String? graduityFormPath;
  String? appLetterPath;
  String? pdsFormPath;
  String? fullName;
  String? fatherName;
  String? surname;
  String? motherName;
  String? maritalStatus;
  String? panNo;
  String? adhaarNo;
  String? preRoomNo;
  String? preBuilding;
  String? preArea;
  String? preRoad;
  String? preCity;
  String? preState;
  String? prePincode;
  String? preMobile;
  String? preEmail;
  String? perRoomNo;
  String? perBuilding;
  String? perArea;
  String? perRoad;
  String? perCity;
  String? perState;
  String? perPincode;
  String? perMobile;
  String? perEmail;
  String? bloodGroup;
  String? bankName;
  String? bankAccNo;
  String? bankIfscCode;
  String? bankBranchName;
  int? dataSubmitted;
  int? isFresher;
  String? pdsFormSignPath;
  String? form2SignPath;
  String? form11SignPath;
  String? graduityFormSignPath;
  String? passwordBackup;
  String? gender;
  int? pdsFormChecked;
  int? form2Checked;
  int? form11Checked;
  int? graduityFormChecked;
  int? beatTypeId;
  int? soId;
  int? asmId;
  int? rmsId;
  int? nsmId;
  int? distributorId;
  String? baName;
  List<Roles>? roles;
  List<Companies>? companies;
  Distributor? distributor;

  User(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.active,
      this.phone,
      this.apiToken,
      this.doj,
      this.dob,
      this.companyDesignationId,
      this.companyStateBranchId,
      this.pfNo,
      this.uanNo,
      this.esiNo,
      this.createdAt,
      this.updatedAt,
      this.salary,
      this.imagePath,
      this.employeeCode,
      this.asmArea,
      this.asmName,
      this.uidNo,
      this.termsAccepted,
      this.companyStateId,
      this.address,
      this.uniqueId,
      this.appointmentLetter,
      this.contractExpiry,
      this.resumePath,
      this.photoPath,
      this.residentialProofPath,
      this.educationProofPath,
      this.panCardPath,
      this.adhaarCardPath,
      this.esiCardPath,
      this.cancelledChequePath,
      this.salarySlipPath,
      this.birthCertificatePath,
      this.passportPath,
      this.drivingLicensePath,
      this.schoolLeavingCertificatePath,
      this.markSheetPath,
      this.experienceCertificatePath,
      this.prevEmpAppLetterPath,
      this.form2Path,
      this.form11Path,
      this.graduityFormPath,
      this.appLetterPath,
      this.pdsFormPath,
      this.fullName,
      this.fatherName,
      this.surname,
      this.motherName,
      this.maritalStatus,
      this.panNo,
      this.adhaarNo,
      this.preRoomNo,
      this.preBuilding,
      this.preArea,
      this.preRoad,
      this.preCity,
      this.preState,
      this.prePincode,
      this.preMobile,
      this.preEmail,
      this.perRoomNo,
      this.perBuilding,
      this.perArea,
      this.perRoad,
      this.perCity,
      this.perState,
      this.perPincode,
      this.perMobile,
      this.perEmail,
      this.bloodGroup,
      this.bankName,
      this.bankAccNo,
      this.bankIfscCode,
      this.bankBranchName,
      this.dataSubmitted,
      this.isFresher,
      this.pdsFormSignPath,
      this.form2SignPath,
      this.form11SignPath,
      this.graduityFormSignPath,
      this.passwordBackup,
      this.gender,
      this.pdsFormChecked,
      this.form2Checked,
      this.form11Checked,
      this.graduityFormChecked,
      this.beatTypeId,
      this.soId,
      this.asmId,
      this.rmsId,
      this.nsmId,
      this.distributorId,
      this.baName,
      this.roles,
      this.companies,
      this.distributor});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    active = json['active'];
    phone = json['phone'];
    apiToken = json['api_token'];
    doj = json['doj'];
    dob = json['dob'];
    companyDesignationId = json['company_designation_id'];
    companyStateBranchId = json['company_state_branch_id'];
    pfNo = json['pf_no'];
    uanNo = json['uan_no'];
    esiNo = json['esi_no'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    salary = json['salary'];
    imagePath = json['image_path'];
    employeeCode = json['employee_code'];
    asmArea = json['asm_area'];
    asmName = json['asm_name'];
    uidNo = json['uid_no'];
    termsAccepted = json['terms_accepted'];
    companyStateId = json['company_state_id'];
    address = json['address'];
    uniqueId = json['unique_id'];
    appointmentLetter = json['appointment_letter'];
    contractExpiry = json['contract_expiry'];
    resumePath = json['resume_path'];
    photoPath = json['photo_path'];
    residentialProofPath = json['residential_proof_path'];
    educationProofPath = json['education_proof_path'];
    panCardPath = json['pan_card_path'];
    adhaarCardPath = json['adhaar_card_path'];
    esiCardPath = json['esi_card_path'];
    cancelledChequePath = json['cancelled_cheque_path'];
    salarySlipPath = json['salary_slip_path'];
    birthCertificatePath = json['birth_certificate_path'];
    passportPath = json['passport_path'];
    drivingLicensePath = json['driving_license_path'];
    schoolLeavingCertificatePath = json['school_leaving_certificate_path'];
    markSheetPath = json['mark_sheet_path'];
    experienceCertificatePath = json['experience_certificate_path'];
    prevEmpAppLetterPath = json['prev_emp_app_letter_path'];
    form2Path = json['form_2_path'];
    form11Path = json['form_11_path'];
    graduityFormPath = json['graduity_form_path'];
    appLetterPath = json['app_letter_path'];
    pdsFormPath = json['pds_form_path'];
    fullName = json['full_name'];
    fatherName = json['father_name'];
    surname = json['surname'];
    motherName = json['mother_name'];
    maritalStatus = json['marital_status'];
    panNo = json['pan_no'];
    adhaarNo = json['adhaar_no'];
    preRoomNo = json['pre_room_no'];
    preBuilding = json['pre_building'];
    preArea = json['pre_area'];
    preRoad = json['pre_road'];
    preCity = json['pre_city'];
    preState = json['pre_state'];
    prePincode = json['pre_pincode'];
    preMobile = json['pre_mobile'];
    preEmail = json['pre_email'];
    perRoomNo = json['per_room_no'];
    perBuilding = json['per_building'];
    perArea = json['per_area'];
    perRoad = json['per_road'];
    perCity = json['per_city'];
    perState = json['per_state'];
    perPincode = json['per_pincode'];
    perMobile = json['per_mobile'];
    perEmail = json['per_email'];
    bloodGroup = json['blood_group'];
    bankName = json['bank_name'];
    bankAccNo = json['bank_acc_no'];
    bankIfscCode = json['bank_ifsc_code'];
    bankBranchName = json['bank_branch_name'];
    dataSubmitted = json['data_submitted'];
    isFresher = json['is_fresher'];
    pdsFormSignPath = json['pds_form_sign_path'];
    form2SignPath = json['form_2_sign_path'];
    form11SignPath = json['form_11_sign_path'];
    graduityFormSignPath = json['graduity_form_sign_path'];
    passwordBackup = json['password_backup'];
    gender = json['gender'];
    pdsFormChecked = json['pds_form_checked'];
    form2Checked = json['form_2_checked'];
    form11Checked = json['form_11_checked'];
    graduityFormChecked = json['graduity_form_checked'];
    beatTypeId = json['beat_type_id'];
    soId = json['so_id'];
    asmId = json['asm_id'];
    rmsId = json['rms_id'];
    nsmId = json['nsm_id'];
    distributorId = json['distributor_id'];
    baName = json['ba_name'];
    if (json['roles'] != null) {
      roles = [];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
    if (json['companies'] != null) {
      companies = [];
      json['companies'].forEach((v) {
        companies!.add(new Companies.fromJson(v));
      });
    }
    distributor = json['distributor'] != null
        ? new Distributor.fromJson(json['distributor'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['active'] = this.active;
    data['phone'] = this.phone;
    data['api_token'] = this.apiToken;
    data['doj'] = this.doj;
    data['dob'] = this.dob;
    data['company_designation_id'] = this.companyDesignationId;
    data['company_state_branch_id'] = this.companyStateBranchId;
    data['pf_no'] = this.pfNo;
    data['uan_no'] = this.uanNo;
    data['esi_no'] = this.esiNo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['salary'] = this.salary;
    data['image_path'] = this.imagePath;
    data['employee_code'] = this.employeeCode;
    data['asm_area'] = this.asmArea;
    data['asm_name'] = this.asmName;
    data['uid_no'] = this.uidNo;
    data['terms_accepted'] = this.termsAccepted;
    data['company_state_id'] = this.companyStateId;
    data['address'] = this.address;
    data['unique_id'] = this.uniqueId;
    data['appointment_letter'] = this.appointmentLetter;
    data['contract_expiry'] = this.contractExpiry;
    data['resume_path'] = this.resumePath;
    data['photo_path'] = this.photoPath;
    data['residential_proof_path'] = this.residentialProofPath;
    data['education_proof_path'] = this.educationProofPath;
    data['pan_card_path'] = this.panCardPath;
    data['adhaar_card_path'] = this.adhaarCardPath;
    data['esi_card_path'] = this.esiCardPath;
    data['cancelled_cheque_path'] = this.cancelledChequePath;
    data['salary_slip_path'] = this.salarySlipPath;
    data['birth_certificate_path'] = this.birthCertificatePath;
    data['passport_path'] = this.passportPath;
    data['driving_license_path'] = this.drivingLicensePath;
    data['school_leaving_certificate_path'] = this.schoolLeavingCertificatePath;
    data['mark_sheet_path'] = this.markSheetPath;
    data['experience_certificate_path'] = this.experienceCertificatePath;
    data['prev_emp_app_letter_path'] = this.prevEmpAppLetterPath;
    data['form_2_path'] = this.form2Path;
    data['form_11_path'] = this.form11Path;
    data['graduity_form_path'] = this.graduityFormPath;
    data['app_letter_path'] = this.appLetterPath;
    data['pds_form_path'] = this.pdsFormPath;
    data['full_name'] = this.fullName;
    data['father_name'] = this.fatherName;
    data['surname'] = this.surname;
    data['mother_name'] = this.motherName;
    data['marital_status'] = this.maritalStatus;
    data['pan_no'] = this.panNo;
    data['adhaar_no'] = this.adhaarNo;
    data['pre_room_no'] = this.preRoomNo;
    data['pre_building'] = this.preBuilding;
    data['pre_area'] = this.preArea;
    data['pre_road'] = this.preRoad;
    data['pre_city'] = this.preCity;
    data['pre_state'] = this.preState;
    data['pre_pincode'] = this.prePincode;
    data['pre_mobile'] = this.preMobile;
    data['pre_email'] = this.preEmail;
    data['per_room_no'] = this.perRoomNo;
    data['per_building'] = this.perBuilding;
    data['per_area'] = this.perArea;
    data['per_road'] = this.perRoad;
    data['per_city'] = this.perCity;
    data['per_state'] = this.perState;
    data['per_pincode'] = this.perPincode;
    data['per_mobile'] = this.perMobile;
    data['per_email'] = this.perEmail;
    data['blood_group'] = this.bloodGroup;
    data['bank_name'] = this.bankName;
    data['bank_acc_no'] = this.bankAccNo;
    data['bank_ifsc_code'] = this.bankIfscCode;
    data['bank_branch_name'] = this.bankBranchName;
    data['data_submitted'] = this.dataSubmitted;
    data['is_fresher'] = this.isFresher;
    data['pds_form_sign_path'] = this.pdsFormSignPath;
    data['form_2_sign_path'] = this.form2SignPath;
    data['form_11_sign_path'] = this.form11SignPath;
    data['graduity_form_sign_path'] = this.graduityFormSignPath;
    data['password_backup'] = this.passwordBackup;
    data['gender'] = this.gender;
    data['pds_form_checked'] = this.pdsFormChecked;
    data['form_2_checked'] = this.form2Checked;
    data['form_11_checked'] = this.form11Checked;
    data['graduity_form_checked'] = this.graduityFormChecked;
    data['beat_type_id'] = this.beatTypeId;
    data['so_id'] = this.soId;
    data['asm_id'] = this.asmId;
    data['rms_id'] = this.rmsId;
    data['nsm_id'] = this.nsmId;
    data['distributor_id'] = this.distributorId;
    data['ba_name'] = this.baName;
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    if (this.companies != null) {
      data['companies'] = this.companies!.map((v) => v.toJson()).toList();
    }
    if (this.distributor != null) {
      data['distributor'] = this.distributor!.toJson();
    }
    return data;
  }
}

class Roles {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Roles({this.id, this.name, this.createdAt, this.updatedAt});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Companies {
  int? id;
  String? name;
  String? email;
  int? phone;
  String? address;
  String? logoPath;
  String? contactPerson;
  String? createdAt;
  String? updatedAt;
  String? timeZone;
  String? pdsWordPath;
  String? pdsPdfPath;
  String? form2WordPath;
  String? form2PdfPath;
  String? form11WordPath;
  String? form11PdfPath;
  String? pfWordPath;
  String? pfPdfPath;
  String? esicBenefitWordPath;
  String? esicBenefitPdfPath;
  String? insuranceClaimWordPath;
  String? insuranceClaimPdfPath;
  String? salarySlipWordPath;
  String? salarySlipPdfPath;
  String? pmsPoliciesWordPath;
  String? pmsPoliciesPdfPath;
  String? actOfMisconductWordPath;
  String? actOfMisconductPdfPath;
  String? uanActivationWordPath;
  String? uanActivationPdfPath;
  String? onlineClaimWordPath;
  String? onlineClaimPdfPath;
  String? kycUpdateWordPath;
  String? kycUpdatePdfPath;
  String? graduityFormWordPath;
  String? graduityFormPdfPath;
  String? welcomeNote;
  String? welcomeEmailSubject;
  String? welcomeEmailBody;
  String? df1EmailSubject;
  String? df1EmailBody;
  String? df2EmailSubject;
  String? df2EmailBody;
  int? attendance;
  int? leave;
  int? expenses;
  int? orders;
  int? recruiters;

  Companies(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.logoPath,
      this.contactPerson,
      this.createdAt,
      this.updatedAt,
      this.timeZone,
      this.pdsWordPath,
      this.pdsPdfPath,
      this.form2WordPath,
      this.form2PdfPath,
      this.form11WordPath,
      this.form11PdfPath,
      this.pfWordPath,
      this.pfPdfPath,
      this.esicBenefitWordPath,
      this.esicBenefitPdfPath,
      this.insuranceClaimWordPath,
      this.insuranceClaimPdfPath,
      this.salarySlipWordPath,
      this.salarySlipPdfPath,
      this.pmsPoliciesWordPath,
      this.pmsPoliciesPdfPath,
      this.actOfMisconductWordPath,
      this.actOfMisconductPdfPath,
      this.uanActivationWordPath,
      this.uanActivationPdfPath,
      this.onlineClaimWordPath,
      this.onlineClaimPdfPath,
      this.kycUpdateWordPath,
      this.kycUpdatePdfPath,
      this.graduityFormWordPath,
      this.graduityFormPdfPath,
      this.welcomeNote,
      this.welcomeEmailSubject,
      this.welcomeEmailBody,
      this.df1EmailSubject,
      this.df1EmailBody,
      this.df2EmailSubject,
      this.df2EmailBody,
      this.attendance,
      this.leave,
      this.expenses,
      this.orders,
      this.recruiters});

  Companies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    logoPath = json['logo_path'];
    contactPerson = json['contact_person'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    timeZone = json['time_zone'];
    pdsWordPath = json['pds_word_path'];
    pdsPdfPath = json['pds_pdf_path'];
    form2WordPath = json['form_2_word_path'];
    form2PdfPath = json['form_2_pdf_path'];
    form11WordPath = json['form_11_word_path'];
    form11PdfPath = json['form_11_pdf_path'];
    pfWordPath = json['pf_word_path'];
    pfPdfPath = json['pf_pdf_path'];
    esicBenefitWordPath = json['esic_benefit_word_path'];
    esicBenefitPdfPath = json['esic_benefit_pdf_path'];
    insuranceClaimWordPath = json['insurance_claim_word_path'];
    insuranceClaimPdfPath = json['insurance_claim_pdf_path'];
    salarySlipWordPath = json['salary_slip_word_path'];
    salarySlipPdfPath = json['salary_slip_pdf_path'];
    pmsPoliciesWordPath = json['pms_policies_word_path'];
    pmsPoliciesPdfPath = json['pms_policies_pdf_path'];
    actOfMisconductWordPath = json['act_of_misconduct_word_path'];
    actOfMisconductPdfPath = json['act_of_misconduct_pdf_path'];
    uanActivationWordPath = json['uan_activation_word_path'];
    uanActivationPdfPath = json['uan_activation_pdf_path'];
    onlineClaimWordPath = json['online_claim_word_path'];
    onlineClaimPdfPath = json['online_claim_pdf_path'];
    kycUpdateWordPath = json['kyc_update_word_path'];
    kycUpdatePdfPath = json['kyc_update_pdf_path'];
    graduityFormWordPath = json['graduity_form_word_path'];
    graduityFormPdfPath = json['graduity_form_pdf_path'];
    welcomeNote = json['welcome_note'];
    welcomeEmailSubject = json['welcome_email_subject'];
    welcomeEmailBody = json['welcome_email_body'];
    df1EmailSubject = json['df_1_email_subject'];
    df1EmailBody = json['df_1_email_body'];
    df2EmailSubject = json['df_2_email_subject'];
    df2EmailBody = json['df_2_email_body'];
    attendance = json['attendance'];
    leave = json['leave'];
    expenses = json['expenses'];
    orders = json['orders'];
    recruiters = json['recruiters'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['logo_path'] = this.logoPath;
    data['contact_person'] = this.contactPerson;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['time_zone'] = this.timeZone;
    data['pds_word_path'] = this.pdsWordPath;
    data['pds_pdf_path'] = this.pdsPdfPath;
    data['form_2_word_path'] = this.form2WordPath;
    data['form_2_pdf_path'] = this.form2PdfPath;
    data['form_11_word_path'] = this.form11WordPath;
    data['form_11_pdf_path'] = this.form11PdfPath;
    data['pf_word_path'] = this.pfWordPath;
    data['pf_pdf_path'] = this.pfPdfPath;
    data['esic_benefit_word_path'] = this.esicBenefitWordPath;
    data['esic_benefit_pdf_path'] = this.esicBenefitPdfPath;
    data['insurance_claim_word_path'] = this.insuranceClaimWordPath;
    data['insurance_claim_pdf_path'] = this.insuranceClaimPdfPath;
    data['salary_slip_word_path'] = this.salarySlipWordPath;
    data['salary_slip_pdf_path'] = this.salarySlipPdfPath;
    data['pms_policies_word_path'] = this.pmsPoliciesWordPath;
    data['pms_policies_pdf_path'] = this.pmsPoliciesPdfPath;
    data['act_of_misconduct_word_path'] = this.actOfMisconductWordPath;
    data['act_of_misconduct_pdf_path'] = this.actOfMisconductPdfPath;
    data['uan_activation_word_path'] = this.uanActivationWordPath;
    data['uan_activation_pdf_path'] = this.uanActivationPdfPath;
    data['online_claim_word_path'] = this.onlineClaimWordPath;
    data['online_claim_pdf_path'] = this.onlineClaimPdfPath;
    data['kyc_update_word_path'] = this.kycUpdateWordPath;
    data['kyc_update_pdf_path'] = this.kycUpdatePdfPath;
    data['graduity_form_word_path'] = this.graduityFormWordPath;
    data['graduity_form_pdf_path'] = this.graduityFormPdfPath;
    data['welcome_note'] = this.welcomeNote;
    data['welcome_email_subject'] = this.welcomeEmailSubject;
    data['welcome_email_body'] = this.welcomeEmailBody;
    data['df_1_email_subject'] = this.df1EmailSubject;
    data['df_1_email_body'] = this.df1EmailBody;
    data['df_2_email_subject'] = this.df2EmailSubject;
    data['df_2_email_body'] = this.df2EmailBody;
    data['attendance'] = this.attendance;
    data['leave'] = this.leave;
    data['expenses'] = this.expenses;
    data['orders'] = this.orders;
    data['recruiters'] = this.recruiters;
    return data;
  }
}

class Distributor {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  int? active;
  int? phone;
  String? apiToken;
  String? doj;
  String? dob;
  String? companyDesignationId;
  String? companyStateBranchId;
  String? pfNo;
  String? uanNo;
  String? esiNo;
  String? createdAt;
  String? updatedAt;
  String? salary;
  String? imagePath;
  String? employeeCode;
  String? asmArea;
  String? asmName;
  String? uidNo;
  String? termsAccepted;
  String? companyStateId;
  String? address;
  String? uniqueId;
  String? appointmentLetter;
  String? contractExpiry;
  String? resumePath;
  String? photoPath;
  String? residentialProofPath;
  String? educationProofPath;
  String? panCardPath;
  String? adhaarCardPath;
  String? esiCardPath;
  String? cancelledChequePath;
  String? salarySlipPath;
  String? birthCertificatePath;
  String? passportPath;
  String? drivingLicensePath;
  String? schoolLeavingCertificatePath;
  String? markSheetPath;
  String? experienceCertificatePath;
  String? prevEmpAppLetterPath;
  String? form2Path;
  String? form11Path;
  String? graduityFormPath;
  String? appLetterPath;
  String? pdsFormPath;
  String? fullName;
  String? fatherName;
  String? surname;
  String? motherName;
  String? maritalStatus;
  String? panNo;
  String? adhaarNo;
  String? preRoomNo;
  String? preBuilding;
  String? preArea;
  String? preRoad;
  String? preCity;
  String? preState;
  String? prePincode;
  String? preMobile;
  String? preEmail;
  String? perRoomNo;
  String? perBuilding;
  String? perArea;
  String? perRoad;
  String? perCity;
  String? perState;
  String? perPincode;
  String? perMobile;
  String? perEmail;
  String? bloodGroup;
  String? bankName;
  String? bankAccNo;
  String? bankIfscCode;
  String? bankBranchName;
  int? dataSubmitted;
  int? isFresher;
  String? pdsFormSignPath;
  String? form2SignPath;
  String? form11SignPath;
  String? graduityFormSignPath;
  String? passwordBackup;
  String? gender;
  int? pdsFormChecked;
  int? form2Checked;
  int? form11Checked;
  int? graduityFormChecked;
  String? beatTypeId;
  String? soId;
  int? asmId;
  String? rmsId;
  String? nsmId;
  String? distributorId;

  Distributor(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.active,
      this.phone,
      this.apiToken,
      this.doj,
      this.dob,
      this.companyDesignationId,
      this.companyStateBranchId,
      this.pfNo,
      this.uanNo,
      this.esiNo,
      this.createdAt,
      this.updatedAt,
      this.salary,
      this.imagePath,
      this.employeeCode,
      this.asmArea,
      this.asmName,
      this.uidNo,
      this.termsAccepted,
      this.companyStateId,
      this.address,
      this.uniqueId,
      this.appointmentLetter,
      this.contractExpiry,
      this.resumePath,
      this.photoPath,
      this.residentialProofPath,
      this.educationProofPath,
      this.panCardPath,
      this.adhaarCardPath,
      this.esiCardPath,
      this.cancelledChequePath,
      this.salarySlipPath,
      this.birthCertificatePath,
      this.passportPath,
      this.drivingLicensePath,
      this.schoolLeavingCertificatePath,
      this.markSheetPath,
      this.experienceCertificatePath,
      this.prevEmpAppLetterPath,
      this.form2Path,
      this.form11Path,
      this.graduityFormPath,
      this.appLetterPath,
      this.pdsFormPath,
      this.fullName,
      this.fatherName,
      this.surname,
      this.motherName,
      this.maritalStatus,
      this.panNo,
      this.adhaarNo,
      this.preRoomNo,
      this.preBuilding,
      this.preArea,
      this.preRoad,
      this.preCity,
      this.preState,
      this.prePincode,
      this.preMobile,
      this.preEmail,
      this.perRoomNo,
      this.perBuilding,
      this.perArea,
      this.perRoad,
      this.perCity,
      this.perState,
      this.perPincode,
      this.perMobile,
      this.perEmail,
      this.bloodGroup,
      this.bankName,
      this.bankAccNo,
      this.bankIfscCode,
      this.bankBranchName,
      this.dataSubmitted,
      this.isFresher,
      this.pdsFormSignPath,
      this.form2SignPath,
      this.form11SignPath,
      this.graduityFormSignPath,
      this.passwordBackup,
      this.gender,
      this.pdsFormChecked,
      this.form2Checked,
      this.form11Checked,
      this.graduityFormChecked,
      this.beatTypeId,
      this.soId,
      this.asmId,
      this.rmsId,
      this.nsmId,
      this.distributorId});

  Distributor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    active = json['active'];
    phone = json['phone'];
    apiToken = json['api_token'];
    doj = json['doj'];
    dob = json['dob'];
    companyDesignationId = json['company_designation_id'];
    companyStateBranchId = json['company_state_branch_id'];
    pfNo = json['pf_no'];
    uanNo = json['uan_no'];
    esiNo = json['esi_no'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    salary = json['salary'];
    imagePath = json['image_path'];
    employeeCode = json['employee_code'];
    asmArea = json['asm_area'];
    asmName = json['asm_name'];
    uidNo = json['uid_no'];
    termsAccepted = json['terms_accepted'];
    companyStateId = json['company_state_id'];
    address = json['address'];
    uniqueId = json['unique_id'];
    appointmentLetter = json['appointment_letter'];
    contractExpiry = json['contract_expiry'];
    resumePath = json['resume_path'];
    photoPath = json['photo_path'];
    residentialProofPath = json['residential_proof_path'];
    educationProofPath = json['education_proof_path'];
    panCardPath = json['pan_card_path'];
    adhaarCardPath = json['adhaar_card_path'];
    esiCardPath = json['esi_card_path'];
    cancelledChequePath = json['cancelled_cheque_path'];
    salarySlipPath = json['salary_slip_path'];
    birthCertificatePath = json['birth_certificate_path'];
    passportPath = json['passport_path'];
    drivingLicensePath = json['driving_license_path'];
    schoolLeavingCertificatePath = json['school_leaving_certificate_path'];
    markSheetPath = json['mark_sheet_path'];
    experienceCertificatePath = json['experience_certificate_path'];
    prevEmpAppLetterPath = json['prev_emp_app_letter_path'];
    form2Path = json['form_2_path'];
    form11Path = json['form_11_path'];
    graduityFormPath = json['graduity_form_path'];
    appLetterPath = json['app_letter_path'];
    pdsFormPath = json['pds_form_path'];
    fullName = json['full_name'];
    fatherName = json['father_name'];
    surname = json['surname'];
    motherName = json['mother_name'];
    maritalStatus = json['marital_status'];
    panNo = json['pan_no'];
    adhaarNo = json['adhaar_no'];
    preRoomNo = json['pre_room_no'];
    preBuilding = json['pre_building'];
    preArea = json['pre_area'];
    preRoad = json['pre_road'];
    preCity = json['pre_city'];
    preState = json['pre_state'];
    prePincode = json['pre_pincode'];
    preMobile = json['pre_mobile'];
    preEmail = json['pre_email'];
    perRoomNo = json['per_room_no'];
    perBuilding = json['per_building'];
    perArea = json['per_area'];
    perRoad = json['per_road'];
    perCity = json['per_city'];
    perState = json['per_state'];
    perPincode = json['per_pincode'];
    perMobile = json['per_mobile'];
    perEmail = json['per_email'];
    bloodGroup = json['blood_group'];
    bankName = json['bank_name'];
    bankAccNo = json['bank_acc_no'];
    bankIfscCode = json['bank_ifsc_code'];
    bankBranchName = json['bank_branch_name'];
    dataSubmitted = json['data_submitted'];
    isFresher = json['is_fresher'];
    pdsFormSignPath = json['pds_form_sign_path'];
    form2SignPath = json['form_2_sign_path'];
    form11SignPath = json['form_11_sign_path'];
    graduityFormSignPath = json['graduity_form_sign_path'];
    passwordBackup = json['password_backup'];
    gender = json['gender'];
    pdsFormChecked = json['pds_form_checked'];
    form2Checked = json['form_2_checked'];
    form11Checked = json['form_11_checked'];
    graduityFormChecked = json['graduity_form_checked'];
    beatTypeId = json['beat_type_id'];
    soId = json['so_id'];
    asmId = json['asm_id'];
    rmsId = json['rms_id'];
    nsmId = json['nsm_id'];
    distributorId = json['distributor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['active'] = this.active;
    data['phone'] = this.phone;
    data['api_token'] = this.apiToken;
    data['doj'] = this.doj;
    data['dob'] = this.dob;
    data['company_designation_id'] = this.companyDesignationId;
    data['company_state_branch_id'] = this.companyStateBranchId;
    data['pf_no'] = this.pfNo;
    data['uan_no'] = this.uanNo;
    data['esi_no'] = this.esiNo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['salary'] = this.salary;
    data['image_path'] = this.imagePath;
    data['employee_code'] = this.employeeCode;
    data['asm_area'] = this.asmArea;
    data['asm_name'] = this.asmName;
    data['uid_no'] = this.uidNo;
    data['terms_accepted'] = this.termsAccepted;
    data['company_state_id'] = this.companyStateId;
    data['address'] = this.address;
    data['unique_id'] = this.uniqueId;
    data['appointment_letter'] = this.appointmentLetter;
    data['contract_expiry'] = this.contractExpiry;
    data['resume_path'] = this.resumePath;
    data['photo_path'] = this.photoPath;
    data['residential_proof_path'] = this.residentialProofPath;
    data['education_proof_path'] = this.educationProofPath;
    data['pan_card_path'] = this.panCardPath;
    data['adhaar_card_path'] = this.adhaarCardPath;
    data['esi_card_path'] = this.esiCardPath;
    data['cancelled_cheque_path'] = this.cancelledChequePath;
    data['salary_slip_path'] = this.salarySlipPath;
    data['birth_certificate_path'] = this.birthCertificatePath;
    data['passport_path'] = this.passportPath;
    data['driving_license_path'] = this.drivingLicensePath;
    data['school_leaving_certificate_path'] = this.schoolLeavingCertificatePath;
    data['mark_sheet_path'] = this.markSheetPath;
    data['experience_certificate_path'] = this.experienceCertificatePath;
    data['prev_emp_app_letter_path'] = this.prevEmpAppLetterPath;
    data['form_2_path'] = this.form2Path;
    data['form_11_path'] = this.form11Path;
    data['graduity_form_path'] = this.graduityFormPath;
    data['app_letter_path'] = this.appLetterPath;
    data['pds_form_path'] = this.pdsFormPath;
    data['full_name'] = this.fullName;
    data['father_name'] = this.fatherName;
    data['surname'] = this.surname;
    data['mother_name'] = this.motherName;
    data['marital_status'] = this.maritalStatus;
    data['pan_no'] = this.panNo;
    data['adhaar_no'] = this.adhaarNo;
    data['pre_room_no'] = this.preRoomNo;
    data['pre_building'] = this.preBuilding;
    data['pre_area'] = this.preArea;
    data['pre_road'] = this.preRoad;
    data['pre_city'] = this.preCity;
    data['pre_state'] = this.preState;
    data['pre_pincode'] = this.prePincode;
    data['pre_mobile'] = this.preMobile;
    data['pre_email'] = this.preEmail;
    data['per_room_no'] = this.perRoomNo;
    data['per_building'] = this.perBuilding;
    data['per_area'] = this.perArea;
    data['per_road'] = this.perRoad;
    data['per_city'] = this.perCity;
    data['per_state'] = this.perState;
    data['per_pincode'] = this.perPincode;
    data['per_mobile'] = this.perMobile;
    data['per_email'] = this.perEmail;
    data['blood_group'] = this.bloodGroup;
    data['bank_name'] = this.bankName;
    data['bank_acc_no'] = this.bankAccNo;
    data['bank_ifsc_code'] = this.bankIfscCode;
    data['bank_branch_name'] = this.bankBranchName;
    data['data_submitted'] = this.dataSubmitted;
    data['is_fresher'] = this.isFresher;
    data['pds_form_sign_path'] = this.pdsFormSignPath;
    data['form_2_sign_path'] = this.form2SignPath;
    data['form_11_sign_path'] = this.form11SignPath;
    data['graduity_form_sign_path'] = this.graduityFormSignPath;
    data['password_backup'] = this.passwordBackup;
    data['gender'] = this.gender;
    data['pds_form_checked'] = this.pdsFormChecked;
    data['form_2_checked'] = this.form2Checked;
    data['form_11_checked'] = this.form11Checked;
    data['graduity_form_checked'] = this.graduityFormChecked;
    data['beat_type_id'] = this.beatTypeId;
    data['so_id'] = this.soId;
    data['asm_id'] = this.asmId;
    data['rms_id'] = this.rmsId;
    data['nsm_id'] = this.nsmId;
    data['distributor_id'] = this.distributorId;
    return data;
  }
}
