import 'dart:io';
import 'package:http/http.dart' as http;
// Add import for image_picker
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:finalproject/Global.dart';
import 'package:finalproject/helper.dart';
import 'Review.dart';
import 'package:finalproject/routes/routes.dart';
import 'package:finalproject/helper.dart';

class Room {
  final int hostelId;
  final String image;
  final int roomNumber;
  final double price;
  final int numberOfBeds;
  final String email;
  final String hostelName;
  final int bookingId;

  Room({ required this.bookingId, required this.hostelId,required this.image, required this.roomNumber, required this.price, required this.numberOfBeds, required this.email, required this.hostelName});

}

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rooms',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RoomInputPage(),
    );
  }
}

class RoomInputPage extends StatefulWidget {



  @override
  _RoomInputPageState createState() => _RoomInputPageState();
}
class _RoomInputPageState extends State<RoomInputPage> {
  // List<Room> rooms = [
  //   Room(image: "image1.jpeg", roomNumber:  200, price:  4000, numberOfBeds: 20),
  //   Room(image: "image2.jpeg",roomNumber:   100, price: 2000, numberOfBeds:  10),
  //   Room(image: "image3.jpeg", roomNumber:  300, price: 3000,  numberOfBeds: 10),
  // ];

  bool isBookedRooms = false;
  List<Room> rooms = [];
  List<Room> bookedRooms = [];
  late File? imageFile = null;
  Helper helper = new Helper();
  int? hostelId = null;
  var host = Global.getHost();
  TextEditingController roomNumberController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController numberOfBedsController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  _RoomInputPageState() {
    fetchRooms();
    fetchBookedRooms();
    getHostelId();
  }


  // @override
  // void initState() {
  //   if(Global.getToken()==""){
  //
  //   }
  // }

  void getHostelId() async{
    final url = Uri.parse('$host/HRRSFinal/getHostelId.php');
    var token_value = Global.getToken();
    final response = await http.get(url, headers: {
      'authorization': 'Bearer $token_value'
    });
    print(response.body);
    if(response.statusCode==200){
      hostelId =  int.parse(jsonDecode(response.body)['hostel_id']);
    }
    else{
      hostelId ;
    }
  }

  fetchBookedRooms() async {
    final url = Uri.parse('$host/HRRSFinal/fetchBookedRooms.php');
    var token_value = Global.getToken();
    print("The token is: ${token_value}");
    final response = await http.get(url, headers: {
      'authorization': 'Bearer $token_value'
    });
    print("The fetchedBooked is: ${response.body}");
    if(response.body.isEmpty){
        bookedRooms = [];
    }else{
      var tempList = jsonDecode(response.body) as List;

      setState(() {
        bookedRooms = tempList.map((e){
          return Room( bookingId: int.parse(e['bookingId'].toString()), email: e['email'], hostelName: e['hostelName'],hostelId: int.parse(e['hostelId']), image: e['image']==null?"":e['image'], roomNumber: e["roomNumber"]==null?0:int.parse(e["roomNumber"]), price: e["price"]==null?0:double.parse(e['price']), numberOfBeds: e['numberOfBeds']==null?0:int.parse(e['numberOfBeds']));
        }).toList();
      });
    }
  }

  fetchRooms() async{
    final url = Uri.parse('$host/HRRSFinal/fetchrooms.php');
    var token_value = Global.getToken();
    final response = await http.get(url, headers: {
      'authorization': 'Bearer $token_value'
    });
    print(response.body);
    if(response.body.isEmpty){
      rooms = [];
    }else{
      var tempList = jsonDecode(response.body) as List;

      setState(() {
        rooms = tempList.map((e){
          return Room( bookingId:0, hostelName:'',email: '',hostelId: int.parse(e['hostelId']), image: e['image']==null?"":e['image'], roomNumber: e["roomNumber"]==null?0:int.parse(e["roomNumber"]), price: e["price"]==null?0:double.parse(e['price']), numberOfBeds: e['numberOfBeds']==null?0:int.parse(e['numberOfBeds']));
        }).toList();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    // if(isBookedRooms == true){
    //   return Scaffold()
    // }
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Text('Rooms'),
          Spacer(),
          Row(children: [
            Text('Booked'),
            Checkbox(value: isBookedRooms, onChanged: (value){
              setState(() {
                isBookedRooms = value!;
              });
            }),
          ],),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Review"),
                onTap: (){
                  if(hostelId!=null){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ReviewPage(hostelId: hostelId!, canReview: false)));
                  }
                },
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Logout"),
                onTap: (){
                  helper.logout(context);
                },
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                // Perform action for Review
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewPage()));
              } else if (value == 2) {
                // Perform action for Logout
                // Example: _logout();
              }
            },
          ),
        ],),
      ),
      body: ListView.builder(
        itemCount: isBookedRooms?bookedRooms.length:rooms.length,
        itemBuilder: (BuildContext context, int index) {
          var room = isBookedRooms?bookedRooms[index]:rooms[index];
          return Card(

            margin: EdgeInsets.all(10),
            child: isBookedRooms?getBookedRoom(room):getNormalRoom(room),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInputDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getNormalRoom(Room room){
    return ListTile(
      leading: SizedBox(
        height: 80,
        width: 80,
        child: Image(
          image: NetworkImage(room.image==""?"https://images.unsplash.com/photo-1719216324207-3b9727413913?q=80&w=2828&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D":"$host/HRRSFInal/uploads/${room.image}"),
          height: 80,
          width: 80,
        ),
      ),
      title: Text('Room Number:  ${room.roomNumber}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price: \Rs. ${room.price.toStringAsFixed(2)}'),
          Text('Beds: ${room.numberOfBeds}'),
          Text('Available Beds: ${room.numberOfBeds}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showEditDialog(room);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _confirmDelete(room);
            },
          ),
        ],
      ),
    );
  }

  Widget getBookedRoom(Room room){
    return ListTile(
      leading: SizedBox(
        height: 80,
        width: 80,
        child: Image(
          image: NetworkImage(room.image==""?"https://images.unsplash.com/photo-1719216324207-3b9727413913?q=80&w=2828&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D":"$host/HRRSFInal/uploads/${room.image}"),
          height: 80,
          width: 80,
        ),
      ),
      title: Text('Email: ${room.email}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Room No: ${room.roomNumber}'),
          Text('Price: \Rs.${room.price.toStringAsFixed(2)}'),

        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showBookedEditDialog(room);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _confirmDelete(room);
            },
          ),
        ],
      ),
    );
  }

  void _showBookedEditDialog(Room room) {
    roomNumberController.text = room.roomNumber.toString();
    emailController.text = room.email.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Room'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: roomNumberController,
                  decoration: InputDecoration(labelText: 'Room Number'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateRoomInDatabase(room);
                Navigator.of(context).pop();
                _clearControllers();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
  void _showEditDialog(Room room) {
    roomNumberController.text = room.roomNumber.toString();
    priceController.text = room.price.toString();
    numberOfBedsController.text = room.numberOfBeds.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Room'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  child: Text('Pick Image'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: roomNumberController,
                  decoration: InputDecoration(labelText: 'Room Number'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                TextField(
                  controller: numberOfBedsController,
                  decoration: InputDecoration(labelText: 'Number of Beds'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateRoomInDatabase(room);
                Navigator.of(context).pop();
                _clearControllers();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
  void _confirmDelete(Room room) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete room ${room.roomNumber}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteRoomFromDatabase(room);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
  void _updateRoomInDatabase(Room room) async {
    var token_value = Global.getToken();
    print("The token is: ${token_value}");
    if(!isBookedRooms){
      var url = Uri.parse('$host/HRRSFinal/edit_rooms.php');
      var request =  http.MultipartRequest('POST', url);
      request.fields['room_number'] = roomNumberController.text;
      request.fields['price'] = priceController.text;
      request.fields['no_of_beds'] = numberOfBedsController.text;
      request.headers['authorization'] = 'Bearer $token_value';

      if (imageFile != null) {
        print(imageFile?.path);
        request.files.add(await http.MultipartFile.fromPath('room_image', imageFile!.path));
      }
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Room updated successfully');
        fetchRooms();
      } else {
        print('Failed to update room. Error: ${response.reasonPhrase}');
      }
    }else{
      var url = Uri.parse('$host/HRRSFinal/edit_booked_rooms.php');
      var request =  http.MultipartRequest('POST', url);
      request.fields['room_number'] = roomNumberController.text;
      request.fields['email'] = emailController.text;
      request.fields['booking_id'] = room.bookingId.toString();
      request.headers['authorization'] = 'Bearer $token_value';

      var response = await request.send();
      var res = await http.Response.fromStream(response);
      print(res.body);
      print(res.statusCode);
      if (response.statusCode == 200) {
        print('Booked Room updated successfully');
        fetchRooms();
        fetchBookedRooms();
      } else {
        print('Failed to update booked room. Error: ${response.reasonPhrase}');
      }
    }

  }

  void _deleteRoomFromDatabase(Room room) async {

    var token_value = Global.getToken();
    if(!isBookedRooms){
      final url = Uri.parse('$host/HRRSFinal/delete_room.php');
      final response = await http.post(url, body: {
        'room_number': room.roomNumber.toString(),
      },
        headers: {
          'authorization': 'Bearer $token_value'
        },
      );

      if (response.statusCode == 200) {
        print('Room deleted successfully');
        fetchRooms();
        fetchBookedRooms();
      } else {
        print('Failed to delete room. Error: ${response.reasonPhrase}');
      }

    }
    else{
      final url = Uri.parse('$host/HRRSFinal/delete_booked_room.php');
      final response = await http.post(url, body: {
        'booking_id': room.bookingId.toString(),
      },
        headers: {
          'authorization': 'Bearer $token_value'
        },
      );

      if (response.statusCode == 200) {
        print('Room deleted successfully');
        fetchRooms();
        fetchBookedRooms();
      } else {
        print('Failed to delete room. Error: ${response.reasonPhrase}');
      }
    }

  }



// class _RoomInputPageState extends State<RoomInputPage> {
//   List<Room> rooms = [];
//
//   TextEditingController imageController = TextEditingController();
//   TextEditingController roomNumberController = TextEditingController();
//   TextEditingController priceController = TextEditingController();
//   TextEditingController numberOfBedsController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Hostel Rooms'),
//       ),
//       body: ListView.builder(
//         itemCount: rooms.length,
//         itemBuilder: (BuildContext context, int index) {
//           Room room = rooms[index];
//           return ListTile(
//             leading: Image.network(room.image),
//             title: Text('Room Number: ${room.roomNumber}'),
//             subtitle: Text(
//                 'Price: \$${room.price.toStringAsFixed(2)}\nNumber of Beds: ${room.numberOfBeds}'
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showInputDialog(context);
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }

  void _showInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Room'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (imageFile != null)
                Image.file(
                  imageFile!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: ()  {
                    // Use pickedFile.path as image path
                  _getImage(context);
                  },
                  child: Text('Pick Image'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: roomNumberController,
                  decoration: InputDecoration(labelText: 'Room Number'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                TextField(
                  controller: numberOfBedsController,
                  decoration: InputDecoration(labelText: 'Number of Beds'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearControllers();

              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addRoomToDatabase();
                Navigator.of(context).pop();
                _clearControllers();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addRoomToDatabase() async {
    var url = Uri.parse('$host/HRRSFinal/room_input.php');
    var token_value = Global.getToken();
    var request =  http.MultipartRequest('POST', url);
       request.fields['room_number'] = roomNumberController.text;
       request.fields['price'] = priceController.text;
      request.fields['no_of_beds'] = numberOfBedsController.text;
      request.headers['authorization'] = 'Bearer $token_value';
      if (imageFile != null) {
      print(imageFile?.path);
      request.files.add(await http.MultipartFile.fromPath('room_image', imageFile!.path));
      }
    var response = await request.send();
    if (response.statusCode == 200) {
      // Assuming your PHP script echoes a message upon success
      print('Room added successfully');
      fetchRooms();
    } else {
      print('Failed to add room. Error: ${response.reasonPhrase}');
    }
  }
  Future<void> _getImage(BuildContext context) async {
    final picker = ImagePicker();
    final PickedFile? pickedImage = await picker.getImage(
        source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    } else {
      // Handle if no image was selected
    }
  }
  void _clearControllers() {
    imageFile = null;
    roomNumberController.text = '';
    priceController.text = '';
    numberOfBedsController.text = '';
    roomNumberController.clear();
    priceController.clear();
    roomNumberController.clear();
  }
}

// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:finalproject/Global.dart';
//
// class Room {
//   final int hostelId;
//   final String image;
//   final int roomNumber;
//   final double price;
//   final int numberOfBeds;
//
//   Room({
//     required this.hostelId,
//     required this.image,
//     required this.roomNumber,
//     required this.price,
//     required this.numberOfBeds,
//   });
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Hostel Rooms',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: RoomInputPage(),
//     );
//   }
// }
//
// class RoomInputPage extends StatefulWidget {
//   @override
//   _RoomInputPageState createState() => _RoomInputPageState();
// }
//
// class _RoomInputPageState extends State<RoomInputPage> {
//   bool isBookedRooms = false;
//   List<Room> rooms = [];
//   List<Room> bookedRooms = [];
//   late File? imageFile;
//
//   TextEditingController roomNumberController = TextEditingController();
//   TextEditingController priceController = TextEditingController();
//   TextEditingController numberOfBedsController = TextEditingController();
//
//   _RoomInputPageState() {
//     fetchRooms();
//   }
//
//   fetchRooms() async {
//     final url = Uri.parse('host/HRRSFinal/fetchrooms.php');
//     var token_value = Global.getToken();
//     final response = await http.get(url, headers: {
//       'authorization': 'Bearer $token_value',
//     });
//     print(response.body);
//     if (response.body.isEmpty) {
//     } else {
//       var tempList = jsonDecode(response.body) as List;
//
//       setState(() {
//         rooms = tempList.map((e) {
//           return Room(
//             hostelId: int.parse(e['hostelId']),
//             image: e['image'] == null ? "" : e['image'],
//             roomNumber: e["roomNumber"] == null ? 0 : int.parse(e["roomNumber"]),
//             price: e["price"] == null ? 0 : double.parse(e['price']),
//             numberOfBeds: e['numberOfBeds'] == null ? 0 : int.parse(e['numberOfBeds']),
//           );
//         }).toList();
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Text('Hostel Rooms'),
//
//             PopupMenuButton(
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                   value: 1,
//                   child: Text("Review"),
//                 ),
//                 PopupMenuItem(
//                   value: 2,
//                   child: Text("Logout"),
//                 ),
//               ],
//               onSelected: (value) {
//                 if (value == 1) {
//                   // Perform action for Review
//                   // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewPage()));
//                 } else if (value == 2) {
//                   // Perform action for Logout
//                   // Example: _logout();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//       body:
//           Container(
//             height: 600,
//             child: ListView(
//
//               children: [
//                 CheckboxListTile(
//
//                   title: Text('Booked'),
//                   value: isBookedRooms,
//                   onChanged: (newValue) {
//                     setState(() {
//                       isBookedRooms = newValue!;
//                       if (isBookedRooms) {
//                         fetchBookedRooms(); // Fetch booked rooms if toggled
//                       }
//                     });
//                   },
//                   controlAffinity: ListTileControlAffinity.leading,
//                 ),
//                 ListView.builder(
//                   itemCount: isBookedRooms ? bookedRooms.length : rooms.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     var room = isBookedRooms ? bookedRooms[index] : rooms[index];
//                     return Card(
//                       margin: EdgeInsets.all(10),
//                       child: ListTile(
//                         leading: SizedBox(
//                           height: 80,
//                           width: 80,
//                           child: Image(
//                             image: NetworkImage(
//                               room.image.isEmpty
//                                   ? "https://images.unsplash.com/photo-1719216324207-3b9727413913?q=80&w=2828&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
//                                   : "host/HRRSFInal/uploads/${room.image}",
//                             ),
//                             height: 80,
//                             width: 80,
//                           ),
//                         ),
//                         title: Text('Room Number:  ${room.roomNumber}'),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Price: \$${room.price.toStringAsFixed(2)}'),
//                             Text('Beds: ${room.numberOfBeds}'),
//                           ],
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.edit),
//                               onPressed: () {
//                                 _showEditDialog(room);
//                               },
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.delete),
//                               onPressed: () {
//                                 _confirmDelete(room);
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//
//
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showInputDialog(context);
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
//
//   void _showEditDialog(Room room) {
//     roomNumberController.text = room.roomNumber.toString();
//     priceController.text = room.price.toString();
//     numberOfBedsController.text = room.numberOfBeds.toString();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Edit Room'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 ElevatedButton(
//                   onPressed: () {
//                     _getImage(context);
//                   },
//                   child: Text('Pick Image'),
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: roomNumberController,
//                   decoration: InputDecoration(labelText: 'Room Number'),
//                 ),
//                 TextField(
//                   controller: priceController,
//                   decoration: InputDecoration(labelText: 'Price'),
//                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                 ),
//                 TextField(
//                   controller: numberOfBedsController,
//                   decoration: InputDecoration(labelText: 'Number of Beds'),
//                   keyboardType: TextInputType.number,
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 _updateRoomInDatabase(room);
//                 Navigator.of(context).pop();
//                 _clearControllers();
//               },
//               child: Text('Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _confirmDelete(Room room) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Confirm Delete'),
//           content: Text('Are you sure you want to delete room ${room.roomNumber}?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 _deleteRoomFromDatabase(room);
//                 Navigator.of(context).pop();
//               },
//               child: Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _updateRoomInDatabase(Room room) async {
//     var url = Uri.parse('host/HRRSFinal/edit_rooms.php');
//     var request = http.MultipartRequest('POST', url);
//     request.fields['room_number'] = roomNumberController.text;
//     request.fields['price'] = priceController.text;
//     request.fields['no_of_beds'] = numberOfBedsController.text;
//
//     if (imageFile != null) {
//       print(imageFile!.path);
//       request.files.add(await http.MultipartFile.fromPath('room_image', imageFile!.path));
//     }
//
//     var response = await request.send();
//     if (response.statusCode == 200) {
//       print('Room updated successfully');
//       fetchRooms();
//     } else {
//       print('Failed to update room. Error: ${response.reasonPhrase}');
//     }
//   }
//
//   void _deleteRoomFromDatabase(Room room) async {
//     final url = Uri.parse('host/HRRSFinal/delete_room.php');
//     final response = await http.post(url, body: {
//       'room_number': room.roomNumber.toString(),
//     });
//
//     if (response.statusCode == 200) {
//       print('Room deleted successfully');
//       fetchRooms();
//     } else {
//       print('Failed to delete room. Error: ${response.reasonPhrase}');
//     }
//   }
//
//   void _showInputDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add Room'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 ElevatedButton(
//                   onPressed: () {
//                     _getImage(context);
//                   },
//                   child: Text('Pick Image'),
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: roomNumberController,
//                   decoration: InputDecoration(labelText: 'Room Number'),
//                 ),
//                 TextField(
//                   controller: priceController,
//                   decoration: InputDecoration(labelText: 'Price'),
//                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                 ),
//                 TextField(
//                   controller: numberOfBedsController,
//                   decoration: InputDecoration(labelText: 'Number of Beds'),
//                   keyboardType: TextInputType.number,
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 _addRoomToDatabase();
//                 Navigator.of(context).pop();
//                 _clearControllers();
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _addRoomToDatabase() async {
//     var url = Uri.parse('host/HRRSFinal/room_input.php');
//     var token_value = Global.getToken();
//     var request = http.MultipartRequest('POST', url);
//     request.fields['room_number'] = roomNumberController.text;
//     request.fields['price'] = priceController.text;
//     request.fields['no_of_beds'] = numberOfBedsController.text;
//     request.headers['authorization'] = 'Bearer $token_value';
//
//     if (imageFile != null) {
//       print(imageFile!.path);
//       request.files.add(await http.MultipartFile.fromPath('room_image', imageFile!.path));
//     }
//
//     var response = await request.send();
//     if (response.statusCode == 200) {
//       print('Room added successfully');
//       fetchRooms();
//     } else {
//       print('Failed to add room. Error: ${response.reasonPhrase}');
//     }
//   }
//
//   Future<void> _getImage(BuildContext context) async {
//     final picker = ImagePicker();
//     final PickedFile? pickedImage = await picker.getImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         imageFile = File(pickedImage.path);
//       });
//     } else {
//       // Handle if no image was selected
//     }
//   }
//
//   void _clearControllers() {
//     roomNumberController.clear();
//     priceController.clear();
//     numberOfBedsController.clear();
//   }
//
//   void fetchBookedRooms() {
//     // Implement fetching booked rooms based on your API or data source
//     // Example implementation
//     bookedRooms = rooms.where((room) =>true).toList();
//   }
// }
