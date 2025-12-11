class Global{
  static String token='';
  static String host = 'http://192.168.18.220';

  static String getToken(){
    return token;
  }

  static void setToken(String token1){
    token = token1;
  }

  static String getHost(){
    return host;
  }

  static void setHost(String host1){
    host = host1;
  }
}