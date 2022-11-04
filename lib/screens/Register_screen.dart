import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_provider.dart';
import 'package:productos_app/widgets/card_container.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';
import '../ui/input_decorations.dart';


class RegisterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background( 
        child : SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox( height: 200,),
              CardContainer( child: Column(
                children: [
                  const SizedBox( height: 10,),
                  const Text('Crear cuenta', style: TextStyle( fontSize: 28, fontStyle: FontStyle.italic, color: Colors.black54),), 
                  Container(),
                  const SizedBox( height: 30,),
                  // provider en solo una screen
                  ChangeNotifierProvider(create: ( _ ) => LoginFormProvider(), 
                  child: _LoginForm(),
                  )                  
                ],
              ),),
              const SizedBox( height: 50,),
              TextButton(
                style: ButtonStyle( 
                  overlayColor: MaterialStateProperty.all( Colors.indigo.withOpacity(0.4),),
                  shape: MaterialStateProperty.all( StadiumBorder() )                  
                ),
                onPressed: ()=> Navigator.pushReplacementNamed(context, 'login'),
                child: Text( '¿Ya tienes una cuenta?', style: TextStyle( fontSize: 18, color: Colors.black87 ))),             
              const SizedBox( height: 80,),
            ],
          ),
        ))
   );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
        //Todo referencia a KEY
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoracion(hintText: 'jhon@gmail.com', labelText: 'Correo electronico', prefixIcon: Icons.alternate_email),
              onChanged: ( value ) => loginForm.email = value,              
              validator: (value) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                  ? null 
                  : 'El valor ingresado no es un correo';                
              },
            ),
            const SizedBox( height: 30,),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              onChanged: ( value ) => loginForm.password = value,  
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoracion(hintText: '********', labelText: 'Contraseña', prefixIcon: Icons.lock_outline),
              validator: (value) {
                 return ( value != null && value.length >= 6 ) 
                    ? null
                    : 'La contraseña debe de ser de 6 caracteres';               
              },
            
            ),
            const SizedBox( height: 30,),
            MaterialButton(
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed:loginForm.isLoading ? null : () async {                
                FocusScope.of(context).unfocus();            
                final authService = Provider.of<AuthService>(context, listen: false);

                if( !loginForm.isValidForm() ) return;
                loginForm.isLoading = true;

                final String? message = await authService.createUser(loginForm.email, loginForm.password);
                if ( message == null){
                  Navigator.pushReplacementNamed(context, 'home');
                } else {
                  NotificationsService.showSnackbar(  message );
                  loginForm.isLoading = false;       
                }      

              },
              child: Container(
                padding:  const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                child: Text(
                  loginForm.isLoading 
                    ? 'Espere'
                    : 'Ingresar',
                  style: TextStyle( color: Colors.white ),
                ))),
            const SizedBox( height: 30,),
          ],
        )),
    );
  }
}