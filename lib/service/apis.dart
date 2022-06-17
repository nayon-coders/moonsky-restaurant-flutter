class ApiService{
  static const String BaseUrl = "http://moonskynl.com/api";
  static const String loginUrl = BaseUrl+"/login";
  static const String register = BaseUrl+"/register";
  static const String categoryUrl = BaseUrl+"/auth/category/show";
  static const String favoriteFood = BaseUrl+"/auth/favorite/show";
  static const String createCatering = BaseUrl+"/auth/catering/post";
  static const String CateringList = BaseUrl+"/auth/my-catering-list";
  static const String addCart = BaseUrl+"/auth/add-to-cart/post";
  static const String cartList = BaseUrl+"/auth/cart/show";
  static const String addFaveriot = BaseUrl+"/auth/add-to-fav/post";
  static const String logout = BaseUrl+"/auth/logout";
  static const String changePass = BaseUrl+"/auth/change/password";
  static const String orderCreate = BaseUrl+"/auth/order/post";
  static const String orderList = BaseUrl+"/auth/order/show";
  static const String reviewCreate = BaseUrl+"/auth/review/post";
  static const String showReview = BaseUrl+"/auth/review/show";


}