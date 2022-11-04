
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/widgets/widgets.dart';
import '../models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ProductsService extends ChangeNotifier{

  final String _baseUrl = 'flutter-varios-2dbfc-default-rtdb.firebaseio.com';  
  final String _basePicture = 'https://api.cloudinary.com/v1_1/dekpm261i/image/upload?upload_preset=bjidrues';

  final storage = FlutterSecureStorage();

  final List<Product> products = [];
  bool isLoading = true;
  bool isSaving = false;
  File? newPictureFile;
  
  late Product selectedProduct;
  // fetch de productos

  ProductsService(){
    loadProducts();
    
  }

  Future loadProducts() async{

    isLoading = true;
    notifyListeners();

    final url = Uri.https( _baseUrl, 'products.json', {
      'auth' : await storage.read(key: 'idToken') ?? ''
    });
    final resp = await http.get(url);

    final Map<String,  dynamic> productsMap = json.decode(resp.body);
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromJson( value);
      tempProduct.id = key;
      products.add(tempProduct);
     });    

    isLoading = false;
    notifyListeners();

    return products;
  }

  Future saveOrCreateProduct( Product product) async {
    isSaving = true;    
    notifyListeners();
    if ( product.id == null){
       //crear
      await createProduct(product);
    } else {      
      //Actualizar
      await updateProduct(product);

    }
    isSaving = false;    
    notifyListeners();

  }
  
  Future<String> updateProduct( Product product ) async {

    final url = Uri.https( _baseUrl, 'products/${ product.id }.json', {
      'auth' : await storage.read(key: 'idToken') ?? '' } );
    final resp = await http.put( url, body: json.encode(product.toJson())  );
    //final decodedData = resp.body;

    final index = products.indexWhere((element) => element.id == product.id );
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct( Product product ) async {

    final url = Uri.https( _baseUrl, 'products.json' , {
      'auth' : await storage.read(key: 'idToken') ?? '' } );
    final resp = await http.post( url, body: json.encode( product.toJson() ) );
    final decodedData = json.decode( resp.body );

    product.id = decodedData['name'];
    this.products.add(product);    
    return product.id!;

  }

  void updateSelectedProductImage( String path){

    selectedProduct.picture = path;
    newPictureFile = File.fromUri( Uri(path: path) );
 
    notifyListeners();    
  }

  Future<String?> uploadImage() async {

    if (  newPictureFile == null ) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(_basePicture);
    final imageUploadRequest = http.MultipartRequest('POST', url );
    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path );
    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('algo salio mal');
      print( resp.body );
      return null;
    }

    this.newPictureFile = null;

    final decodedData = json.decode( resp.body );
    return decodedData['secure_url'];

  }


}