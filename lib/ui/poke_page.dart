import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PokePage extends StatefulWidget {
  Map<dynamic, dynamic> map;

  PokePage({Key? key, required this.map}) : super(key: key);

  @override
  _PokePageState createState() => _PokePageState();
}

class _PokePageState extends State<PokePage> {
  http.Response? response;

  Future<String> _getPoke() async {
    response = await http.get(Uri.parse(widget.map['pokemon']['url']));
    final jsonMap = json.decode(response!.body);

    return jsonMap['sprites']['front_default'];
  }

  Future<Map> _getPokeDetail(String resp) async {
    response = await http.get(Uri.parse(resp));
    final jsonMap = json.decode(response!.body);

    return jsonMap;
  }

  @override
  void initState() {
    super.initState();
    _getPoke();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _getPoke(),
        builder: (context, snapshot) {
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.map['pokemon']['name']),
                backgroundColor: Colors.black,
              ),
              backgroundColor: Colors.white,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    snapshot.data!,
                    height: 250,
                    width: 140,
                    fit: BoxFit.contain,
                  ),
                  Expanded(
                    child: FutureBuilder<Map>(
                        future: _getPokeDetail(widget.map['pokemon']['url']),
                        builder: (context, snapshot) {
                          if (snapshot.hasError || snapshot.data == null) {
                            return const Center(
                            child: CircularProgressIndicator());
                          }
                          final list = snapshot.data!['moves'] as List;
                          return ListView.builder(
                              itemCount: list.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return _createMoveSet(context, list[index]);
                              });
                        }),
                  ),
                ],
              ),
            );
          }
        });
  }

  Widget _createMoveSet(BuildContext context, Map<String, dynamic> map) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 10, 10),
      child: Text(map['move']['name'],style: const TextStyle(
                  color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800)),
    );
  }
}
