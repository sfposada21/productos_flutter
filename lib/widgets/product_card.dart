import 'package:flutter/material.dart';

import '../models/models.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {

    final boxDecorationCard = BoxDecoration(
        color: Colors.green[200],
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(0, 7), blurRadius: 5)
        ]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 25, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: boxDecorationCard,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage( url: product.picture,),
            _ProductItem(id: product.id!, name: product.name,),
            Positioned(top: 0, right: 0, child: _PriceStart( price: product.price)),
            !product.available ? Positioned(top: 0, left: 0, child: _NotAvailable()) : Container()
          ],
        ),
      ),
    );
  }
}

class _NotAvailable extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const boxDecoration = BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20), topLeft: Radius.circular(20)),
    );
    
    return Container(
      width: size.width * 0.3,
      height: 50,
      decoration: boxDecoration,
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('No disponible',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
      ),
      ),
    );
  }
}

class _PriceStart extends StatelessWidget {

  final double price;

  const _PriceStart({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const boxDecoration = BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20), topRight: Radius.circular(20)),
    );

    return Container(
      width: size.width * 0.3,
      height: 50,
      decoration: boxDecoration,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            '\$$price',
            style: TextStyle(fontSize: 16, color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {

  final String name;
  final String id;

  const _ProductItem({super.key, required this.name, required this.id});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    var boxDecoration = const BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20), topRight: Radius.circular(20)),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: size.width * 0.6,
      height: 70,
      decoration: boxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            id,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {

  final String? url;

  const _BackgroundImage({
    Key? key, this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 400,
        child: url == null 
        ? const Image(image: AssetImage('assets/no-image.png'), fit: BoxFit.cover ,)
        : FadeInImage(
          placeholder: const AssetImage('assets/jar-loading.gif'),
          image: NetworkImage( url! ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
