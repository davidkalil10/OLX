import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemAnuncio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              //Imagem
              SizedBox(
                height: 120,
                width: 120,
                child: Container(color: Colors.orange,),
              ),
              //Título e preço
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                  child: Column(
                   // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                            "Nintendo Switch",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text("R\$ 2.000,00")
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: (){},
                  child: Icon(Icons.delete, color: Colors.white,),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red
                  ),
                ),
              )
              //Botão remover
            ],
          ),
        ),
      ),
    );
  }
}
