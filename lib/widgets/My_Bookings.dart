// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../routes/routes.dart';
// import 'package:finalproject/Global.dart';
//
// class Booking {
//   String hostelName;
//   String roomNumber;
//   String roomImage;
//   String hostelAddress;
//   String hostelContact;
//
//   Booking({
//     required this.hostelName,
//     required this.roomNumber,
//     required this.roomImage,
//     required this.hostelAddress,
//     required this.hostelContact,
//   });
//
//   factory Booking.fromJson(Map<String, dynamic> json) {
//     return Booking(
//       hostelName: json['hostel_name'],
//       roomNumber: json['room_number'],
//       roomImage: json['room_image'],
//       hostelAddress: json['hostel_address'],
//       hostelContact: json['hostel_contact'],
//     );
//   }
// }
//
//
// class BookingPage extends StatefulWidget {
//   @override
//   _BookingPageState createState() => _BookingPageState();
// }
//
// class _BookingPageState extends State<BookingPage> {
//   late Future<Booking> bookingFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     bookingFuture = fetchBookingData();
//   }
//
//   Future<Booking> fetchBookingData() async {
//     var token_value = Global.getToken();
//     final response = await http.get(Uri.parse('host/HRRSFinal/mybooking.php'), headers: {
//       'authorization': 'Bearer $token_value'
//     });
//
//     if (response.statusCode == 200) {
//       // If the server returns a 200 OK response, parse the JSON
//       print(response.body);
//       return Booking.fromJson(jsonDecode(response.body)[0]);
//     } else {
//       // If the server returns an error response, throw an exception
//       throw Exception('Failed to load booking data');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Booking Details'),
//       ),
//       body: Center(
//         child: FutureBuilder<Booking>(
//           future: bookingFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text('Error: ${snapshot.error}'),
//               );
//             } else if (!snapshot.hasData) {
//               return Center(
//                 child: Text('No data available'),
//               );
//             } else {
//               // Data has been successfully fetched
//               Booking booking = snapshot.data!;
//               return SingleChildScrollView(
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Text(
//                       booking.hostelName,
//                       style: TextStyle(
//                         fontSize: 24.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       'Room Number: ${booking.roomNumber}',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8.0),
//                       child: Image.network(
//                         booking.roomImage,
//                         width: 300, // Specify width
//                         height: 200, // Specify height
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     SizedBox(height: 16.0),
//                     Text(
//                       'Address:',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 4.0),
//                     Text(
//                       booking.hostelAddress,
//                       style: TextStyle(
//                         fontSize: 16.0,
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       'Contact:',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 4.0),
//                     Text(
//                       booking.hostelContact,
//                       style: TextStyle(
//                         fontSize: 16.0,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
//   }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../routes/routes.dart';
import 'package:finalproject/Global.dart';

class Booking {
  int bookingId;
  int hostelId;
  String hostelName;
  String roomNumber;
  String roomImage;
  String hostelAddress;
  String hostelContact;

  Booking({
    required this.hostelId,
    required this.bookingId,
    required this.hostelName,
    required this.roomNumber,
    required this.roomImage,
    required this.hostelAddress,
    required this.hostelContact,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['booking_id']==null?0:int.parse(json['booking_id']),
      hostelName: json['hostel_name'],
      roomNumber: json['room_number'],
      roomImage: json['room_image'],
      hostelAddress: json['hostel_address'],
      hostelContact: json['hostel_contact'],
      hostelId: int.parse(json['hostel_id'].toString()),
    );
  }
}

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late Future<List<Booking>> bookingFuture;
  var host = Global.getHost();

  @override
  void initState() {
    super.initState();
    bookingFuture = fetchBookingData();
  }

  Future<List<Booking>> fetchBookingData() async {
    var token_value = Global.getToken();
    final response = await http.get(
      Uri.parse('$host/HRRSFinal/mybooking.php'),
      headers: {'authorization': 'Bearer $token_value'},
    );

    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> jsonList = jsonDecode(response.body);
      List<Booking> bookings =
      jsonList.map((json) => Booking.fromJson(json)).toList();
      return bookings;
    } else {
      throw Exception('Failed to load booking data');
    }
  }

  void deleteBooking(Booking booking) async {

    var token_value = Global.getToken();
    final response = await http.post(
      Uri.parse('$host/HRRSFinal/deletebooking.php'),
      headers: {'authorization': 'Bearer $token_value'},
      body: {
        'booking_id': booking.bookingId.toString(),
        'hostel_id': booking.hostelId.toString(),
        'room_number': booking.roomNumber.toString(),
      },
    );

    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      // Handle success
      print('Booking deleted successfully');
      // Optionally, refresh the list after deletion
      setState(() {
        bookingFuture = fetchBookingData();
      });
    } else {
      // Handle error, e.g., show an error message
      print('Failed to delete booking');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: Center(
        child: FutureBuilder<List<Booking>>(
          future: bookingFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No data available'),
              );
            } else {
              // Data has been successfully fetched
              List<Booking> bookings = snapshot.data!;
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  Booking booking = bookings[index];
                  return Card(
                    child: Column(
                      children: <Widget>[
                        Text(
                          booking.hostelName,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Room Number: ${booking.roomNumber}',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network("$host/HRRSFinal/uploads/${booking.roomImage}"
                            ,
                            width: 300, // Specify width
                            height: 200, // Specify height
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Address:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          booking.hostelAddress,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Contact:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          booking.hostelContact,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Deletion'),
                                  content: Text(
                                      'Are you sure you want to delete this booking?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Confirm'),
                                      onPressed: () {
                                        deleteBooking(booking);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
