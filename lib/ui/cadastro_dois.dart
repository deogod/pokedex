import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/ui/cadastro_tres.dart';


class CadastroDois extends StatefulWidget {
  final String userName;

  const CadastroDois({Key? key, required this.userName}) : super(key: key);

  @override
  _CadastroDoisState createState() => _CadastroDoisState();
}

class _CadastroDoisState extends State<CadastroDois> {
  http.Response? response;
  String poketype1 = "water";

  Future<Map> _getTypes() async {
    response = await http.get(Uri.parse(
        'https://vortigo.blob.core.windows.net/files/pokemon/data/types.json'));

    final jsonMap = json.decode(response!.body);

    return jsonMap;
  }

  String dropDownValue = 'Type';
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hello, trainer ${widget.userName}!",
              style: const TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.start,
            ),
             const SizedBox(
              height: 100,
            ),
            const Padding(
              padding: EdgeInsets.all(17.0),
              child: Text(
                "...now tell us wich is your favorite Pokémon type:",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
           const SizedBox(
              height: 40,
            ),
            IconButton(
                onPressed: () {
                  _onButtonPressed();
                },
                icon:const Icon(
                  CupertinoIcons.chevron_down,
                  color: Colors.white,
                  size: 60,
                )),
          ],
        ),
      ),
    );
  }

  void _onButtonPressed() async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.white,
            height: 300,
            child: Container(
              child: _buildBottomNavigationMenu(),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft:  Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildBottomNavigationMenu() {
    return FutureBuilder(
        future: _getTypes(),
        builder: (context, snapshot) {
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _createIcons(context, snapshot);
        });
  }

  Widget _createIcons(BuildContext context, AsyncSnapshot snapshot) {
    final list = snapshot.data['results'] as List;

    return SizedBox(
      height: 125,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _createIcon(context, list[index]);
        },
      ),
    );
  }

  Widget _createIcon(BuildContext context, Map<String, dynamic> map)  {
    return GestureDetector(
        child: Row(
          children: [
            Image.network(
              map['thumbnailImage'],
              width: 100.0,
              height: 100.0,
            ),
            Text(
              map['name'],
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w800),
            )
          ],
        ),
        onTap:  () {
          poketype1 = map['name'];
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CadastroTres(poketype1: poketype1)));
        });
  }
}
