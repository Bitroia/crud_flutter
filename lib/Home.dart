import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados () async {

    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco.db");

   var bd = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: (db, dbVersaoRecente){
        String sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
        db.execute(sql);
      }
    );

   return bd;

  }

  _salvar() async{

    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "nome" :" junin",
      "idade" : 60
    };

   int id = await bd.insert("usuarios", dadosUsuario);
   print ("Salvo: $id");
  }

  _listarUsuarios() async {

    Database bd = await _recuperarBancoDados();
    String sql ="SELECT * FROM usuarios";
    List usuarios = await bd.rawQuery(sql);

    print ("usuarios: " + usuarios.toString());

    for (var usuario in usuarios){
      print ("item id: " + usuario["id"].toString() +
          " nome " + usuario["nome"] +
          " idade " + usuario ["idade"].toString()
      );
    }
  }

  _listarUsuariosPeloId(int id) async {

    Database bd = await _recuperarBancoDados();
    List usuarios = await bd.query(
        "usuarios",
        columns: ["id", "nome", "idade"],
        where: "id = ?",
        whereArgs: [id]
    );

    for (var usuario in usuarios){
      print ("item id: " + usuario["id"].toString() +
          " nome " + usuario["nome"] +
          " idade " + usuario ["idade"].toString()
      );
    }
  }

  _excluirUsuario(int id) async {
    Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete(
        "usuarios",
      where: "nome = ? AND idade = ?",
      whereArgs: ["vitorinha", 21],
    );

    print("item qtde removida: $retorno");
  }

  _atualizarUsuario(int id) async {
    Database bd = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome" : "joao",
      "idade" : 38
    };
    int retorno = await bd.update(
        "usuarios", dadosUsuario,
      where: "id=?",
      whereArgs: [id]
    );

    print ("item qtde atualizada: $retorno");
  }

  @override
  Widget build(BuildContext context) {

    _salvar();
    //_excluirUsuario(2);
    //_atualizarUsuario(3);
    _listarUsuarios();
    //_listarUsuariosPeloId(1);

    return const Placeholder();
  }
}
