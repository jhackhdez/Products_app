import 'package:flutter/material.dart';
import 'package:products_app/ui/input_decorations.dart';
import 'package:products_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 320,
          ),
          CardContainer(
              child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text('Login', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 30),
              const _LoginForm()
            ],
          )),
          const SizedBox(height: 50),
          const Text(
            'Crear una nueva cuenta',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 50),
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
        // TODO: Mantener la referencia al KEY
        child: Column(
      children: [
        TextFormField(
          // Esto permite que no se autocorrija el texto
          autocorrect: false,
          // Esto permite que se muestre @ en el teclado
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecorations.authInputDecoration(
              hintText: 'john.doe@gmail.com',
              labelText: 'Email',
              prefixIcon: Icons.alternate_email_sharp),
        ),
        const SizedBox(height: 30),
        TextFormField(
          // Esto permite que no se autocorrija el texto
          autocorrect: false,
          // Esto para que oculte caracteres del password
          obscureText: true,
          // Esto permite que se muestre @ en el teclado
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecorations.authInputDecoration(
              hintText: '******',
              labelText: 'Password',
              prefixIcon: Icons.lock_outline),
        ),
        const SizedBox(height: 30),
        MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: const Text(
                'Log In',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () {
              //TODO: implementar submit
            })
      ],
    ));
  }
}
