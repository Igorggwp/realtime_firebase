import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "",
      appId: "",
      messagingSenderId: "",
      projectId: "",
      databaseURL: "",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String? _produto;
  TextEditingController _codigoController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _valorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getProduto();
  }

  // codigo desc valor
  Future<void> _getProduto() async {
    final event = await _database.child('produto').once();
    final data = event.snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      setState(() {
        _produto =
            "Código: ${data['codigo']}, Descrição: ${data['desc']}, Valor: ${data['valor']}";
      });
    }
  }

  Future<void> _atualizarProduto() async {
    if (_codigoController.text.isNotEmpty &&
        _descController.text.isNotEmpty &&
        _valorController.text.isNotEmpty) {
      await _database.child('produto').set({
        'codigo': _codigoController.text,
        'desc': _descController.text,
        'valor': _valorController.text,
      });

      _getProduto();

      _codigoController.clear();
      _descController.clear();
      _valorController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Alface")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _produto == null
                  ? CircularProgressIndicator()
                  : Text("Produto: $_produto"),
              SizedBox(height: 20),
              TextField(
                controller: _codigoController,
                decoration: InputDecoration(
                  labelText: "Novo Codigo",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: _valorController,
                decoration: InputDecoration(
                  labelText: "Valor",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _atualizarProduto,
                child: Text("Atualizar Produto"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
