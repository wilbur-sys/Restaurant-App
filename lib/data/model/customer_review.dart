// model untuk menyimpan data customer review
class CustomerReview {
  // nama customer yang memberi review
  final String name;

  // isi review dari customer
  final String review;

  // tanggal review dibuat
  final String date;

  // constructor untuk inisialisasi data review
  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  // factory untuk convert JSON ke object CustomerReview
  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    // ambil data name, review, dan date dari JSON
    return CustomerReview(
      name: json['name'],
      review: json['review'],
      date: json['date'],
    );
  }
}
