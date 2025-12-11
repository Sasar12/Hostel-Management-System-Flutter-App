import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../routes/routes.dart';
import 'package:finalproject/Global.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostel Information Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HostelForm(),
    );
  }
}

class HostelForm extends StatefulWidget {
  @override
  _HostelFormState createState() => _HostelFormState();
}

class _HostelFormState extends State<HostelForm> {
  final _hostelFormKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _panController = TextEditingController();
  var host = Global.getHost();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hostel Information Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _hostelFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Hostel Name'),
                validator: (value) {
                  if ( value == null || value.isEmpty) {
                    return "Enter Hostel Name!";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Hostel Address'),
                validator: (value) {
                  if ( value == null || value.isEmpty) {
                    return "Enter Hostel Address!";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Hostel Phone Number'),
                validator: (value) {
                  if ( value== null || value.length !=10) {
                    return "Enter valid Phone Number!";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _panController,
                decoration: InputDecoration(labelText: 'Hostel PAN Number'),
                validator: (value) {
                  if ( value== null || value.length != 9 ) {
                    return "Enter valid Pan Number!";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                    // Process the form data
                  if (_hostelFormKey.currentState!.validate()) {
                    _submitForm();
                  }

                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Future<void> _submitForm() async{
   var url = Uri.parse("$host/HRRSFinal/hostel_input.php");
    var request = http.MultipartRequest('POST', url);
    request.fields['hostel_name'] = _nameController.text;
    request.fields['hostel_address'] = _addressController.text;
    request.fields['hostel_contact'] = _phoneController.text;
    request.fields['hostel_pan_num'] = _panController.text;

    var body = {
    'hostel_name' : _nameController.text,
    'hostel_address' : _addressController.text,
    'hostel_contact' : _phoneController.text,
    'hostel_pan_num' : _panController.text,
    };


    var token_value = Global.getToken();
    var response = await http.post( url, headers: {
      'authorization': "Bearer $token_value"
    }, body: body);
    // print(token_value);
    print(response.body);
    // Check response status if needed
    print(response.statusCode);
    if (response.statusCode == 200) {
    print('success');
    // Navigate to the next page upon successful signup
    Navigator.pushNamed(context, MyRoutes.RoomInputRoute).then((value) =>
        setState(() {
      _nameController.text = '';
      _addressController.text = '';
      _phoneController.text = '';
      _panController.text = '';

    }));
    } else {
    // Handle error if necessary
    // For example, show a snackbar with an error message
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('Sign up failed! Please try again.'),
    ),
    );
    }
  }
  }
