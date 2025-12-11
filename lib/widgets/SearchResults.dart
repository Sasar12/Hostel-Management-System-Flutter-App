import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Booking.dart' show RoomDetailsPage;
import 'SearchPage.dart';
import 'package:finalproject/hostel.dart';
import 'package:flutter/src/material/icons.dart';
import 'Review.dart';
import 'package:finalproject/Global.dart';


class SearchResultPage extends StatelessWidget {
  final List<Hostel> hostels;

  SearchResultPage({required this.hostels});
  var host = Global.getHost();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: hostels.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child:
                  hostels[index].roomImages.isEmpty?SizedBox(
                    height: 170,
                    width: 200,
                    child: Image.asset("assets/images/default_room.jpg"),
                  ):CarouselSlider(items: hostels[index].roomImages.map((imageUrl)=>Image(image: NetworkImage("$host/HRRSFinal/uploads/$imageUrl"))).toList(), options: CarouselOptions()),
                      ),
                  Text(hostels[index].hostel_name),
                  SizedBox(height: 2),
                  Text('Rating: ${hostels[index].averageRating.toStringAsFixed(1)}/5  (${hostels[index].totalReviews} reviews)'),
                  TextButton(onPressed:() {
                    print("The hostel id is: ${hostels[index].hostel_id}");
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ReviewPage(hostelId: hostels[index].hostel_id, canReview: true,)));
                  }, child:const Text('reviews')),
                ],
              ),
              onTap: () async {
                print(hostels[index].hostel_name);
                // Fetch room numbers for the selected hostel
                final roomResponse = await http.post(
                  Uri.parse('$host/HRRSFinal/roomconnect.php'),
                  body: {
                    "hostel_name": hostels[index].hostel_name
                  },
                );
                print(roomResponse.body);
                if (roomResponse.statusCode == 200) {
                  try {

                    List<dynamic> roomList = jsonDecode(roomResponse.body) as List<dynamic>;
                    List<dynamic> rooms = roomList;
                    // print(roomList[0]["room_number"]);
                    // Show another overlay dialog with room numbers
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("Room Numbers for ${hostels[index].hostel_name}"),
                        content: Container(
                          width: double.maxFinite,
                          child: ListView.builder(
                            itemCount: rooms.length,
                            itemBuilder: (BuildContext context, int idx) {
                              return ListTile(
                                title: Text(rooms[idx]['room_number'].toString()),
                                onTap: () {
                                  // Handle tap on room number (if needed)
                                  print("Selected room: ${rooms[idx]}");
                                  // print("Selected room number is: ${rooms[idx]}")
                                  Map<String, dynamic> selectedRoom = roomList[idx] as Map<String, dynamic>;
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RoomDetailsPage(selectedRoom)));

                                  // Close room number dialog
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );

                  } catch (e) {
                    print("Error parsing JSON for room numbers: $e");
                    // Handle JSON parsing error for room numbers
                  }
                } else {
                  print("Failed to load room numbers");
                  // Handle HTTP error for room numbers
                }
              },
            );
          },
        ),
      ),
    );
  }
}
