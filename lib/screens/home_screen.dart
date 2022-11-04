import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/products_service.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productService = Provider.of<ProductsService>( context);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (productService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          IconButton(
          onPressed: () {
             authService.logout();
             Navigator.pushNamed(context, 'login');
          }, 
          icon: Icon(Icons.login_outlined)),
        ]
      ),
      body: ListView.builder(
        itemCount: productService.products.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector( 
            onTap: () {  
              productService.selectedProduct = productService.products[index].copy();
              Navigator.pushNamed(context, 'product');
              },
            child: ProductCard(product: productService.products[index]),
          )
        
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon( Icons.add),
        onPressed: () {
          productService.selectedProduct = new Product(available: false, name: '', price: 0);
          Navigator.pushNamed(context, 'product');
      },
      )
   );
  }
}