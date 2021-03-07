import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/Anuncio.dart';
import 'package:olx/util/Configuracoes.dart';
import 'package:olx/views/widgets/ItemAnuncio.dart';
import 'package:olx/views/widgets/ProgressPersonalizado.dart';

class Anuncios extends StatefulWidget {
  @override
  _AnunciosState createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();

  List<String> itensMenu = [];
  String _itemSelecionadoEstado;
  String _itemSelecionadoCategoria;
  List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  List<DropdownMenuItem<String>> _listaItensDropCategorias = [];

  //configurar no controller os dados do anúncio
  Future<Stream<QuerySnapshot>> _adicionarListenerAnuncios() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("anuncios")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  //filtrando anúncios
  Future<Stream<QuerySnapshot>> _filtrarAnuncios() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = db.collection("anuncios");

    if(_itemSelecionadoEstado != null){
      query = query.where("estado", isEqualTo: _itemSelecionadoEstado);
    }
    if(_itemSelecionadoCategoria!= null){
      query = query.where("categoria", isEqualTo: _itemSelecionadoCategoria);
    }

    Stream<QuerySnapshot> stream = query.snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }


  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Meus anúncios":
        Navigator.pushNamed(context, "/meus-anuncios");
        break;
      case "Entrar / Cadastrar":
        Navigator.pushReplacementNamed(context, "/login");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser;

    if (usuarioLogado == null) {
      itensMenu = ["Entrar / Cadastrar"];
    } else {
      itensMenu = ["Meus anúncios", "Deslogar"];
    }
  }

  _carregarItensDropDown() {
    //Estados
    _listaItensDropEstados = Configuracoes().getEstados();

    //Categorias
    _listaItensDropCategorias = Configuracoes().getCategorias();

  }


  @override
  void initState() {
    super.initState();
    _carregarItensDropDown();
    _verificarUsuarioLogado();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    var carregandoDados = Center(
      child: ProgressPersonalizado(
        texto: "Carregando anúncios",
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("OLX"),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        child: Column(children: [
          //Area de Filtros
          Row(
            children: [
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: Center(
                    child: DropdownButton(
                      hint: Text("Região", style: TextStyle(color: Theme.of(context).primaryColor),),
                      iconEnabledColor: Theme.of(context).primaryColor,
                      value: _itemSelecionadoEstado,
                      items: _listaItensDropEstados,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black
                      ),
                      onChanged: (estado){
                        setState(() {
                          _itemSelecionadoEstado = estado;
                          _filtrarAnuncios();
                        });
                      },
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.grey[200],
                width: 2,
                height: 60,
              ),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: Center(
                    child: DropdownButton(
                      hint: Text("Categorias", style: TextStyle(color: Theme.of(context).primaryColor),),
                      iconEnabledColor: Theme.of(context).primaryColor,
                      value: _itemSelecionadoCategoria,
                      items: _listaItensDropCategorias,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.black
                      ),
                      onChanged: (categoria){
                        setState(() {
                          _itemSelecionadoCategoria = categoria;
                          _filtrarAnuncios();
                        });
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
          //Area de listagem de anúncios
          StreamBuilder(
            stream: _controller.stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return carregandoDados;
                  break;
                case ConnectionState.active:
                case ConnectionState.done:
                //Exibe mensagem de erro caso haja
                  if (snapshot.hasError) {
                    return Text("Erro ao carregar os dados!");
                  }
                  QuerySnapshot querySnapshot = snapshot.data;
                  if(querySnapshot.docs.length ==0){
                    return Container(
                      padding: EdgeInsets.all(25),
                      child: Text("Nenhum anúncio! :(", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (_, index) {
                          List<DocumentSnapshot> anuncios =
                          querySnapshot.docs.toList();
                          DocumentSnapshot documentSnapshot = anuncios[index];
                          Anuncio anuncio =
                          Anuncio.fromDocumentSnapshot(documentSnapshot);

                          return ItemAnuncio(
                            anuncio: anuncio,
                            onTapItem: (){
                                Navigator.pushNamed(
                                    context,
                                    "/detalhes-anuncio",
                                    arguments: anuncio
                                );
                            },
                          );
                        }),
                  );
              }
              return Container();
            },
          )
        ],),
      ),
    );
  }
}
