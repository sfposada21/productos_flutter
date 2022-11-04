import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AuthService extends ChangeNotifier {

  final String _baseUrl = 'identitytoolkit.googleapis.com';  
  final String _register = '/v1/accounts:signUp';   
  final String _login = '/v1/accounts:signInWithPassword'; 
  final String _key = 'AIzaSyBVYU3_dUvur713OY92h0-yE4qe4t7Qcls';

  final storage = new FlutterSecureStorage();


  Future<String?> createUser( String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken' : true
    };
    final url = Uri.https(_baseUrl, _register, { 'key':_key   });
    final resp = await http.post( url, body: json.encode(authData) );
    final Map<String, dynamic> decodeResp =  json.decode(resp.body);    
    if (decodeResp.containsKey('idToken')){
      storage.write(key: 'idToken', value: decodeResp['idToken']);
      return null;
    } else {
      return decodeResp['error']['message'];
    }
  }

    Future<String?> loginUser( String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken' : true
    };
    final url = Uri.https(_baseUrl, _login, { 'key':_key   });
    final resp = await http.post( url, body: json.encode(authData) );
    final Map<String, dynamic> decodeResp =  json.decode(resp.body);    
    if (decodeResp.containsKey('idToken')){
      storage.write(key: 'idToken', value: decodeResp['idToken']);
      return null;
    } else {
      return decodeResp['error']['message'];
    }

  }

  Future logout () async {
    await storage.delete(key: 'idToken');
  }

  Future<String> readToken () async {
    return await storage.read(key: 'idToken') ?? '';
  }

}