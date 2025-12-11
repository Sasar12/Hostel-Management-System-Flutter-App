import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalproject/Global.dart';
import 'package:finalproject/routes/routes.dart';
import 'package:finalproject/helper.dart';

class ReviewPage extends StatefulWidget {
  final int hostelId;
  final bool canReview;

  ReviewPage({required this.hostelId, required this.canReview}) {
    print(this.hostelId);
  }

  @override
  _ReviewPageState createState() =>
      _ReviewPageState(hostelId: hostelId, canReview: canReview);
}

class _ReviewPageState extends State<ReviewPage> {
  TextEditingController reviewController = TextEditingController();
  List<Review> reviews = [];
  var starRating;
  var token_value = Global.getToken();
  final int hostelId;
  final bool canReview;
  Helper helper = new Helper();
  var host = Global.getHost();

  _ReviewPageState({required this.hostelId, required this.canReview});

  void postReview() async {
    final response = await http.post(
        Uri.parse('$host/HRRSFinal/review.php'),
        body: {
          'reviews': reviewController.text,
          'rating': starRating.toString(), // Convert starRating to String
          'hostel_id': hostelId.toString(), // Convert to String
        },
        headers: {'authorization': 'Bearer $token_value'});
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      fetchReviews(hostelId);
      calculateAverageRating();
      setState(() {
        starRating = 0;
        reviewController.text = '';
      });
    } else {
      print('Failed to post review');
    }
  }

  void calculateAverageRating() async {
    double totalRating = 0.0;
    for (var review in reviews) {
      totalRating += review.rating;
      print("The total rating is: $totalRating");
    }
    double averageRating = totalRating / reviews.length;
    // Update UI or save averageRating to database
    print("The average rating is: $averageRating");
    var url = Uri.parse("$host/HRRSFinal/averageRating.php");
    var response = await http.post(url, body: {
      'hostel_id': hostelId.toString(),
      'average_rating': averageRating.toString()
    }, headers: {
      'authorization': 'Bearer $token_value'
    });
    print("The response is: ${response.body}");
    print("The status code is: ${response.statusCode}");
  }

  void fetchReviews(int hostel_id) async {
    var url = Uri.parse(
        "$host/HRRSFinal/reviewfetch.php?hostel_id=$hostel_id");
    var response = await http.get(url, headers: {
      'authorization': 'Bearer $token_value'
    });
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> resultList =
      jsonDecode(response.body) as List<dynamic>;
      setState(() {
        reviews = resultList
            .map((e) =>
        new Review(e['reviews'], double.parse(e['rating']), e['email']))
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonDecode(response.body)['msg']),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  void initState() {
    fetchReviews(hostelId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Page'),
        actions: <Widget>[
          // TextButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, MyRoutes.searchRoute).then((value) =>setState(() {
          //       reviewController.text = '';
          //       starRating = null;
          //     }));
          //   },
          //     child: Text("search Page"),
          // ),
          TextButton(
            onPressed: () {

              helper.logout(context);
              // Implement logout functionality
            },
            child: Text("logout"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            canReview
                ? Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: reviewController,
                    decoration:
                    InputDecoration(labelText: 'Write your review'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Rate this app:',
                  ),
                  Row(
                    children: [
                      // Create 5 star icons
                      for (int i = 1; i <= 5; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              starRating = i;
                            });
                          },
                          child: Icon(
                            starRating != null && starRating >= i
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.orange,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      postReview();
                    },
                    child: Text('Submit Review'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            )
                : Container(),
            Text('User Reviews:'),
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(reviews[index].email), // Display user's email
                        Text(reviews[index].review),
                        Row(
                          children: [
                            // Display star icons based on rating
                            for (int i = 1; i <= 5; i++)
                              Icon(
                                i <= reviews[index].rating.round()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.orange,
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Review {
  String review;
  double rating;
  String email; // Add email field

  Review(this.review, this.rating, this.email);
}
