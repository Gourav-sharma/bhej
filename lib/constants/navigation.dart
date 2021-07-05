import 'package:flutter/material.dart';

class NavigationConstrants {
  static final navKey = new GlobalKey<NavigatorState>();

  // Notification routes
  static const String NOTIFICATION_SUCCESS = "notification-success-route";
  static const String NOTIFICATION_ERROR = "notification-error-route";

  // Pages routes
  static const String Trending = "/Trending";
  static const String ProfileOne = "/ProfileOne";

}
