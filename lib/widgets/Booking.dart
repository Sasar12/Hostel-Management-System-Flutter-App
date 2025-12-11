// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../routes/routes.dart';
//
//
//
// class Room {
//   final String imageUrl;
//   final double price;
//   final int beds;
//
//   Room({required this.imageUrl, required this.price, required this.beds});
//
//   factory Room.fromJson(Map<String, dynamic> json) {
//     print(json['numberOfBeds']);
//     return Room(
//       imageUrl: json['image']==null?"":json['image'],
//       price: double.parse(json['price']),
//       beds: int.parse(json['numberOfBeds']),
//     );
//   }
// }

// class RoomService {
//   static Future<Room> fetchRoomDetails() async {
//     var url =  Uri.parse('http://182.168.4.199/HRRSFinal/particularroomsfetch.php');


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../routes/routes.dart';
// import 'package:finalproject/Global.dart';
//
//
// class Room {
//   final int hostelId;
//   final int roomNumber;
//   final String imageUrl;
//   final double price;
//   final int beds;
//
//   Room({required this.roomNumber, required this.hostelId, required this.imageUrl, required this.price, required this.beds});
//
//   factory Room.fromJson(Map<String, dynamic> json) {
//     print(json['numberOfBeds']);
//     return Room(
//       roomNumber: int.parse(json['roomNumber']),
//       hostelId: int.parse(json['hostelId']),
//       imageUrl: json['image']==null?"":json['image'],
//       price: double.parse(json['price']),
//       beds: int.parse(json['numberOfBeds']),
//     );
//   }
// }
//
// // class RoomService {
// //   static Future<Room> fetchRoomDetails() async {
// //     var url =  Uri.parse('http://192.168.1.67/HRRSFinal/particularroomsfetch.php');
// //     var request = http.MultipartRequest('GET', url);
// //     request.fields['room_number'] = ;
// //     var StreamedResponse = await request.send();
// //     var response = await http.Response.fromStream(StreamedResponse);
// //     if (response.statusCode == 200) {
// //       return Room.fromJson(json.decode(response.body));
// //     } else {
// //       throw Exception('Failed to load room details');
// //     }
// //   }
// // }
//
// class RoomDetailsPage extends StatefulWidget {
//   late Map<String, dynamic> room;
//
//   RoomDetailsPage(Map<String, dynamic> room){
//     this.room = room;
//   }
//   @override
//   _RoomDetailsPageState createState() => _RoomDetailsPageState(room);
// }
//
// class _RoomDetailsPageState extends State<RoomDetailsPage> {
//   late Room _roomDetails;
//
//   late Map<String, dynamic> room;
//
//   void fetchRoomDetails() async {
//     final queryParameters = {
//       'room_number': room["room_number"].toString()
//     };
//     print(queryParameters['room_number']);
//     var url =  Uri.http("192.168.1.67","/HRRSFinal/particularroomsfetch.php", queryParameters);


//     var request = http.MultipartRequest('GET', url);
//     request.fields['room_number'] = room["room_number"].toString();
//     var StreamedResponse = await request.send();
//     var response = await http.Response.fromStream(StreamedResponse);
//     print("The response from particularroomsfetch is: ${response.body}");
//     if (response.statusCode == 200) {
//       setState(() {
//         _roomDetails = Room.fromJson(json.decode(response.body));
//       });
//     } else {
//       throw Exception('Failed to load room details');
//     }
//   }
//
//   _RoomDetailsPageState(Map<String, dynamic> room){
//     this.room = room;
//   }
//   @override
//   void initState(){
//     super.initState();
//     _roomDetails = Room(roomNumber:0,hostelId:0, imageUrl: "", price: 0, beds: 0);
//     // print(room["room_number"]);
//     // fetchRoomDetails();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Room Details'),
//       ),
//       body: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Image.network(
//           _roomDetails.imageUrl,
//           width: 300,
//           height: 200,
//           fit: BoxFit.cover,
//         ),
//         SizedBox(height: 20),
//         Text(
//           'Price: \$${room['price']}',
//           style: TextStyle(fontSize: 20),
//         ),
//         SizedBox(height: 10),
//         Text(
//           'Number of Beds: ${room["no_of_beds"]}',
//           style: TextStyle(fontSize: 20),
//         ),
//         SizedBox(height: 30),
//         ElevatedButton(
//           onPressed: () {
//             // Implement your book button functionality here
//             RoomBook(new Room(roomNumber: int.parse(room['room_number']), hostelId: int.parse(room['hostel_id']), imageUrl: room['room_image'], price: double.parse(room['room_price']), beds: int.parse(room['no_of_beds'])));
//             // _bookRoom(_roomDetails);
//           },
//           child: Text('Book'),
//         ),
//       ],
//     ),
//     );
//   }
//   RoomBook(Room room) async{
//     var token_value = Global.getToken();
//     var url = Uri.parse('host/HRRSFinal/booking.php');
//     var response = await  http.post(url, body: {
//       'hostelId': room.hostelId.toString(),
//       'roomNumber': room.roomNumber.toString(),
//     }, headers: {
//       'authorization': 'Bearer $token_value'
//     });
//     print(response.statusCode);
//     print(response.body);
//     if(response.statusCode == 200){
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Booked Successsfully'),
//     duration: Duration(seconds: 2),));
//     }
//     else{
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(jsonDecode(response.body)['msg']),
//         duration: Duration(seconds: 2),));
//     }
//   }
//
//   void _bookRoom(Room room) {
//     // Implement your booking logic here
//     // For example, navigate to a booking confirmation page
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => BookingConfirmationPage(room: room)),
//     );
//   }
// }
// class BookingConfirmationPage extends StatelessWidget {
//   final Room room;
//
//   const BookingConfirmationPage({Key? key, required this.room}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Booking Confirmation'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Thank you for booking!',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             Image.network(
//               room.imageUrl,
//               width: 300,
//               height: 200,
//               fit: BoxFit.cover,
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Price: \$${room.price.toStringAsFixed(2)}',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Number of Beds: ${room.beds}',
//               style: TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Global.dart'; // Assuming Global.dart contains the Global class and getToken method
import '../routes/routes.dart'; // Import your routes if needed
import 'Review.dart';

class Room {
  final int hostelId;
  final int roomNumber;
  final String imageUrl;
  final double price;
  final int beds;
  final int noOfAvailBeds;
  
  Room({
    required this.noOfAvailBeds,
    required this.roomNumber,
    required this.hostelId,
    required this.imageUrl,
    required this.price,
    required this.beds,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomNumber: int.parse(json['roomNumber']),
      hostelId: int.parse(json['hostelId']),
      imageUrl: json['image'] == null ? "" : json['image'],
      price: double.parse(json['price']),
      beds: int.parse(json['numberOfBeds']),
      noOfAvailBeds: int.parse(json['no_of_avail_beds'])
    );
  }
}

class RoomDetailsPage extends StatefulWidget {
  final Map<String, dynamic> room;

  RoomDetailsPage(this.room);

  @override
  _RoomDetailsPageState createState() => _RoomDetailsPageState(room);
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  late Room _roomDetails;
  var host = Global.getHost();
  _RoomDetailsPageState(Map<String, dynamic> room) {
    this._roomDetails = Room(
      roomNumber: int.parse(room['room_number'].toString()),
      hostelId: int.parse(room['hostel_id'].toString()),
      imageUrl: room['room_image'],
      price: double.parse(room['room_price'].toString()),
      beds: int.parse(room['no_of_beds'].toString()),
      noOfAvailBeds: int.parse(room['no_of_avail_beds'].toString()),
    );
  }

  @override
  void initState() {
    super.initState();
  }

//   void fetchRoomDetails() async {
// final queryParameters = {
// 'room_number': room["room_number"].toString()
// };
// print(queryParameters['room_number']);
// var url = Uri.http("182.168.4.199","/HRRSFinal/particularroomsfetch.php", queryParameters);
// var request = http.MultipartRequest('GET', url);
// request.fields['room_number'] = room["room_number"].toString();
// var StreamedResponse = await request.send();
// var response = await http.Response.fromStream(StreamedResponse);
//
// }
  void _showConfirmationDialog(Room room) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Room Image: ${room.imageUrl}'),
              Text('Room Number: ${room.roomNumber}'),
              Text('Price: \$${room.price.toStringAsFixed(2)}'),
              Text('Total Number of Beds: ${room.beds}'),
              Text('Number of Available Beds: ${room.noOfAvailBeds}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _bookRoom(room); // Call the booking function
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _bookRoom(Room room) async {
    var token_value = Global.getToken(); // Assuming this function gets the token
    var url = Uri.parse('$host/HRRSFinal/booking.php');
    var response = await http.post(
      url,
      body: {
        'hostelId': room.hostelId.toString(),
        'roomNumber': room.roomNumber.toString(),
      },
      headers: {
        'authorization': 'Bearer $token_value',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      // Booking successful
      // Booking failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking Successfull'),
          duration: Duration(seconds: 5),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context)=> ReviewPage(hostelId: room.hostelId, canReview: true)
        ),
        ModalRoute.withName("/SearchPage")
      );
    } else {
      // Booking failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking failed. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("The image url is: ${_roomDetails.imageUrl}");
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Details'),
      ),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _roomDetails.imageUrl==""?Image.asset("assets/images/login.jpeg", fit: BoxFit.cover):
          Image.network("$host/HRRSFinal/uploads/${_roomDetails.imageUrl}",
            width: 300,
            height: 200,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Text(
            'Price: \$${_roomDetails.price.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Total Number of Beds: ${_roomDetails.beds}',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Number of Available Beds: ${_roomDetails.noOfAvailBeds}',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              _showConfirmationDialog(_roomDetails);
            },
            child: Text('Book'),
          ),
        ],
      ),
        ),
    );
  }
}

class BookingConfirmationPage extends StatelessWidget {
  final Room room;

  const BookingConfirmationPage({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Confirmation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Thank you for booking!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Image.network(
              room.imageUrl,
              width: 300,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'Price: Rs. ${room.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Number of Beds: ${room.beds}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
