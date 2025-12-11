class Hostel {
  final int hostel_id;
  final String hostel_name;
  final List<String> roomNumbers;
  final List<String> roomImages;
  final double averageRating;
  final int totalReviews;

  Hostel({
    required this.hostel_id,
    required this.hostel_name,
    required this.roomNumbers,
    required this.roomImages,
    required this.averageRating,
    required this.totalReviews,
  });
}