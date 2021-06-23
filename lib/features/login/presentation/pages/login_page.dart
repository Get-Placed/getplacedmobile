import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_placed/features/login/presentation/bloc/login_bloc.dart';
import 'package:get_placed/features/login/presentation/bloc/login_event.dart';
import 'package:get_placed/features/login/presentation/bloc/login_state.dart';
import 'package:get_placed/features/login/presentation/dto/login_dto.dart';
import 'package:get_placed/features/login/presentation/widgets/loading_widget.dart';

import '../../../../injection_container.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc _bloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String inputLogin;
  late String inputPassword;
  late Key key;

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _bloc = serviceLocator<LoginBloc>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Demo'),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return BlocProvider(
      create: (_) => _bloc,
      child: BlocListener(
        bloc: _bloc,
        listener: (context, state) {
          if (state is ErrorLoggedState) {
            final snackBar = SnackBar(content: Text('Invalid credentials...'));
            // ignore: deprecated_member_use
            Scaffold.of(context).showSnackBar(snackBar);
          } else if (state is LoggedState) {
            final snackBar = SnackBar(content: Text('User logged...'));
            // ignore: deprecated_member_use
            Scaffold.of(context).showSnackBar(snackBar);
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (BuildContext context, state) {
            if (state is InitialLoginState) {
              return _buildForm();
            } else if (state is CheckingLoginState) {
              return LoadingWidget(
                key: key,
              );
            } else {
              return _buildForm();
            }
          },
        ),
      ),
    );
  }

  _buildForm() {
    return Form(
      autovalidateMode: AutovalidateMode.disabled,
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Placeholder(
              fallbackWidth: 150,
              fallbackHeight: 100,
            ),
            SizedBox(
              height: 30.0,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter the username',
                labelText: 'Username *',
              ),
              onChanged: (value) {
                inputLogin = value;
              },
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return value!.isEmpty ? 'Username is mandatory' : null;
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter the password',
                labelText: 'Password *',
              ),
              onChanged: (value) {
                inputPassword = value;
              },
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return value!.isEmpty ? 'Password is mandatory' : null;
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black12),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final loginDTO = LoginDTO(
                    username: inputLogin,
                    password: inputPassword,
                  );
                  _bloc.add(CheckLoginEvent(login: loginDTO));
                }
              },
              child: Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}
