import 'package:alphawash/data/model/language_model.dart';

class AppConstants {

 static const String APP_NAME = 'Alphawash';
 static const String CONFIG_URI = '/api/v1/config';
 static const String BASE_URL = 'https://agreements.winji.org';

 /// AUTH
 static const String LOGIN_URI = '/api/v1/auth/login';
 static const String TOKEN_URI = '/api/v1/customer/cm-firebase-token';
 static const String SOCIAL_LOGIN_URI = '/api/v1/auth/social-login';
 static const String REGISTER_URI = '/api/v1/auth/signup';
 static const String CHECK_EMAIL_URI = '/api/v1/auth/check-email';
 static const String VERIFY_TOKEN_URI = '/api/v1/auth/verify-token';
 static const String VERIFY_PASSWORD_TOKEN_URI = '/api/v1/auth/verify-password-token';
 static const String FORGET_PASSWORD_URI = '/api/v1/auth/forgot-password';
 static const String RESET_PASSWORD_URI = '/api/v1/auth/reset-password';
 static const String VERIFY_EMAIL_URI = '/api/v1/auth/verify-email';

 /// PROFILE
 static const String UPDATE_PROFILE_URI = '/api/v1/user/update-profile';
 static const String UPDATE_PERSONAL_INFO_URI = '/api/v1/user/profile/update-admin';
 static const String WORKERS_LIST_URI = '/api/v1/user/worker/list';
 static const String CUSTOMER_INFO_URI = '/api/v1/user/info';
 static const String DELETE_WORKER_URI = '/api/v1/user/worker/delete-worker';

 /// Location
 static const String STORE_NEW_AREA_URI = '/api/v1/user/location/store-area';
 static const String UPDATE_AREA_URI = '/api/v1/user/location/update-area';
 static const String AREAS_LIST_URI = '/api/v1/user/location/areas-list';
 static const String REMOVE_AREA_URI = '/api/v1/user/location/remove-area';
 static const String UPDATE_USER_AREAS_URI = '/api/v1/user/location/worker/update-worker-areas';

 // waypoints
 static const String WAYPOINTS_LIST_URI = '/api/v1/user/location/waypoints/waypoints-list';
 static const String STORE_POINT_URI = '/api/v1/user/location/waypoints/store-waypoint';
 static const String UPDATE_POINT_URI = '/api/v1/user/location/waypoints/update-waypoint';
 static const String DELETE_POINT_URI = '/api/v1/user/location/waypoints/remove-waypoint';


 /// Workers
 static const String UPDATE_WORKER_DETAILS_URI = '/api/v1/user/worker/update-worker';
 static const String ADD_WORKER_URI = '/api/v1/user/worker/add-new';
 static const String WORKER_AREAS_LIST_URI = '/api/v1/user/location/worker/areas-list';
 static const String UPDATE_WORKER_BIO_URI = '/api/v1/user/profile/update-worker-bio';
 static const String SELECT_USERS_URI = '/api/v1/user/location/waypoints/select-users-waypoint';


 /// WORKER
 static const String WORKER_AREAS_URI = '/api/v1/worker/areas/areas-list';
 static const String ADD_PINPOINT_TASK_URI = '/api/v1/worker/tasks/add-task';
 static const String GET_PINPOINT_TASK_URI ='/api/v1/worker/tasks/tasks-list' ;
 static const String GET_WORKER_WAYPOINTS_URI='/api/v1/worker/waypoints/list';
 static const String GET_WORKER_WAYPOINTS_TODAY_URI = '/api/v1/worker/waypoints/list';
 static const String GET_WORKER_TASKS_URI='/api/v1/worker/tasks/admin-tasks-list' ;
 static const String UPDATE_PINPOINT_TASK_URI='/api/v1/worker/tasks/update-task';
 static const String TASK_REMINDER_URI ='/api/v1/worker/tasks/task-reminder' ;

 ///admin
 static const String STORE_TASK_URI ='/api/v1/user/task/add-task';
 static const String GET_TASK_URI ='/api/v1/user/task/tasks-list';
 static const String POST_PERMISSION_URI ='/api/v1/user/worker/update-permissions';
 static const String GET_ADMIN_PINPOINT_TASKS_LIST_URI = '/api/v1/user/task/admin-tasks-list';

 ///Reports
 static const String ALL_TASKS_REPORT_URI ='/api/v1/user/reports/all-tasks-report';

 /// internal
  static const String TOKEN = 'token';
  static const String USER_ID = 'user_id';
 static const String USER_TYPE = 'user_type';

  static const String USER_PASSWORD = 'user_password';
  static const String USER_NUMBER = 'user_number';

 static const String COUNTRY_CODE = 'country_code';
 static const String LANGUAGE_CODE = 'language_code';

 static const String CURRENCY = '\$';

 static const String THEME = 'theme';
 static const String PRIMARY_COLOR = 'primary_color';
 static const String FONT_SIZE = 'font_size';
 // TEMPORARY

  static const String API_KEY = 'AIzaSyBIbAyozsooyfTl49xleURPX7424AUJpuA';   // TEMPORARY
 //static const String API_KEY = 'AIzaSyAuwPPxNuNZx8vgqADq_1oe13KDnEaGTfg';
 // internal
 static const String DRIVER_TOKEN = 'token';
 static const String DRIVER_ID = 'driver_id';
 static const String DRIVER_PASSWORD = 'driver_password';
 static const String DRIVER_NUMBER = 'driver_number';

 static List<LanguageModel> languages = [
  LanguageModel(
      languageName: 'English',
      languageCode: 'en'),
 ];
}
