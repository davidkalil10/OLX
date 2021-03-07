import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:olx/main.dart';
import 'package:olx/models/Anuncio.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesAnuncio extends StatefulWidget {

  Anuncio anuncio;


  DetalhesAnuncio(this.anuncio);

  @override
  _DetalhesAnuncioState createState() => _DetalhesAnuncioState();
}

class _DetalhesAnuncioState extends State<DetalhesAnuncio> {

  Anuncio _anuncio;

  List<Widget> _getListaImagens(){
    List<String> listaUrlImagens = _anuncio.fotos;
    return listaUrlImagens.map((url){
      return Container(
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.fitWidth
          )
        ),
      );
    }).toList();
  }

  _ligarTelefone(String telefone)async{

    if(await canLaunch("tel:$telefone")){
      await launch("tel:$telefone");
    }else{
      print("Não pode fazer a ligação!");
    }
  }

  _chamarWhatsapp(String telefone)async{

    String urlWhatsapp = "https://api.whatsapp.com/send?phone=55"+telefone+"&text=Ol%C3%A1%2C%20tudo%20bem%3F%20Tenho%20interesse%20no%20seu%20an%C3%BAncio!";
    if(await canLaunch(urlWhatsapp)){
      await launch(urlWhatsapp);
    }else{
      print("Não pode chamar Whatsapp!");
    }
  }

  @override
  void initState() {
    super.initState();
    _anuncio = widget.anuncio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anúncio"),
      ),
      body: Stack(
        children: [
          //Contéudos
          ListView(
            children: [
              SizedBox(
                height: 250,
                child: Carousel(
                  images: _getListaImagens(),
                  dotSize: 8,
                  dotBgColor: Colors.transparent,
                  dotIncreasedColor: temaPadrao.primaryColor,
                  autoplay: false,
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                    "R\$ ${_anuncio.preco}",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: temaPadrao.primaryColor
                    ),
                  ),
                    Text(
                      "${_anuncio.titulo}",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      "Descrição",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${_anuncio.descricao}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      "Telefone",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 66),
                      child: Text(
                        "${_anuncio.telefone}",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),

                ],),
              )
            ],
          ),
          //Botão ligar // Whatsapp
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.phone,color: Colors.white,),
                          Text(
                            "Ligar",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            ),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: temaPadrao.primaryColor,
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    onTap: (){
                      _ligarTelefone(_anuncio.telefone);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.phone,color: Colors.white,),
                          Text(
                            "Whatsapp",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            ),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xff25D366),
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    onTap: (){
                      _chamarWhatsapp(_anuncio.telefone);
                    },
                  ),
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}
