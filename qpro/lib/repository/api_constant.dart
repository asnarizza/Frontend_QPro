class APIConstant {

  static const String ipaddress = "http://10.131.73.131:8000";

  static const String URL = "${ipaddress}/api/";

  // auth module
  static String get LoginURL => "${APIConstant.URL}login";
  static String get RegisterURL => "${APIConstant.URL}signup";
  static String get RefreshURL => "${APIConstant.URL}auth/refresh";
  static String get ForgotPasswordURL => "${APIConstant.URL}forgot-password";
  static String get LogoutURL => "${APIConstant.URL}logout";


  // queue module
  static String get GenerateURL => "${APIConstant.URL}customer-queues/generate";
  static String get GetQueueByDptURL => "${APIConstant.URL}queue-number/";
  static String get CallQueueURL => "${APIConstant.URL}call-queue/";
  static String get TranferQueueURL => "${APIConstant.URL}customer-queue/pass/";


  // admin module
  static String get DepartmentURL => "${APIConstant.URL}add-departments";
  //static String get CounterURL => "${APIConstant.URL}add-counters";
  static String get StaffURL => "${APIConstant.URL}staff";
  static String get GetDepURL => "${APIConstant.URL}departments";
  static String get GetCounterURL => "${APIConstant.URL}counters";
  static String get AssignStaffURL => "${APIConstant.URL}add-department-counters";
  static String get GetDeptCtrURL => "${APIConstant.URL}department-counter/";
  static String get GetCtrByDptURL => "${APIConstant.URL}counters-by-department/";
  static String get CounterURL => "${APIConstant.URL}assign-new-counter-id";
}