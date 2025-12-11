// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'routes/routes.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';
// import 'helper.dart';
// import 'Global.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   String _selectedUserType = '';
//
//   TextEditingController email = TextEditingController();
//   TextEditingController usertype = TextEditingController();
//   TextEditingController password = TextEditingController();
//   Helper helper = new Helper();
//
//   Future<void> login() async {
//     var url = Uri.parse("host/HRRSFinal/login.php");
//     var request = http.MultipartRequest('POST', url);
//     request.fields['email'] = email.text;
//     request.fields['user_type'] = _selectedUserType;
//     request.fields['password'] = password.text;
//
//     var StreamedResponse = await request.send();
//     var response = await http.Response.fromStream(StreamedResponse);
//     print(response.statusCode);
//     print(response.body);
//     if (response.statusCode == 200) {
//       var result = response.body;
//       print(result);
//       var obj = jsonDecode(result) as Map<String, dynamic>;
//       print("THe obj is: ${obj}");
//       Global.setToken(obj['token']);
//       if (obj['user_type'] == "student") {
//         print(obj['user_type']);
//         Navigator.pushNamed(context, MyRoutes.searchRoute).then((value) =>
//             setState(() {
//               email.text = '';
//               usertype.text = '';
//               password.text = '';
//
//             }));
//       } else if (obj['user_type'] == "owner") {
//         // var user_id = obj['user_id'];
//         var user_id = helper.getUserIdByToken(Global.getToken());
//
//         var url = Uri.parse("host/HRRSFinal/connector.php");
//         var token_value = Global.getToken();
//         var response = await http.get(url, headers: {
//           'authorization': "Bearer $token_value"
//         });
//         if (response.statusCode == 200) {
//           Navigator.pushNamed(context, MyRoutes.RoomInputRoute);
//         } else {
//           Navigator.pushNamed(context, MyRoutes.HostelInputRoute);
//         }
//       } else if (obj['user_type'] == "admin") {
//         Navigator.pushNamed(context, MyRoutes.AdminPageRoute);
//       }
//     } else {
//       // Handle login failure
//       print("Error");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Login failed. Please check your credentials.'),
//         duration: Duration(seconds: 2),
//       ));
//     }
//   }
//
//   String name = "";
//   bool changeButton = false;
//   final _formKey = GlobalKey<FormState>();
//
//   moveToHome(BuildContext context) async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         changeButton = true;
//       });
//       setState(() {
//         changeButton = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold( // Wrap with Scaffold
//       appBar: AppBar(
//         title: Text('Login Page'),
//       ),
//       body: Material(
//         color: Colors.white,
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Image.asset("assets/images/login.jpeg", fit: BoxFit.cover),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   "Welcome $name",
//                   style: TextStyle(
//                     color: Colors.blue,
//                     fontSize: 30,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20.0,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 16.0, horizontal: 20.0),
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         controller: email,
//                         decoration: InputDecoration(
//                           hintText: "enter email",
//                           labelText: "Email",
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return ("email cannot be empty");
//                           }
//                           return null;
//                         },
//                         onChanged: (value) {
//                           name = value;
//                           setState(() {});
//                         },
//                       ),
//                       DropdownButtonFormField<String>(
//                         value: _selectedUserType.isNotEmpty
//                             ? _selectedUserType
//                             : null,
//                         items: [
//                           DropdownMenuItem(
//                             value: 'student',
//                             child: Text('Student'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'owner',
//                             child: Text('Owner'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'admin',
//                             child: Text('Admin'),
//                           ),
//                         ],
//                         onChanged: (String? value) {
//                           setState(() {
//                             _selectedUserType = value ?? '';
//                             // Set visibility of student fields based on user selection
//                           });
//                         },
//                         decoration: InputDecoration(
//                           labelText: 'User Type',
//                         ),
//                       ),
//                       TextFormField(
//                         controller: password,
//                         decoration: InputDecoration(
//                           hintText: "enter Password",
//                           labelText: "Password",
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return ("password cannot be empty");
//                           }
//                           if (value.length < 8) {
//                             return ("password length should be atleast six");
//                           }
//                           return null;
//                         },
//                         obscureText: true,
//                       ),
//                       SizedBox(
//                         height: 40,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Checkbox(value: true, onChanged: (value) {}),
//                               const Text('rememberme'),
//                             ],
//                           ),
//                           TextButton(
//                               onPressed: () {}, child: const Text(
//                               'forgetPassword')),
//                         ],
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             login();
//                           }
//                         },
//                         // child: AnimatedContainer(
//                         //   duration: Duration(seconds: 1),
//                         //   width: changeButton ? 50 : 150,
//                         //   height: 50,
//                         //   alignment: Alignment.center,
//                         //   child: changeButton
//                         //       ? Icon(
//                         //     Icons.done,
//                         //     color: Colors.white,
//                         //   )
//                         child: Text(
//                           "login",
//                           style: TextStyle(
//                               color: Colors.blue,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20),
//                         ),
//                         // decoration: BoxDecoration(
//                         //   color: Colors.blue,
//                         //   shape: changeButton
//                         //       ? BoxShape.circle
//                         //       : BoxShape.rectangle,
//                         //   // borderRadius:
//                         //   //   BorderRadius.circular(changeButton? 20 : 8)
//                         // ),
//                       ),
//                     ],
//                   ),),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'routes/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'helper.dart';
import 'Global.dart';
import 'widgets/Register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _selectedUserType = '';

  TextEditingController email = TextEditingController();
  TextEditingController usertype = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController forgotEmailController = TextEditingController();
  Helper helper = new Helper();
  var host = Global.getHost();

  Future<void> login() async {

    var url = Uri.parse("$host/HRRSFinal/login.php");
    var request = http.MultipartRequest('POST', url);
    request.fields['email'] = email.text;
    request.fields['user_type'] = _selectedUserType;
    request.fields['password'] = password.text;

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var result = response.body;
      print(result);
      var obj = jsonDecode(result) as Map<String, dynamic>;
      print("The obj is: $obj");
      Global.setToken(obj['token']);
      if (obj['user_type'] == "student") {
        print(obj['user_type']);

        Navigator.pushNamed(context, MyRoutes.searchRoute).then((value) =>
            setState(() {
              email.text = '';
              usertype.text = '';
              password.text = '';
            }));
      } else if (obj['user_type'] == "owner") {
        var user_id = helper.getUserIdByToken(Global.getToken());

        var url = Uri.parse("$host/HRRSFinal/connector.php");
        var token_value = Global.getToken();
        var response = await http.get(url, headers: {
          'authorization': "Bearer $token_value"
        });
        if (response.statusCode == 200) {
          Navigator.pushNamed(context, MyRoutes.RoomInputRoute).then((value) =>
              setState(() {
                email.text = '';
                usertype.text = '';
                password.text = '';
              }));;
        } else {
          Navigator.pushNamed(context, MyRoutes.HostelInputRoute).then((value) =>
              setState(() {
                email.text = '';
                usertype.text = '';
                password.text = '';
              }));;
        }
      } else if (obj['user_type'] == "admin") {
        Navigator.pushNamed(context, MyRoutes.AdminPageRoute).then((value) =>
            setState(() {
              email.text = '';
              usertype.text = '';
              password.text = '';
            }));;
      }
    } else {
      // Handle login failure
      print("Error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login failed. Please check your credentials.'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  String name = "";
  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();

  void showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password'),
          content: TextField(
            controller: forgotEmailController,
            decoration: InputDecoration(
              hintText: 'Enter your email',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Enter'),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                showNewPasswordDialog(forgotEmailController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void showNewPasswordDialog(String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Password'),
          content: TextField(
            controller: newPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Enter your new password',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Enter'),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                // Invoke PHP page with email and new password
                invokePHPPage();
              },
            ),
          ],
        );
      },
    );
  }

    void invokePHPPage() async {
      var url = Uri.parse("$host/HRRSFinal/changepassword.php");
      var request = http.MultipartRequest('POST', url);
      request.fields['email'] = forgotEmailController.text;
      request.fields['password'] = newPasswordController.text;

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password Changed Successfully'),
          duration: Duration(seconds: 2),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to change password'),
          duration: Duration(seconds: 2),
        ));
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Login Page'),
        ),
        body: Material(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset("assets/images/login.jpeg", fit: BoxFit.cover),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Welcome $name",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 20.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            hintText: "Enter email",
                            labelText: "Email",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Email cannot be empty");
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if(value.contains("@")){
                            }
                            else{
                              name = value;
                              setState(() {});

                            }
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: _selectedUserType.isNotEmpty
                              ? _selectedUserType
                              : null,
                          items: [
                            DropdownMenuItem(
                              value: 'student',
                              child: Text('Student'),
                            ),
                            DropdownMenuItem(
                              value: 'owner',
                              child: Text('Owner'),
                            ),
                            DropdownMenuItem(
                              value: 'admin',
                              child: Text('Admin'),
                            ),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              _selectedUserType = value ?? '';
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'User Type',
                          ),
                        ),
                        TextFormField(
                          controller: password,
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            labelText: "Password",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Password cannot be empty");
                            }
                            if (value.length < 8) {
                              return ("Password length should be at least eight");
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(value: true, onChanged: (value) {}),
                                const Text('Remember me'),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                showForgotPasswordDialog();
                              },
                              child: const Text('Forgot Password'),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              login();
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        // SizedBox(height: 20,),
                        // ElevatedButton(
                        //   onPressed: () {
                        //       Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                        //   },
                        //   child: Text(
                        //     "Register",
                        //     style: TextStyle(
                        //       color: Colors.purple,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 20,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
