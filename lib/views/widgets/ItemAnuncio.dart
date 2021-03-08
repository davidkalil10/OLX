import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/Anuncio.dart';

class ItemAnuncio extends StatelessWidget {

  Anuncio anuncio;
  VoidCallback onTapItem;
  VoidCallback onPressedRemover;
  bool tag;

  ItemAnuncio({
    @required this.anuncio,
    this.onTapItem,
    this.onPressedRemover,
    this.tag = false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              //Imagem
              SizedBox(
                height: 120,
                width: 120,
                child:
                tag ? Image.network(anuncio.fotos[0],fit: BoxFit.cover)
                     : Hero(child: Image.network(anuncio.fotos[0],fit: BoxFit.cover),tag: anuncio.fotos[0],),
              ),
              //Título e preço
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                            this.anuncio.titulo,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text("R\$ ${this.anuncio.preco}")
                    ],
                  ),
                ),
              ),
              //Botão remover
              //Exibir somente se há essa função
              if(this.onPressedRemover != null ) Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: this.onPressedRemover,
                  child: Icon(Icons.delete, color: Colors.white,),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
