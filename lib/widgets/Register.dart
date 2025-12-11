import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../routes/routes.dart';
import 'dart:convert';
import 'package:finalproject/Global.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  List userList = ["student", "owner"];

  String _selectedUserType = '';
  bool _showOwnerFields = false;
  var host = Global.getHost();

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController hname = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController hpan = TextEditingController();

  late File? imageFile;

  String userValue = '';

  _SignupScreenState() {
    imageFile = null;
    userValue = userList[0];
  }

  Future<void> signup() async {
    if (!validateForm()) {
      return;
    }

    var url = Uri.parse("$host/HRRSFinal/signup.php");
    var request = http.MultipartRequest('POST', url);
    request.fields['first_name'] = fname.text;
    request.fields['last_name'] = lname.text;
    request.fields['user_type'] = userValue;
    request.fields['phone_number'] = phone.text;
    request.fields['email'] = email.text;
    request.fields['password'] = password.text;
    if (userValue == "student") {
      request.fields['hostel_name'] = "";
      request.fields['address'] = "";
    } else {
      request.fields['hostel_name'] = hname.text;
      request.fields['address'] = address.text;
    }

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('photo_upload', imageFile!.path));
    }

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    print(response.body);
    print(response.statusCode);
    print(email.text);
    var data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      print('success');
      clearRegistrationForm();
      Navigator.pushNamed(context, MyRoutes.loginRoute);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['msg']),
        ),
      );
    }
  }

  void clearRegistrationForm(){
   fname.text = '';
    lname.text = '';
    phone.text = '';
    email.text = '';
     password.text = '';
    hname.text = '';
    address.text = '';
    hpan.text = '';
    imageFile = null;
  }

  bool validateForm() {
    if (fname.text.isEmpty ||
        lname.text.isEmpty ||
        phone.text.isEmpty ||
        email.text.isEmpty ||
        password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields.'),
        ),
      );
      return false;
    }

    if (!email.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address.'),
        ),
      );
      return false;
    }

    if (password.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must be at least 8 characters long.'),
        ),
      );
      return false;
    }

    // Additional validation for owner-specific fields if needed

    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Form'),
      ),
      body: SingleChildScrollView( // Wrap with SingleChildScrollView for scrollability
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text('User Type'),
                  SizedBox(width: 20),
                  DropdownButton(
                    value: userValue,
                    onChanged: (req) {
                      setState(() {
                        if (req.toString() == "owner") {
                          _showOwnerFields = true;
                        } else {
                          _showOwnerFields = false;
                        }
                        userValue = req.toString();
                      });
                    },
                    items: userList.map((e) {
                      return DropdownMenuItem<String>(child: Text(e), value: e);
                    }).toList(),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: fname,
                      decoration: InputDecoration(labelText: 'First Name'),
                    ),
                  ),
                  SizedBox(width: 40),
                  Expanded(
                    child: TextFormField(
                      controller: lname,
                      decoration: InputDecoration(labelText: 'Last Name'),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(height: 20),
                  TextFormField(
                    controller: phone,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(labelText: 'Email Account'),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: _showOwnerFields,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: hname,
                          decoration: InputDecoration(labelText: 'Hostel Name'),
                        ),
                        TextFormField(
                          controller: address,
                          decoration: InputDecoration(labelText: 'Address'),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            if (imageFile != null)
                              Image.file(
                                imageFile!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                _getImage(context);
                              },
                              child: Text('Select Citizenship Image'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      signup();
                    },
                    child: Text('Submit'),
                  ),
                  SizedBox(height: 20), // Adjust spacing as needed
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Registration Form'),
  //     ),
  //     body: Padding(
  //       padding: EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           Row(
  //             children: [
  //               Text('User Type'),
  //               SizedBox(width: 20),
  //               DropdownButton(
  //                 value: userValue,
  //                 onChanged: (req) {
  //                   setState(() {
  //                     if (req.toString() == "owner") {
  //                       _showOwnerFields = true;
  //                     } else {
  //                       _showOwnerFields = false;
  //                     }
  //                     userValue = req.toString();
  //                   });
  //                 },
  //                 items: userList.map((e) {
  //                   return DropdownMenuItem<String>(child: Text(e), value: e);
  //                 }).toList(),
  //               ),
  //             ],
  //           ),
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: TextFormField(
  //                   controller: fname,
  //                   decoration: InputDecoration(labelText: 'First Name'),
  //                 ),
  //               ),
  //               SizedBox(width: 40),
  //               Expanded(
  //                 child: TextFormField(
  //                   controller: lname,
  //                   decoration: InputDecoration(labelText: 'Last Name'),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Column(
  //             children: [
  //               SizedBox(height: 20),
  //               TextFormField(
  //                 controller: phone,
  //                 decoration: InputDecoration(labelText: 'Phone Number'),
  //               ),
  //               SizedBox(height: 20),
  //               TextFormField(
  //                 controller: email,
  //                 decoration: InputDecoration(labelText: 'Email Account'),
  //               ),
  //               SizedBox(height: 20),
  //               TextFormField(
  //                 controller: password,
  //                 obscureText: true,
  //                 decoration: InputDecoration(labelText: 'Password'),
  //               ),
  //               SizedBox(height: 20),
  //               Visibility(
  //                 visible: _showOwnerFields,
  //                 child: Column(
  //                   children: [
  //                     TextFormField(
  //                       controller: hname,
  //                       decoration: InputDecoration(labelText: 'Hostel Name'),
  //                     ),
  //                     TextFormField(
  //                       controller: address,
  //                       decoration: InputDecoration(labelText: 'Address'),
  //                     ),
  //                     TextFormField(
  //                       controller: hpan,
  //                       decoration: InputDecoration(labelText: 'Hostel Pan Number'),
  //                     ),
  //                     Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: <Widget>[
  //                         if (imageFile != null)
  //                         Image.file(
  //                             imageFile!,
  //                             width: 50,
  //                           height: 50,
  //                           fit: BoxFit.cover,
  //                                ),
  //                       SizedBox(height: 20),
  //                       ElevatedButton(
  //                       onPressed: () {
  //                         _getImage(context);
  //                       },
  //                       child: Text('Select Citizenship Image'),
  //                     ),
  //                     ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   signup();
  //                 },
  //                 child: Text('Submit'),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<void> _getImage(BuildContext context) async {
    final picker = ImagePicker();
    final PickedFile? pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    } else {
      // Handle if no image was selected
    }
  }
}



