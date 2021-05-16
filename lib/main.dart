import 'package:elocations/helpers/database_helper.dart';
import 'package:elocations/models/elocation.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'views/elocation_page.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eLocations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreenClass(),
    );
  }
}

class SplashScreenClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 4,
      navigateAfterSeconds: new MyHomePage(title: 'eLocations'),
      image: Image.asset("assets/splash/splash_bg.png"),
      backgroundColor: Color(0xFF2196F3),
      useLoader: true,
      loadingText: Text(
        "Carregando App",
        style: TextStyle(color: Colors.white),
      ),
      photoSize: 160.0,
      loaderColor: Colors.white,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper db = DatabaseHelper();

  List<Elocation> elocations = List<Elocation>();

  @override
  void initState() {
    super.initState();
    _showAllElocations();
  }

  void _showAllElocations() {
    db.getElocations().then((lista) {
      setState(() {
        elocations = lista;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: elocations.length,
          itemBuilder: (context, index) {
            return _listaElocations(context, index);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showElocationPage();
        },
        tooltip: 'Nova eLocation',
        child: Icon(Icons.add),
      ),
    );
  }

  _listaElocations(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      elocations[index].title.length > 26
                          ? '${elocations[index].title.substring(0, 26)}...'
                          : elocations[index].title ?? "",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      elocations[index].address.length > 30
                          ? '${elocations[index].address.substring(0, 30)}...'
                          : elocations[index].address ?? "",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      elocations[index].category.length > 32
                          ? '${elocations[index].category.substring(0, 32)}...'
                          : elocations[index].category ?? "",
                      style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  confirmDelete(context, elocations[index].id, index);
                },
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showElocationPage(elocation: elocations[index]);
      },
    );
  }

  void _showElocationPage({Elocation elocation}) async {
    final elocationRecebido = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ElocationPage(elocation: elocation),
      ),
    );

    if (elocationRecebido != null) {
      if (elocation != null) {
        await db.updateElocation(elocationRecebido);
      } else {
        await db.insertElocation(elocationRecebido);
      }
      _showAllElocations();
    }
  }

  void confirmDelete(BuildContext context, int elocationid, index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Excluir eLocation"),
          content: Text("Confirma a exclusão do ${elocations[index].title}?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Excluir"),
              onPressed: () {
                setState(() {
                  elocations.removeAt(index);
                  db.deleteElocation(elocationid);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
