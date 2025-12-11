// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:finalproject/Global.dart';
//
// class AdminDashboard extends StatefulWidget {
//   @override
//   _AdminDashboardState createState() => _AdminDashboardState();
// }
//
// class _AdminDashboardState extends State<AdminDashboard> {
//   String _selectedMenuItem = 'Users';
//   bool _isMenuOpen = false;
//   List<Map<String, dynamic>> _dataList = [];
//   var token_value = Global.getToken();
//
//
//   void _selectMenuItem(String menuItem) {
//     setState(() {
//       _selectedMenuItem = menuItem;
//       _fetchData(menuItem); // Fetch data when menu item is selected
//     });
//   }
//
//
//   @override
//   void initState() {
//     _fetchData(_selectedMenuItem);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Dashboard'),
//         leading: IconButton(
//           icon: Icon(Icons.menu),
//           onPressed: () {
//             setState(() {
//               _isMenuOpen = !_isMenuOpen;
//             });
//           },
//         ),
//       ),
//       drawer: _buildDrawer(),
//       body: Row(
//         children: [
//           // Side Menu
//           Visibility(
//             visible: _isMenuOpen,
//             child: Container(
//               width: 150,
//               color: Colors.blueGrey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 20),
//                   _buildMenuItem('Users'),
//                   _buildMenuItem('Hostels'),
//                   _buildMenuItem('Bookings'),
//                   _buildMenuItem('Review'),
//                   SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: () {
//                       // Handle Logout
//                       // For demonstration, let's navigate back to the login screen
//                       Navigator.pop(context);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text(
//                         'Logout',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Container for Selected Menu Item
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.all(20),
//               child: _buildSelectedMenuItem(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDrawer() {
//     return Drawer(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 20),
//           _buildMenuItem('Users'),
//           _buildMenuItem('Hostels'),
//           _buildMenuItem('Bookings'),
//           _buildMenuItem('Review'),
//           SizedBox(height: 20),
//           GestureDetector(
//             onTap: () {
//               // Handle Logout
//               // For demonstration, let's navigate back to the login screen
//               Navigator.pop(context);
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Logout',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuItem(String menuItem) {
//     return GestureDetector(
//       onTap: () {
//         _selectMenuItem(menuItem);
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Text(
//           menuItem,
//           style: TextStyle(
//             color: _selectedMenuItem == menuItem ? Colors.white : Colors.grey,
//             fontSize: 18,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSelectedMenuItem() {
//     if (_dataList.isEmpty) {
//       return Center(child: Text('No data available'));
//     }
//
//     return ListView.builder(
//       itemCount: _dataList.length,
//       itemBuilder: (BuildContext context, int index) {
//         final data = _dataList[index];
//         return Card(
//           margin: EdgeInsets.symmetric(vertical: 10),
//           child: ListTile(
//             title: Text(getTitle(data)),
//             subtitle: Text(getSubtitle(data),
//             ),
//             trailing:
//             _isMenuOpen?Container():Container(
//               width: 150,
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       _handleUpdate(data); // Handle update action
//                     },
//                     child: Text('Update'),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       _handleDelete(data); // Handle delete action
//                     },
//                     child: Text('Delete'),
//                   ),
//                 ],
//               ),
//             ),
//
//
//           ),
//         );
//       },
//     );
//   }
//
//   String getTitle(Map<String, dynamic> data){
//     if(_selectedMenuItem=="Users"){
//       return "email : ${data['email']}";
//     }
//     else if(_selectedMenuItem=="Hostels"){
//       return "Hostel Name : ${data['hostel_name']}";
//     }
//     else if(_selectedMenuItem=="Bookings"){
//       return data['email'];
//     }
//     else if(_selectedMenuItem=="Review"){
//       return "Hostel: ${data['hostel_name']}";
//     }
//     else{
//       return "";
//     }
//   }
//
//   String getSubtitle(Map<String, dynamic> data){
//     if(_selectedMenuItem=="Users"){
//       return "User Type: ${data['user_type']}\n" +
//           "First Name: ${data['first_name']}\n" +
//           "Last Name: ${data['last_name']}\n" +
//           "Phone Number: ${data['phone_number']}\n" +
//           "Password: ${data['password']}\n" +
//           "Address: ${data['address']}\n" +
//           "Citizenship Image: ${data['photo_upload']}";
//
//     }
//     else if(_selectedMenuItem=="Hostels"){
//       return "email: ${data['email']}\n" +
//           "Hostel Contact: ${data['hostel_contact']}\n" +
//           "hostel address: ${data['hostel_address']}\n" +
//           "hostel Pan Number: ${data['hostel_pan_num']}";
//     }
//     else if(_selectedMenuItem=="Bookings"){
//       return "Hostel:${data['hostel_name']}\n" +
//           "Room No:${data['room_number']}";
//     }
//     else if(_selectedMenuItem=="Review"){
//       return "Review:${data['reviews']}";
//     }
//     else{
//       return "";
//     }
//   }
//
//   Future<void> _fetchData(String menuItem) async {
//     String url = '';
//     if (menuItem == 'Users') {
//       url = 'host/HRRSFinal/fetchuserdetails.php'; // Replace with your actual URL
//     } else if (menuItem == 'Hostels') {
//       url = 'host/HRRSFinal/fetchhosteldetails.php'; // Replace with your actual URL
//     } else if (menuItem == 'Bookings') {
//       url = 'host/HRRSFinal/fetchbookingdetails.php'; // Replace with your actual URL
//     } else if (menuItem == 'Review') {
//       url = 'host/HRRSFinal/fetchreviewdetails.php'; // Replace with your actual URL
//     }
//
//     try {
//       final response = await http.get(Uri.parse(url),
//         headers: {
//         'authorization' : 'Bearer $token_value'
//         }
//       );
//       print(response.body);
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         setState(() {
//           _dataList = List<Map<String, dynamic>>.from(jsonData['data']);
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Error: $e');
//       // Handle error gracefully
//     }
//   }
//
//   void _handleUpdate(Map<String, dynamic> data) async {
//     // Implement update logic here
//     print('Update action for ${data.toString()}');
//   }
//
//   void _handleDelete(Map<String, dynamic> data) async {
//     // Implement delete logic here
//     print("THe data to be deleted is: ${data}");
//     var table_name = '';
//     if(_selectedMenuItem=="Users"){
//       table_name = "user_details";
//     }
//     else if(_selectedMenuItem=="Hostels"){
//       table_name = "hostel_details";
//     }
//     else if(_selectedMenuItem=="Bookings"){
//       table_name = "booking_details";
//     }
//     else if(_selectedMenuItem=="Review"){
//       table_name = 'Review_table';
//     }
//
//     var url = "host/HRRSFinal/adminDelete.php";
//     try {
//       final response = await http.get(Uri.parse("${url}?tablename=${table_name}&id=${data['id']}"),
//
//           headers: {
//             'authorization' : 'Bearer $token_value'
//           }
//       );
//       if (response.statusCode == 204) {
//         // final jsonData = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text("record with id ${data['id']} deleted successfully"),
//           duration: Duration(seconds: 2),
//         ));
//         print(_selectedMenuItem);
//         _fetchData(_selectedMenuItem);
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Error: $e');
//       // Handle error gracefully
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:finalproject/Global.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _selectedMenuItem = 'Users';
  bool _isMenuOpen = false;
  List<Map<String, dynamic>> _dataList = [];
  var token_value = Global.getToken();
  var host = Global.getHost();

  void _selectMenuItem(String menuItem) {
    setState(() {
      _selectedMenuItem = menuItem;
      _fetchData(menuItem); // Fetch data when menu item is selected
    });
  }


  @override
  void initState() {
    _fetchData(_selectedMenuItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            setState(() {
              _isMenuOpen = !_isMenuOpen;
            });
          },
        ),
      ),
      drawer: _buildDrawer(),
      body: Row(
        children: [
          // Side Menu
          Visibility(
            visible: _isMenuOpen,
            child: Container(
              width: 150,
              color: Colors.blueGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  _buildMenuItem('Users'),
                  _buildMenuItem('Hostels'),
                  _buildMenuItem('Bookings'),
                  _buildMenuItem('Review'),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Handle Logout
                      // For demonstration, let's navigate back to the login screen
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Container for Selected Menu Item
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: _buildSelectedMenuItem(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          _buildMenuItem('Users'),
          _buildMenuItem('Hostels'),
          _buildMenuItem('Bookings'),
          _buildMenuItem('Review'),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              // Handle Logout
              // For demonstration, let's navigate back to the login screen
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String menuItem) {
    return GestureDetector(
      onTap: () {
        _selectMenuItem(menuItem);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          menuItem,
          style: TextStyle(
            color: _selectedMenuItem == menuItem ? Colors.white : Colors.grey,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedMenuItem() {
    if (_dataList.isEmpty) {
      return Center(child: Text('No data available'));
    }

    return ListView.builder(
      itemCount: _dataList.length,
      itemBuilder: (BuildContext context, int index) {
        final data = _dataList[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            title: Text(getTitle(data)),
            subtitle: Text(getSubtitle(data),
            ),
            trailing:
            _isMenuOpen?Container():Container(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _selectedMenuItem=="Review"?Container():TextButton(
                    onPressed: () {
                      _handleUpdate(data); // Handle update action
                    },
                    child: Text('Update'),
                  ),
                  TextButton(
                    onPressed: () {
                      _handleDelete(data); // Handle delete action
                    },
                    child: Text('Delete'),
                  ),
                ],
              ),
            ),


          ),
        );
      },
    );
  }

  String getTitle(Map<String, dynamic> data){
    if(_selectedMenuItem=="Users"){
      return "email : ${data['email']}";
    }
    else if(_selectedMenuItem=="Hostels"){
      return "Hostel Name : ${data['hostel_name']}";
    }
    else if(_selectedMenuItem=="Bookings"){
      return data['email'];
    }
    else if(_selectedMenuItem=="Review"){
      return "Hostel: ${data['hostel_name']}";
    }
    else{
      return "";
    }
  }

  String getSubtitle(Map<String, dynamic> data){
    if(_selectedMenuItem=="Users"){
      return "User Id: ${data['id']}\n" +
          "User Type: ${data['user_type']}\n" +
          "First Name: ${data['first_name']}\n" +
          "Last Name: ${data['last_name']}\n" +
          "Phone Number: ${data['phone_number']}\n" +
          "Password: ${data['password']}\n" +
          "Address: ${data['address']}\n" +
          "Citizenship Image: ${data['photo_upload']}";

    }
    else if(_selectedMenuItem=="Hostels"){
      return "hostel_id: ${data['id']}\n" +
          "email: ${data['email']}\n" +
          "Hostel Contact: ${data['hostel_contact']}\n" +
          "hostel address: ${data['hostel_address']}\n" +
          "hostel Pan Number: ${data['hostel_pan_num']}";
    }
    else if(_selectedMenuItem=="Bookings"){
      return "Hostel:${data['hostel_name']}\n" +
          "Room No:${data['room_number']}";
    }
    else if(_selectedMenuItem=="Review"){
      return "Review:${data['reviews']}";
    }
    else{
      return "";
    }
  }

  Future<void> _fetchData(String menuItem) async {
    String url = '';
    if (menuItem == 'Users') {
      url = '$host/HRRSFinal/fetchuserdetails.php'; // Replace with your actual URL
    } else if (menuItem == 'Hostels') {
      url = '$host/HRRSFinal/fetchhosteldetails.php'; // Replace with your actual URL
    } else if (menuItem == 'Bookings') {
      url = '$host/HRRSFinal/fetchbookingdetails.php'; // Replace with your actual URL
    } else if (menuItem == 'Review') {
      url = '$host/HRRSFinal/fetchreviewdetails.php'; // Replace with your actual URL
    }

    try {
      final response = await http.get(Uri.parse(url),
          headers: {
            'authorization' : 'Bearer $token_value'
          }
      );
      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _dataList = List<Map<String, dynamic>>.from(jsonData['data']);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error gracefully
    }
  }

  void _handleUpdate(Map<String, dynamic> data) async {
    // Generate AlertDialog content based on selected menu item
    String title = '';
    List<Widget> fields = [];

    if (_selectedMenuItem == 'Users') {
      title = 'Update User';
      fields = [
        TextField(
          decoration: InputDecoration(labelText: 'First Name'),
          controller: TextEditingController(text: data['first_name']),
          onChanged: (value) {
            data['first_name'] = value;
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Last Name'),
          controller: TextEditingController(text: data['last_name']),
          onChanged: (value) {
            data['last_name'] = value;
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Email'),
          controller: TextEditingController(text: data['email']),
          onChanged: (value) {
            data['email'] = value;
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'User Type'),
          controller: TextEditingController(text: data['user_type']),
          onChanged: (value) {
            data['user_type'] = value;
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Phone Number'),
          controller: TextEditingController(text: data['phone_number']),
          onChanged: (value) {
            data['phone_number'] = value;
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Password'),
          controller: TextEditingController(text: data['password']),
          onChanged: (value) {
            data['password'] = value;
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Address'),
          controller: TextEditingController(text: data['address']),
          onChanged: (value) {
            data['address'] = value;
          },
        ),
      ];
    } else if (_selectedMenuItem == 'Hostels') {
      title = 'Update Hostel';
      fields = [
        TextField(
          decoration: InputDecoration(labelText: 'Hostel Name'),
          controller: TextEditingController(text: data['hostel_name']),
          onChanged: (value) {
            data['hostel_name'] = value;
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Hostel Address'),
          controller: TextEditingController(text: data['hostel_address']),
          onChanged: (value) {
            data['hostel_address'] = value;
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Hostel Contact'),
          controller: TextEditingController(text: data['hostel_contact']),
          onChanged: (value) {
            data['hostel_contact'] = value;
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Hostel Pan Number'),
          controller: TextEditingController(text: data['hostel_pan_num']),
          onChanged: (value) {
            data['hostel_pan_num'] = value;
          },
        ),
      ];
    } else if (_selectedMenuItem == 'Bookings') {
      title = 'Update Booking';
      fields = [
        TextField(
          decoration: InputDecoration(labelText: 'Hostel Name'),
          controller: TextEditingController(text: data['hostel_name']),
          onChanged: (value) {
            data['hostel_name'] = value;
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Email'),
          controller: TextEditingController(text: data['email']),
          onChanged: (value) {
            data['email'] = value;
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Room Number'),
          controller: TextEditingController(text: data['room_number']),
          onChanged: (value) {
            data['room_number'] = value;
          },
        ),

      ];
    }

    // Show AlertDialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: fields,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Update'),
              onPressed: () {
                Navigator.of(context).pop(); // Close AlertDialog
                _executeUpdate(data); // Execute update logic
                _fetchData(_selectedMenuItem);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close AlertDialog
              },
            ),
          ],
        );
      },
    );
  }

  void _executeUpdate(Map<String, dynamic> data) async {
    var url = '';
    String id = data['id'].toString();
    var body = {};
    // Determine URL based on selectedMenuItem
    if (_selectedMenuItem == 'Users') {
      String first_name = data['first_name'];
      String last_name = data['last_name'];
      String email = data['email'];
      String user_type = data['user_type'];
      String phone_number = data['phone_number'].toString();
      String password = data['password'];
      String address = data['address'];
      url = '$host/HRRSFinal/updateuser.php';

      body = {
        'id':id,
        "first_name": first_name,
        "last_name":last_name,
        "email": email,
        "user_type":user_type,
        "phone_number":phone_number,
        "password":password,
        "address": address
      };
    } else if (_selectedMenuItem == 'Hostels') {
      String hostel_id = data['id'].toString();
      String hostel_name = data['hostel_name'];
      String hostel_address = data['hostel_address'];
      String email = data['email'];
      String hostel_contact = data['hostel_contact'];
      String hostel_pan_num = data['hostel_pan_num'].toString();
      print(hostel_pan_num);
      url = '$host/HRRSFinal/updatehostels.php';
      body = {
        'id':hostel_id,
        'email' :email,
        'hostel_address' : hostel_address,
        'hostel_name': hostel_name,
        'hostel_contact': hostel_contact,
        'hostel_pan_num': hostel_pan_num
      };
    } else if (_selectedMenuItem == 'Bookings') {
      url = '$host/HRRSFinal/updatebooking.php';
      body = {
        'id': id,
        'hostel_name':data['hostel_name'],
        'email': data['email'],
        'room_number': data['room_number'],
      };
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'authorization': 'Bearer $token_value',
        },
        body: body,
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Handle success, if needed
        print('Update successful');
        _fetchData(_selectedMenuItem); // Refresh data after update
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonDecode(response.body)['msg']),
          duration: Duration(seconds: 2),
        ));
        throw Exception('Failed to update data');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error gracefully
    }
  }


  void _handleDelete(Map<String, dynamic> data) async {
    // Implement delete logic here
    print("THe data to be deleted is: ${data}");
    var table_name = '';
    if(_selectedMenuItem=="Users"){
      table_name = "user_details";
    }
    else if(_selectedMenuItem=="Hostels"){
      table_name = "hostel_details";
    }
    else if(_selectedMenuItem=="Bookings"){
      table_name = "booking_details";
    }
    else if(_selectedMenuItem=="Review"){
      table_name = 'Review_table';
    }

    var url = "$host/HRRSFinal/adminDelete.php";
    try {
      final response = await http.get(Uri.parse("${url}?tablename=${table_name}&id=${data['id']}"),

          headers: {
            'authorization' : 'Bearer $token_value'
          }
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 204) {
        // final jsonData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("record with id ${data['id']} deleted successfully"),
          duration: Duration(seconds: 2),
        ));
        print(_selectedMenuItem);
        _fetchData(_selectedMenuItem);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error gracefully
    }
  }
}