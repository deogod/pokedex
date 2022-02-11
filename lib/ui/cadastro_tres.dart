import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokedex/ui/poke_page.dart';

class CadastroTres extends StatefulWidget {
  final String poketype1;
  const CadastroTres({Key? key, required this.poketype1}) : super(key: key);

  @override
  _CadastroTresState createState() => _CadastroTresState();
}

class _CadastroTresState extends State<CadastroTres> {
  http.Response? response;
  late String pokeType;
  late bool loading;
  late List<dynamic> pokemons;
  late List<dynamic> pokemonsCache;

  void _onElementTypePressed(String type) {
    pokeType = type;
    fetchPokemons(type);
  }

  Future<Map> _getPokemons(String poketype) async {
    response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/type/$poketype'));

    final jsonMap1 = json.decode(response!.body);

    return jsonMap1;
  }

  Future<String> _getPokeIcon(String resp) async {
    response = await http.get(Uri.parse(resp));
    final jsonMap = json.decode(response!.body);

    return jsonMap['sprites']['front_default'];
  }

  Future<Map> _getTypes() async {
    response = await http.get(Uri.parse(
        'https://vortigo.blob.core.windows.net/files/pokemon/data/types.json'));

    final jsonMap = json.decode(response!.body);

    return jsonMap;
  }

  @override
  void initState() {
    super.initState();
    pokeType = widget.poketype1;
    pokemons = [];
    fetchPokemons(pokeType);
  }

  Widget buildPoke() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: pokemons.length,
      itemBuilder: (context, index) {
        return _createList(context, pokemons[index]);
      },
    );
  }

  Future<void> fetchPokemons(String pokeType) async {
    setState(() {
      loading = true;
    });

    final requestedPokemons = await _getPokemons(pokeType);
    pokemonsCache = requestedPokemons["pokemon"];

    setState(() {
      pokemons = requestedPokemons["pokemon"];
      loading = false;
    });
  }

  void searchByQuerry(String? query) {
    final filter = pokemonsCache
        .where(
          (element) => element["pokemon"]["name"].contains(query),
        )
        .toList();
        setState(() {
          pokemons = filter;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 37, 224, 199),
        title:  TextField(
          decoration: const InputDecoration(
              labelText: "Pesquisa",
              labelStyle: TextStyle(color: Colors.white, fontSize: 20)),
              onChanged: searchByQuerry
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder(
              future: _getTypes(),
              builder: (context, snapshot) {
                if (snapshot.hasError || snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _createIcons(context, snapshot);
              }),
          Expanded(child: buildPoke()),
        ],
      ),
    );
  }

  Widget _createLists(BuildContext context, AsyncSnapshot snapshot) {
    final list = snapshot.data['pokemon'] as List;
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _createList(context, list[index]);
      },
    );
  }

  Widget _createList(BuildContext context, Map<String, dynamic> map) {
    
    return FutureBuilder<String>(
        future: _getPokeIcon(map['pokemon']['url']),
        builder: (context, snapshot) {
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListTile(
              title: Text(map['pokemon']['name']),
              leading: Image.network(
                snapshot.data!,
                height: 75,
                width: 75,
              )
              , onTap: (){
                Navigator.push(context,
              MaterialPageRoute(builder: (context) => PokePage(map: map)));
              },
              );
        });
  }

  Widget _createIcons(BuildContext context, AsyncSnapshot snapshot) {
    final list = snapshot.data['results'] as List;

    return SizedBox(
      height: 125,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _createIcon(context, list[index]);
        },
      ),
    );
  }

  Widget _createIcon(BuildContext context, Map<String, dynamic> map) {
    return GestureDetector(
      child: Column(
        children: [
          Image.network(
            map['thumbnailImage'],
            width: 100.0,
            height: 100.0,
          ),
          Text(
            map['name'],
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800),
          )
        ],
      ),
      onTap: () => _onElementTypePressed(map['name']),
    );
  }
}
