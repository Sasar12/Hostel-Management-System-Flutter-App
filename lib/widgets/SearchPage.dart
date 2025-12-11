// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:finalproject/routes/routes.dart';
// import 'Booking.dart' show RoomDetailsPage;
//
// class Hostel {
//   final String hostel_name;
//   final List<String> roomNumbers;
//
//   Hostel({
//     required this.hostel_name,
//     required this.roomNumbers,
//   });
// }
//
// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   TextEditingController searchdata = TextEditingController();
//   List<Hostel> hostels = [];
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   // Function to perform search and fetch data
//   search() async {
//     final uri = Uri.parse('host/HRRSFinal/search.php').replace(
//       queryParameters: {
//         'hostel_name': searchdata.text,
//       },
//     );
//     final response = await http.get(uri);
//
//     if (response.statusCode == 200) {
//       try {
//         var tempList = jsonDecode(response.body) as List;
//         List<Hostel> tempHostels = tempList.map((e) {
//           return Hostel(
//             hostel_name: e['hostel_name'] == null ? "" : e['hostel_name'],
//             roomNumbers: [], // Initialize room numbers as empty initially
//           );
//         }).toList();
//
//         setState(() {
//           hostels = tempHostels;
//         });
//
//         showDialog(
//           context: context,
//           builder: (BuildContext context) => AlertDialog(
//             title: Text("Search Results"),
//             content: Container(
//               width: double.maxFinite,
//               child: ListView.builder(
//                 itemCount: hostels.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return FutureBuilder(
//                     future: fetchHostelReviews(hostels[index].hostel_name), // Assuming this function fetches reviews
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       } else if (snapshot.hasError) {
//                         return Text("Error loading reviews: ${snapshot.error}");
//                       } else {
//                         var reviews = snapshot.data;
//                         double averageRating = calculateAverageRating(reviews);
//                         int totalReviewers = reviews==null?0:reviews.length;
//
//                         return ListTile(
//                           title: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(hostels[index].hostel_name),
//                               SizedBox(height: 4),
//                               Row(
//                                 children: [
//                                   Text('Rating: ${averageRating.toStringAsFixed(1)}/5'),
//                                   Icon(Icons.star, color: Colors.amber, size: 16),
//                                   Text(' ($totalReviewers reviews)'),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           onTap: () async {
//                             // Fetch room numbers for the selected hostel
//                             final roomResponse = await http.post(
//                               Uri.parse('host/HRRSFinal/roomconnect.php'),
//                               body: {
//                                 "hostel_name": hostels[index].hostel_name
//                               },
//                             );
//
//                             if (roomResponse.statusCode == 200) {
//                               try {
//                                 var roomList = jsonDecode(roomResponse.body) as List;
//                                 List<dynamic> rooms = roomList.map((e) {
//                                   return e['room_number'] == null ? "" : e['room_number'].toString();
//                                 }).toList();
//
//                                 // Show another overlay dialog with room numbers
//                                 showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) => AlertDialog(
//                                     title: Text("Room Numbers for ${hostels[index].hostel_name}"),
//                                     content: Container(
//                                       width: double.maxFinite,
//                                       child: ListView.builder(
//                                         itemCount: rooms.length,
//                                         itemBuilder: (BuildContext context, int idx) {
//                                           return ListTile(
//                                             title: Text(rooms[idx]),
//                                             onTap: () {
//                                               // Handle tap on room number (if needed)
//                                               print("Selected room: ${rooms[idx]}");
//                                               Map<String, dynamic> selectedRoom = roomList[idx] as Map<String, dynamic>;
//                                               Navigator.push(context, MaterialPageRoute(builder: (context) => RoomDetailsPage(selectedRoom)));
//
//                                               // Close room number dialog
//                                             },
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                 );
//
//                               } catch (e) {
//                                 print("Error parsing JSON for room numbers: $e");
//                                 // Handle JSON parsing error for room numbers
//                               }
//                             } else {
//                               print("Failed to load room numbers");
//                               // Handle HTTP error for room numbers
//                             }
//                           },
//                         );
//                       }
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//
//       } catch (e) {
//         print("Error parsing JSON: $e");
//         // Handle JSON parsing error, e.g., show a message to the user
//       }
//     } else {
//       print("Failed to load data");
//       // Handle HTTP error, e.g., show a message to the user
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF6F7FF),
//       appBar: AppBar(
//         elevation: 0.0,
//         backgroundColor: Color(0xFFF6F7FF),
//         title: Row(
//           children: [
//             IconButton(
//               onPressed: () {},
//               icon: Icon(
//                 Icons.menu,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Welcome To HRRS",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 26.0,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             Text(
//               "Pick your Hostel",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.w300,
//               ),
//             ),
//             SizedBox(height: 30.0),
//             Material(
//               elevation: 10.0,
//               borderRadius: BorderRadius.circular(30.0),
//               shadowColor: Color(0x55434343),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: searchdata,
//                       textAlign: TextAlign.start,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         hintText: "Search for Hostel or place...",
//                         prefixIcon: Icon(
//                           Icons.search,
//                           color: Colors.black54,
//                         ),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       search();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       foregroundColor: Colors.blue,  // foreground color
//                     ),
//                     child: Text('Search'),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 30,),
//             Expanded(
//               child: DefaultTabController(
//                 length: 2,
//                 child: Column(
//                   children: [
//                     TabBar(
//                       indicatorColor: Color(0xFFFE8C68),
//                       unselectedLabelColor: Color(0xFF555555),
//                       labelColor: Color(0xFFFE8C68),
//                       labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
//                       tabs: [
//                         Tab(
//                           text: "Popular",
//                         ),
//                         Tab(
//                           text: "Recently Added",
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20.0,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Function to fetch reviews for a hostel
//   Future<List<Map<String, dynamic>>> fetchHostelReviews(String hostelName) async {
//     final reviewResponse = await http.post(
//       Uri.parse('host/HRRSFinal/reviewconnect.php'),
//       body: {
//         "hostel_name": hostelName,
//       },
//     );
//
//     if (reviewResponse.statusCode == 200) {
//       try {
//         var reviewList = jsonDecode(reviewResponse.body) as List;
//         List<Map<String, dynamic>> reviews = reviewList.map((e) => e as Map<String, dynamic>).toList();
//         return reviews;
//       } catch (e) {
//         print("Error parsing JSON for reviews: $e");
//         return [];
//       }
//     } else {
//       print("Failed to load reviews");
//       return [];
//     }
//   }
//
//   // Function to calculate average rating
//   double calculateAverageRating(List<Map<String, dynamic>>? reviews) {
//     if (reviews == null || reviews.isEmpty) return 0.0;
//
//     double sum = 0.0;
//     for (var review in reviews) {
//       // Ensure 'rating' is not null or empty before parsing
//       var rating = review['rating'];
//       if (rating != null && rating.isNotEmpty) {
//         sum += double.parse(rating);
//       }
//     }
//
//     return reviews.length > 0 ? sum / reviews.length : 0.0;
//   }
//
// }
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'SearchResults.dart'; // Import the SearchResultsPage
//
// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search Hostels'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Enter hostel name',
//                 ),
//               ),
//               SizedBox(height: 20.0),
//               ElevatedButton(
//                 onPressed: () {
//                   String searchQuery = searchController.text.trim();
//                   if (searchQuery.isNotEmpty) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SearchResultsPage(searchQuery),
//                       ),
//                     );
//                   } else {
//                     // Handle empty search query
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Please enter a hostel name to search.'),
//                       ),
//                     );
//                   }
//                 },
//                 child: Text('Search'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'Booking.dart' show RoomDetailsPage;
// import 'SearchResults.dart';
// import 'package:finalproject/hostel.dart';
//
// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   TextEditingController searchdata = TextEditingController();
//   List<Hostel> hostels = [];
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   // Function to perform search and fetch data
//   search() async {
//     final uri = Uri.parse('host/HRRSFinal/search.php').replace(
//       queryParameters: {
//         'hostel_name': searchdata.text,
//       },
//     );
//     final response = await http.get(uri);
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       try {
//         var tempList = jsonDecode(response.body) as List;
//         List<Hostel> tempHostels = tempList.map((e) {
//           return Hostel(
//             hostel_name: e['hostel_name'] == null ? "" : e['hostel_name'],
//             roomNumbers: [],
//             averageRating: 0.0,
//             totalReviews: 0 // Initialize room numbers as empty initially
//           );
//         }).toList();
//
//         setState(() {
//           hostels = tempHostels;
//         });
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SearchResultPage(hostels: hostels),
//           ),
//         );
//
//       } catch (e) {
//         print("Error parsing JSON: $e");
//         // Handle JSON parsing error, e.g., show a message to the user
//       }
//     } else {
//       print("Failed to load data");
//       // Handle HTTP error, e.g., show a message to the user
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Welcome To HRRS",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 26.0,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             Text(
//               "Pick your Hostel",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.w300,
//               ),
//             ),
//             SizedBox(height: 30.0),
//             Material(
//               elevation: 10.0,
//               borderRadius: BorderRadius.circular(30.0),
//               shadowColor: Color(0x55434343),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: searchdata,
//                       textAlign: TextAlign.start,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         hintText: "Search for Hostel or place...",
//                         prefixIcon: Icon(
//                           Icons.search,
//                           color: Colors.black54,
//                         ),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       search();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       foregroundColor: Colors.blue,  // foreground color
//                     ),
//                     child: Text('Search'),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 30,),
//             Expanded(
//               child: DefaultTabController(
//                 length: 2,
//                 child: Column(
//                   children: [
//                     TabBar(
//                       indicatorColor: Color(0xFFFE8C68),
//                       unselectedLabelColor: Color(0xFF555555),
//                       labelColor: Color(0xFFFE8C68),
//                       labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
//                       tabs: [
//                         Tab(
//                           text: "Popular",
//                         ),
//                         Tab(
//                           text: "Recently Added",
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20.0,
//                     ),
//                   ],
//                 ),
//               ),
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
import 'Booking.dart' show RoomDetailsPage;
import 'SearchResults.dart';
import 'package:finalproject/hostel.dart';
import '../routes/routes.dart';
import 'package:finalproject/helper.dart';
import 'package:finalproject/Global.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {
  TextEditingController searchdata = TextEditingController();
  List<Hostel> hostels = [];
  Helper helper = new Helper();
  var token_value = Global.getToken();
  var host = Global.getHost();

  // Method to fetch data from 'popular.php'
  Future<List<Hostel>> fetchDataFromPopular() async {
    final uri = Uri.parse('$host/HRRSFinal/popular.php');
    final response = await http.get(uri, headers: {
      'authorization' : 'Bearer $token_value'
    });
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      try {
        var tempList = jsonDecode(response.body) as List;
        List<Hostel> tempHostels = tempList.map((e) {
          return Hostel(
            hostel_id:int.parse(e['hostel_id']),
            hostel_name: e['hostel_name'] == null ? "" : e['hostel_name'],
            roomNumbers: [], // Initialize as empty initially
            roomImages: e['room_images'].cast<String>(),
            averageRating: double.parse(e['average_rating'].toString()),
            totalReviews: int.parse(e['total_reviews'].toString()),
          );
        }).toList();
        
        tempHostels.forEach((hostel){
          print("[SEARCH-PAGE] - The hostel roomImages value is: ${hostel.roomImages}");
        });
        return tempHostels;
      } catch (e) {
        throw Exception("Error parsing JSON");
      }
    } else {
      throw Exception("Failed to load data");
    }
  }

  // Method to fetch data from 'recently.php'
  Future<List<Hostel>> fetchDataFromRecentlyAdded() async {
    final uri = Uri.parse('$host/HRRSFinal/recently.php');
    final response = await http.get(uri, headers: {
      'authorization' : 'Bearer $token_value'
    });

    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      try {
        var tempList = jsonDecode(response.body) as List;
        List<Hostel> tempHostels = tempList.map((e) {
          return Hostel(
            hostel_id: int.parse(e['hostel_id']),
            hostel_name: e['hostel_name'] == null ? "" : e['hostel_name'],
            roomNumbers: [], // Initialize as empty initially
            roomImages: e['room_images'].cast<String>(),
            averageRating : double.parse(e['average_rating'].toString()),
            totalReviews: int.parse(e['total_reviews'].toString()),
          );
        }).toList();
        return tempHostels;
      } catch (e) {
        print(e.toString());
        throw Exception("Error parsing JSON");
      }
    } else {
      throw Exception("Failed to load data");
    }
  }

  // Function to perform search and fetch data
  search() async {
    final uri = Uri.parse('$host/HRRSFinal/search.php').replace(
      queryParameters: {
        'hostel_name': searchdata.text,
      },
    );
    final response = await http.get(uri);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      try {
        // print()
        var tempList = jsonDecode(response.body) as List;
        List<Hostel> tempHostels = tempList.map((e) {
          return Hostel(
              hostel_id: int.parse(e['hostel_id'].toString()),
              hostel_name: e['hostel_name'] == null ? "" : e['hostel_name'],
              roomNumbers: [],
            roomImages: e['room_images'].cast<String>(),
            averageRating : double.parse(e['average_rating'].toString()),
              totalReviews: int.parse(e['total_reviews'].toString()), // Initialize room numbers as empty initially
          );
        }).toList();

        setState(() {
          hostels = tempHostels;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultPage(hostels: hostels),
          ),
        ).then((value) => setState(() {
          searchdata.text = '';

        }));
      } catch (e) {
        print("Error parsing JSON: $e");
        // Handle JSON parsing error, e.g., show a message to the user
      }
    } else {
      print("Failed to load data");
      // Handle HTTP error, e.g., show a message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
      Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: Colors.blue, // Background color of the header
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Aligns buttons to the end (right)
        children: [
          TextButton(
            onPressed: () {
              // Action for My Bookings button
              Navigator.pushNamed(context, MyRoutes.BookingPageRoute);
            },
            child: Text(
              'My Bookings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 20), // Adjust spacing between buttons if necessary
          TextButton(
            onPressed: () {

             // Action for Logout button
              helper.logout(context);
            },
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
          // Header and search section

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome To HRRS",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Pick your Hostel",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Material(
                    elevation: 10.0,
                    borderRadius: BorderRadius.circular(30.0),
                    shadowColor: Color(0x55434343),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchdata,
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: "Search for Hostel or place...",
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black54,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            search();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.blue, // foreground color
                          ),
                          child: Text('Search'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            indicatorColor: Color(0xFFFE8C68),
                            unselectedLabelColor: Color(0xFF555555),
                            labelColor: Color(0xFFFE8C68),
                            labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                            tabs: [
                              Tab(
                                text: "Popular",
                              ),
                              Tab(
                                text: "Recently Added",
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                // Popular Hostels Tab View
                                Container(
                                  child: FutureBuilder(
                                    future: fetchDataFromPopular(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text("Error: ${snapshot.error}"));
                                      } else {
                                        return ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              onTap: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => SearchResultPage(hostels: snapshot.data!.sublist(index,index+1)),
                                                  ),
                                                );
                                              },
                                              title: Text(snapshot.data![index].hostel_name),
                                              // Adjust as per your Hostel class structure
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                                // Recently Added Hostels Tab View
                                Container(
                                  child: FutureBuilder(
                                    future: fetchDataFromRecentlyAdded(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text("Error: ${snapshot.error}"));
                                      } else {
                                        return ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              onTap: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => SearchResultPage(hostels: snapshot.data!.sublist(index,index+1)),
                                                  ),
                                                );
                                              },
                                              title: Text(snapshot.data![index].hostel_name),
                                              // Adjust as per your Hostel class structure
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
