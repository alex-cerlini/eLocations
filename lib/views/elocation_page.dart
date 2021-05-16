import 'dart:io';

import 'package:elocations/models/elocation.dart';
import 'package:flutter/material.dart';
import 'package:elocations/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:image_picker/image_picker.dart';

class ElocationPage extends StatefulWidget {
  final Elocation elocation;
  ElocationPage({this.elocation});

  @override
  _ElocationPageState createState() => _ElocationPageState();
}

class _ElocationPageState extends State<ElocationPage> {
  String _chosenValueState;
  String _chosenValueCategory;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _categoryController = TextEditingController();

  bool editado = false;
  Elocation _editaElocation;

  @override
  void initState() {
    super.initState();

    if (widget.elocation == null) {
      _editaElocation = Elocation(null, "", "", "", "", "", "", null);
    } else {
      _editaElocation = Elocation.fromMap(widget.elocation.toMap());
      _titleController.text = _editaElocation.title;
      _descriptionController.text = _editaElocation.description;
      _addressController.text = _editaElocation.address;
      _cityController.text = _editaElocation.city;
      _stateController.text = _editaElocation.state;
      _categoryController.text = _editaElocation.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.list),
                    ),
                    Text("Dados"),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.image),
                    ),
                    Text("Imagens"),
                  ],
                ),
              ),
            ],
          ),
          title: Text(_editaElocation.title == ''
              ? "Nova eLocation"
              : _editaElocation.title),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.label),
                      hintText: 'Como é o Título deste eLocation?',
                      labelText: 'Título*:',
                    ),
                    onChanged: (text) {
                      editado = true;
                      setState(() {
                        _editaElocation.title = text;
                      });
                    },
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.description),
                        hintText:
                            'Insira aqui a descrição deste eLocation! Pressione ENTER para pular de linha.',
                        labelText: 'Descrição:'),
                    onChanged: (text) {
                      editado = true;
                      setState(() {
                        _editaElocation.description = text;
                      });
                    },
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.add_road),
                      hintText: 'Qual endereço fica este eLocation?',
                      labelText: 'Endereço*:',
                    ),
                    onChanged: (text) {
                      editado = true;
                      setState(() {
                        _editaElocation.address = text;
                      });
                    },
                  ),
                  TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.home),
                      hintText: 'Em qual cidade fica este eLocation?',
                      labelText: 'Cidade*:',
                    ),
                    onChanged: (text) {
                      editado = true;
                      setState(() {
                        _editaElocation.city = text;
                      });
                    },
                  ),
                  TextField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.home),
                      hintText: 'Em qual estado fica este eLocation?',
                      labelText: 'Estado*:',
                    ),
                    onChanged: (text) {
                      editado = true;
                      setState(() {
                        _editaElocation.state = text;
                      });
                    },
                  ),
                  TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.home),
                      hintText: 'Qual categoria deste eLocation?',
                      labelText: 'Categoria*:',
                    ),
                    onChanged: (text) {
                      editado = true;
                      setState(() {
                        _editaElocation.category = text;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white70,
                              side: BorderSide(width: 1, color: Colors.red)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Voltar",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_editaElocation.title != null &&
                                _editaElocation.title.isNotEmpty &&
                                _editaElocation.address.isNotEmpty &&
                                _editaElocation.city.isNotEmpty &&
                                _editaElocation.state.isNotEmpty &&
                                _editaElocation.category.isNotEmpty) {
                              Navigator.pop(context, _editaElocation);
                            } else {
                              _showAlert();
                            }
                          },
                          child: Text("Salvar"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: _editaElocation.image != null &&
                                        _editaElocation.image.isNotEmpty
                                    ? FileImage(
                                        File(_editaElocation.image),
                                      )
                                    : AssetImage(
                                        "assets/default/default_image.png"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      ImagePicker()
                          .getImage(source: ImageSource.camera)
                          .then((file) {
                        if (file == null) return;
                        setState(() {
                          _editaElocation.image = file.path;
                        });
                      });
                    },
                  ),
                  GestureDetector(
                    child:
                        Icon(Icons.remove_circle, color: Colors.red, size: 30),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Excluir imagem"),
                            content: Text("Confirma a exclusão da imagem?"),
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
                                    _editaElocation.image = null;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Alerta"),
            content: new Text("Não deixe campos obrigatórios em branco."),
            actions: [
              new TextButton(
                child: new Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
