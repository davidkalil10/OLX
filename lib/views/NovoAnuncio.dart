import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/views/widgets/BotaoCustomizado.dart';
import 'package:validadores/Validador.dart';

class NovoAnuncio extends StatefulWidget {
  @override
  _NovoAnuncioState createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {

  List<PickedFile> _listaImagens = [];
  List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  List<DropdownMenuItem<String>> _listaItensDropCategorias = [];
  String _itemSelecionadoEstado;
  String _itemSelecionadoCategoria;
  final _formKey = GlobalKey<FormState>();


  _selecionarImagemGalera() async{

    PickedFile imagemSelecionada = (await ImagePicker().getImage(source: ImageSource.gallery));

    if (imagemSelecionada!= null){
      setState(() {
        _listaImagens.add(imagemSelecionada);
      });
    }

  }

  _carregarItensDropDown(){
    //Estados
    for(var estado in Estados.listaEstadosSigla){
      _listaItensDropEstados.add(DropdownMenuItem(child: Text(estado),value: estado));
      print("Aqui: " +estado);
    }

    //Categorias
    _listaItensDropCategorias.add(DropdownMenuItem(child: Text("Automóvel"),value: "auto"));
    _listaItensDropCategorias.add(DropdownMenuItem(child: Text("Imóvel"),value: "imovel"));
    _listaItensDropCategorias.add(DropdownMenuItem(child: Text("Eletrônicos"),value: "eletro"));
    _listaItensDropCategorias.add(DropdownMenuItem(child: Text("Moda"),value: "moda"));
    _listaItensDropCategorias.add(DropdownMenuItem(child: Text("Esportes"),value: "esportes"));


  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropDown();

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
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          hint: Text("Estados"),
                          value: _itemSelecionadoEstado,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                          ),
                          items: _listaItensDropEstados,
                          validator: (valor){
                            return Validador()
                                .add(Validar.OBRIGATORIO,msg: "Campo obrigatório")
                                .valido(valor);
                          },
                          onChanged: (valor){
                            setState(() {
                              _itemSelecionadoEstado = valor;
                              print(valor);
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          hint: Text("Categorias"),
                          value: _itemSelecionadoCategoria,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20
                          ),
                          items: _listaItensDropCategorias,
                          validator: (valor){
                            return Validador()
                                .add(Validar.OBRIGATORIO,msg: "Campo obrigatório")
                                .valido(valor);
                          },
                          onChanged: (valor){
                            setState(() {
                              _itemSelecionadoCategoria = valor;
                              print(valor);
                            });
                          },
                        ),
                      ),
                    ),
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
