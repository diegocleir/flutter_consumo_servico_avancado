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

  _post(){

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
                )
              ],
            ),

            FutureBuilder<List<Post>>(
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

          ],
        ),
      ),
    );
  }
}
