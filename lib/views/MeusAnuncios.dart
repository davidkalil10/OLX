import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/Anuncio.dart';
import 'package:olx/views/widgets/ItemAnuncio.dart';
import 'package:olx/views/widgets/ProgressPersonalizado.dart';

class MeusAnuncios extends StatefulWidget {
  @override
  _MeusAnunciosState createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _idUsuarioLogado;

  _recuperarDadosUsuarioLogado() async {
    //Recupera ID Usuário logado
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser;
    String idUsuario = usuarioLogado.uid;
    setState(() {
      _idUsuarioLogado = idUsuario;
    });
  }

  //configurar no controller os dados do anúncio
  Future<Stream<QuerySnapshot>> _adicionarListenerAnuncios() async {
    await _recuperarDadosUsuarioLogado();

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("meus_anuncios")
        .doc(_idUsuarioLogado)
        .collection("anuncios")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _removerAnuncio(String idAnuncio) {
    //Remove Anuncio
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("meus_anuncios")
        .doc(_idUsuarioLogado)
        .collection("anuncios")
        .doc(idAnuncio)
        .delete()
        .then((_) {
      //apagar anúncio públic
      db.collection("anuncios").doc(idAnuncio).delete();
    });

    //Remoção arquivos pasta
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref().child("meus_anuncios").child(idAnuncio);
    pastaRaiz.listAll().then((dir) => {
          dir.items.forEach((fileRef) {
            var refFile = storage.ref(pastaRaiz.fullPath);
            var childRef = pastaRaiz.child(fileRef.name);
            childRef.delete();
          })
        });

    //Remover anúncio público
  }

  @override
  void initState() {
    super.initState();
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
        title: Text("Meus anúncios"),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/novo-anuncio");
        },
      ),
      body: StreamBuilder(
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
              return ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (_, index) {
                    List<DocumentSnapshot> anuncios =
                        querySnapshot.docs.toList();
                    DocumentSnapshot documentSnapshot = anuncios[index];
                    Anuncio anuncio =
                        Anuncio.fromDocumentSnapshot(documentSnapshot);

                    return ItemAnuncio(
                      tag: index==0 ?true :false,
                      anuncio: anuncio,
                      onPressedRemover: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Confirmar"),
                                content:
                                    Text("Deseja realmente excluir o anúncio?"),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      "Cancelar",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    child: Text(
                                      "Remover",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      _removerAnuncio(anuncio.id);
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      },
                    );
                  });
          }
          return Container();
        },
      ),
    );
  }
}
