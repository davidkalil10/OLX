import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';


class Configuracoes {

  List<DropdownMenuItem<String>> getCategorias(){

   List<DropdownMenuItem<String>> itensDropCategorias =[];

    //Categorias
   itensDropCategorias
       .add(DropdownMenuItem(child: Text(
       "Categorias",
     style: TextStyle(
      color: Color(0xff9c27b0)
     ),
   ), value:  null));
    itensDropCategorias
        .add(DropdownMenuItem(child: Text("Automóvel"), value: "auto"));
    itensDropCategorias
        .add(DropdownMenuItem(child: Text("Imóvel"), value: "imovel"));
    itensDropCategorias
        .add(DropdownMenuItem(child: Text("Eletrônicos"), value: "eletro"));
    itensDropCategorias
        .add(DropdownMenuItem(child: Text("Moda"), value: "moda"));
    itensDropCategorias
        .add(DropdownMenuItem(child: Text("Esportes"), value: "esportes"));

    return itensDropCategorias;
  }

  List<DropdownMenuItem<String>> getEstados(){

    List<DropdownMenuItem<String>> itensDropEstados =[];

    //Regiões
    itensDropEstados
        .add(DropdownMenuItem(child: Text(
      "Região",
      style: TextStyle(
          color: Color(0xff9c27b0)
      ),
    ), value:  null));

    for (var estado in Estados.listaEstadosSigla) {
      itensDropEstados
          .add(DropdownMenuItem(child: Text(estado,), value: estado));
      print("Aqui: " + estado);
    }


    return itensDropEstados;
  }

}