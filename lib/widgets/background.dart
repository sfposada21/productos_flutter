
import 'package:flutter/material.dart';


class Background extends StatelessWidget {

  final Widget child;

  const Background({
    super.key, 
    required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      /* color: Colors.amberAccent, */
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _PurpleBox(),
          _IconPerson(),
          child,
        ],
      ),
    );
  }
}

class _IconPerson extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only( top: 30),
        child: Icon( Icons.person_pin, color: Colors.white,size: 100,),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height *0.4,
      decoration: _purpleBox(),
      child: Stack(
        children: const [
          Positioned(top: 110, left: 30, child: _bubble()),
          Positioned(top: -30, left: -10, child: _bubble()),
          Positioned(top: 40, left: 240, child: _bubble()),
          Positioned(top: 250, left: 180, child: _bubble()),
          Positioned(top: 150, left: 340, child: _bubble()),
        ],
      ),
    );
  }

BoxDecoration _purpleBox() => const BoxDecoration(
    gradient: LinearGradient(
      colors: [
      Color.fromRGBO(63,63, 156, 1),
      Color.fromRGBO(90,70, 178, 1)      
      ]
      )
  );
}

class _bubble extends StatelessWidget {
  const _bubble({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color:  Color.fromRGBO(255,255, 255, 0.05) 
        ),        
    );
  }
}