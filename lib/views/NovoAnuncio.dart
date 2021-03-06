import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/views/widgets/BotaoCustomizado.dart';

class NovoAnuncio extends StatefulWidget {
  @override
  _NovoAnuncioState createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {

  List<PickedFile> _listaImagens = [];

  final _formKey = GlobalKey<FormState>();

  _selecionarImagemGalera() async{

    PickedFile imagemSelecionada = (await ImagePicker().getImage(source: ImageSource.gallery));

    if (imagemSelecionada!= null){
      setState(() {
        _listaImagens.add(imagemSelecionada);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Anúncio"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //area de imagens
                FormField<List>(
                  initialValue: _listaImagens,
                  validator: (imagens) {
                    if (imagens.length == 0) {
                      return "Necessário selecionar uma imagem";
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(children: [
                      Container(
                        height: 100,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _listaImagens.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _listaImagens.length) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      _selecionarImagemGalera();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 50,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 40,
                                            color: Colors.grey[100],
                                          ),
                                          Text(
                                            "Adicionar",
                                            style: TextStyle(
                                              color: Colors.grey[100]
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (_listaImagens.length > 0) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (_)=> Dialog(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.file(File(_listaImagens[index].path)),
                                              TextButton(
                                                child: Text("Excluir",style: TextStyle(color: Colors.red),),
                                                onPressed: (){
                                                  setState(() {
                                                    _listaImagens.removeAt(index);
                                                    Navigator.of(context).pop();
                                                  });

                                                },
                                              )
                                            ],
                                          ),
                                        )
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: FileImage(File(_listaImagens[index].path)),
                                      child: Container(
                                        color: Color.fromRGBO(255, 255, 255, 0.4),
                                        alignment: Alignment.center,
                                        child: Icon(Icons.delete,color: Colors.red,),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            }
                        ),
                      ),
                      state.hasError
                          ? Container(child:
                      Text(
                        "[${state.errorText}]",
                        style: TextStyle(
                            color: Colors.red, fontSize: 14
                        ),
                      ),
                      )
                          : Container()
                    ],);
                  },
                ),
                //menu dropdown
                Row(
                  children: [
                    Text("Estado"),
                    Text("Categoria"),
                  ],
                ),
                //caixa de texto e botoes
                Text("cx de texto"),
                BotaoCustomizado(
                  texto: "Cadastrar anúncio",
                  onPressed: () {
                    if (_formKey.currentState.validate()) {

                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
