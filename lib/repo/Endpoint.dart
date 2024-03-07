enum ENDPOINT {
  GET_NOTIFICATION_REQUEST,
  GET_REQUEST,
  DELETE_REQUEST,
  INSERT_REQUEST,
  GET_REQUEST_DETAIL,
  GET_REQUEST_TIME,
  GET_CALCULATE_TIME,
  GET_REQUEST_TYPE,
  GET_REQUEST_SUBTYPE,
  REQUEST_PICTURE_REQUIRED,
  GET_CATEGORY,
  GET_NEWS,
  GET_EXAM,
  GET_EXAM_LIST,
  INSERT_EXAM,
  CHANGE_EXAM_TYPE,
  TIME_INSERT
}

abstract class EndpointConfig {
  // static final String _host = "192.168.1.24/";
  static final String _host = "https://admin.timely.mn/";
  static final String _apiHost = "https://api.timely.mn";
  static final String _httpPathConst = "api";

  static final Map<ENDPOINT, String> _ENDPOINTS = {
    ENDPOINT.GET_NOTIFICATION_REQUEST: "/notification_request.php",
    ENDPOINT.GET_REQUEST: "/request.php",
    ENDPOINT.INSERT_REQUEST: "/request_insert.php",
    ENDPOINT.DELETE_REQUEST: "/request_delete.php",
    ENDPOINT.GET_REQUEST_DETAIL: "/request_detail.php",
    ENDPOINT.GET_REQUEST_TIME: "/request_times.php",
    ENDPOINT.GET_CALCULATE_TIME: "/request_calc.php",
    ENDPOINT.GET_REQUEST_TYPE: "/request_type.php",
    ENDPOINT.GET_REQUEST_SUBTYPE: "/request_sub_type.php",
    ENDPOINT.REQUEST_PICTURE_REQUIRED: "/request_picture_required.php",
    ENDPOINT.GET_CATEGORY: "/category.php", //company_id
    ENDPOINT.GET_NEWS: "/news.php", //category_id
    ENDPOINT.GET_EXAM: "/exam_answer.php",
    ENDPOINT.GET_EXAM_LIST: "/exam.php",
    ENDPOINT.INSERT_EXAM: "/exam_insert.php",
    ENDPOINT.CHANGE_EXAM_TYPE: "/exam_change_type.php",
    ENDPOINT.TIME_INSERT: "/time_insert.php"
  };

  static String getEnpoint(ENDPOINT endpoint) =>
      "$_host$_httpPathConst${_ENDPOINTS[endpoint]}";

  static String getNewEndpoint(ENDPOINT endpoint) =>
      "$_apiHost${_ENDPOINTS[endpoint]}";
}
