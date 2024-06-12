import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'House Price Prediction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PredictionForm(),
    );
  }
}

class PredictionForm extends StatefulWidget {
  @override
  _PredictionFormState createState() => _PredictionFormState();
}

class _PredictionFormState extends State<PredictionForm> {
  final TextEditingController _bedroomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _sqftLivingController = TextEditingController();
  final TextEditingController _sqftLotController = TextEditingController();
  final TextEditingController _floorsController = TextEditingController();
  final TextEditingController _waterfrontController = TextEditingController();
  final TextEditingController _viewController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _sqftAboveController = TextEditingController();
  final TextEditingController _sqftBasementController = TextEditingController();
  final TextEditingController _yrBuiltController = TextEditingController();
  final TextEditingController _yrRenovatedController = TextEditingController();

  String _prediction = '';

  Future<void> _predict() async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/predict'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'bedrooms': _bedroomsController.text,
        'bathrooms': _bathroomsController.text,
        'sqft_living': _sqftLivingController.text,
        'sqft_lot': _sqftLotController.text,
        'floors': _floorsController.text,
        'waterfront': _waterfrontController.text,
        'view': _viewController.text,
        'condition': _conditionController.text,
        'sqft_above': _sqftAboveController.text,
        'sqft_basement': _sqftBasementController.text,
        'yr_built': _yrBuiltController.text,
        'yr_renovated': _yrRenovatedController.text,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _prediction = "Predicted Price: ${data['prediction']}";
      });
    } else {
      final data = json.decode(response.body);
      setState(() {
        _prediction = "Error: ${data['error']}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('House Price Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _bedroomsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Bedrooms'),
              ),
              TextField(
                controller: _bathroomsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Bathrooms'),
              ),
              TextField(
                controller: _sqftLivingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Sqft Living'),
              ),
              TextField(
                controller: _sqftLotController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Sqft Lot'),
              ),
              TextField(
                controller: _floorsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Floors'),
              ),
              TextField(
                controller: _waterfrontController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Waterfront (0/1)'),
              ),
              TextField(
                controller: _viewController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'View'),
              ),
              TextField(
                controller: _conditionController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Condition'),
              ),
              TextField(
                controller: _sqftAboveController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Sqft Above'),
              ),
              TextField(
                controller: _sqftBasementController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Sqft Basement'),
              ),
              TextField(
                controller: _yrBuiltController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Year Built'),
              ),
              TextField(
                controller: _yrRenovatedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Year Renovated'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _predict,
                child: Text('Predict'),
              ),
              SizedBox(height: 20),
              Text(
                _prediction,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
