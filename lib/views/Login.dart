import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/Usuario.dart';
import 'file:///C:/Users/david/Desktop/Flutter/olx/lib/views/widgets/InputCustomizado.dart';
import 'package:olx/views/widgets/BotaoCustomizado.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();


  bool _cadastrar = false;
  String _mensagemErro = "";
  String _textoBotao = "Entrar";

  _cadastrarUsuario(Usuario usuario){

    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){
      //Redireciona para tela principal
        Navigator.pushReplacementNamed(context, "/");
    });

  }
  _logarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).onError((error, stackTrace) => error).then((firebaseUser){
      //Redireciona para tela principal
      Navigator.pushReplacementNamed(context, "/");
    });
    
  }

  _validarCampos(){

    //Recupera dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")){
      if(senha.isNotEmpty && senha.length >=6){

        //Configura usuario
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        //Cadastrar ou logar
        if (_cadastrar){
          // Cadastrar
          _cadastrarUsuario(usuario);
        }else{
          //Logar
          _logarUsuario(usuario);
        }

      }else{
        setState(() {
          _mensagemErro = "Preencha a senha! Digite mais de 6 carateres";
        });
      }
    }else{
      setState(() {
        _mensagemErro = "Preencha o E-mail v??lido";
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 32),
                    child: Image.asset(
                      "imagens/logo.png",
                      width: 200,
                      height: 150,
                    ),
                  ),

                InputCustomizado(
                    controller: _controllerEmail,
                    hint: "Email",
                    autofocus: true,
                    type: TextInputType.emailAddress,

                ),
                InputCustomizado(
                  controller: _controllerSenha,
                  hint: "Senha",
                  obscure: true,
                  maxLines: 1,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Logar"),
                    Switch(
                        value: _cadastrar,
                        onChanged: (bool valor){
                          setState(() {
                            _cadastrar = valor;
                            _textoBotao = "Entrar";
                            if(_cadastrar){
                              _textoBotao = "Cadastrar";
                            }
                          });
                        }
                    ),
                    Text("Cadastrar"),
                  ],
                ),
                BotaoCustomizado(
                    texto: _textoBotao,
                  onPressed: (){
                    _validarCampos();
                  },
                ),
                TextButton(
                  child: Text("Ir para an??ncios"),
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, "/");
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(_mensagemErro, style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                  ),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
