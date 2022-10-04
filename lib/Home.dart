import 'package:consumo_servico_avancado/Post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _urlBase = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _recuperarPostagens() async {

    http.Response response = await http.get(Uri.parse("${_urlBase}/posts"));
    var dadosJson = json.decode(response.body);

    List<Post> postagens = [];
    for(var post in dadosJson){

      //print("post: " + post["title"]);
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      postagens.add(p);

    }
    return postagens;

    //print( postagens.toString() );

  }

  _post() async {

    Post post = Post(120, null, 'Titulo', 'Corpo da postagem');

    var corpo = json.encode(
        post.toJson()
    );

    http.Response response = await http.post(
      Uri.parse("${ _urlBase }/posts"),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: corpo,
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");

  }

  _put() async {

    var corpo = json.encode(
        {
          'id': null,
          'title': 'Titulo alterado',
          'body': 'Corpo da postagem alterada',
          'userId': 120
        }
    );

    http.Response response = await http.put(
      Uri.parse("${ _urlBase }/posts/2"),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: corpo,
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");

  }

  _patch() async{

    var corpo = json.encode(
        {
          'body': 'Corpo da postagem alterada',
          'userId': 120
        }
    );

    http.Response response = await http.patch(
      Uri.parse("$_urlBase/posts/2"),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: corpo,
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");

  }

  _delete() async {

    http.Response response = await http.delete(
      Uri.parse('$_urlBase/posts/1')
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço anvançado"),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                    onPressed: _post,
                    child: Text("Salvar")
                ),
                ElevatedButton(
                    onPressed: _patch,
                    child: Text("Atualizar")
                ),
                ElevatedButton(
                    onPressed: _delete,
                    child: Text("Deletar")
                )
              ],
            ),
            Expanded(
                child: FutureBuilder<List<Post>>(
                  future: _recuperarPostagens(),
                  builder: (context, snapshot){

                    switch(snapshot.connectionState){
                      case ConnectionState.none:
                        return Text("");
                        break;
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        break;
                      case ConnectionState.active:
                        return Text("");
                        break;
                      case ConnectionState.done:
                      //print("conexao done");
                        if(snapshot.hasError){
                          //print("lista: Erro ao carregar ");

                          return Text("lista: Erro ao carregar ");

                        } else {

                          //print("lista: carregou!! ");

                          List<Post> lista = snapshot.data ?? [];

                          return ListView.builder(
                              itemCount: lista.length,
                              itemBuilder: (context, index) {

                                Post post = lista[index];

                                return ListTile(
                                  title: Text(post.title),
                                  subtitle: Text(post.id.toString()),
                                );
                              }
                          );
                        }
                        break;
                    }
                  },
                )
            ),


          ],
        ),
      ),
    );
  }
}
