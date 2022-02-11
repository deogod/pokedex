import 'package:flutter/material.dart';
import 'package:pokedex/ui/cadastro_dois.dart';

class CadastroUm extends StatefulWidget {
  const CadastroUm({Key? key}) : super(key: key);

  @override
  _CadastroUmState createState() => _CadastroUmState();
}

class _CadastroUmState extends State<CadastroUm> {

  TextEditingController txtcont = TextEditingController();
  late String userName;

  String _userName(){

  userName = txtcont.text;
    return userName;
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
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Let's meet each other first?",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
               const SizedBox(
                  height: 120,
                ),
                const Text(
                  "First we need to know your name...",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: txtcont,
                    decoration:const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 80,),
                IconButton(onPressed: () {
                  _userName();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => 
                           CadastroDois(userName: userName)  ));
                }, icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 60,))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
