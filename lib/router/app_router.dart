import 'package:flutter/material.dart';
import 'package:productos_app/screens/check_screen.dart';
import '../screens/screens.dart';

class AppRoutes{

  static const initialRoute = 'login';
  static Map<String, Widget Function(BuildContext)> routes = {
      'home'      : ( BuildContext context) =>  HomeScreen(),
      'login'  : ( BuildContext context) =>  LoginScreen(),
      'product'  : ( BuildContext context) =>  ProductScreen(),
      'load'  : ( BuildContext context) =>  LoadingScreen(),      
      'register'  : ( BuildContext context) =>  RegisterScreen(),  
      'checking'  : ( BuildContext context) =>  CheckScreen(),
      };
}