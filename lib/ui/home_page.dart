import 'package:flutter/material.dart';
import 'package:pokedex/ui/cadastro_um.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image:  DecorationImage(
                image: AssetImage('assets/images/intro.png'), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => 
                          const CadastroUm()  ));
              },
              child: const Text(
                "Let's go!",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.pink,
                  textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                  fixedSize: const Size.fromWidth(200)),
            )
          ],
        ),
      ),
    );
  }
}
