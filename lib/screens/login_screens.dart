import 'package:flutter/material.dart';
import 'package:products_app/providers/login_form_provider.dart';
import 'package:products_app/ui/input_decorations.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

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
              ChangeNotifierProvider(
                // Se crea instancia de LoginFormProvider
                create: (_) => LoginFormProvider(),
                child: const _LoginForm(),
              ),
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
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Form(
        key: loginForm.formKey,
        // TODO: Mantener la referencia al KEY
        // autovalidateMode: Permite mostrar un texto de error debajo del inputText
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'You must enter a valid email';
              },
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
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                if (value != null && value.length >= 6) return null;
                return 'Password must be at least 6 characters';
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        // Oculta el teclado al hacer onPress
                        FocusScope.of(context).unfocus();
                        // Se verifica que el form sea válido
                        if (!loginForm.isValidForm()) return;
                        // Se setea el valor de _isLoading en true
                        loginForm.isLoading = true;
                        // Se esperan 2 segundos
                        await Future.delayed(const Duration(seconds: 2));
                        // Se setea el valor de _isLoading en false. De esta form ase simula el consumo de un api en el login
                        // TODO: Validar si el login es correcto
                        loginForm.isLoading = false;
                        // Redirecciona a la ruta especificada
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(context, 'home');
                      },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? 'Loading' : 'Log In',
                    style: const TextStyle(color: Colors.white),
                  ),
                ))
          ],
        ));
  }
}
