class BusinessService {
  final dynamic id;
  final dynamic name;
  final dynamic description;
  final dynamic price;
  final dynamic rating;
  dynamic isFavorite;
  final dynamic imageUrl;
  dynamic companyId;

  BusinessService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.isFavorite,
    required this.imageUrl,
    required this.companyId,
  });

  factory BusinessService.fromJson(Map<String, dynamic> json) {
    return BusinessService(
      id: json['Id'],
      name: json['Title'],
      description: json['Description'],
      price: json['Price'],
      rating: json['Rating'],
      isFavorite: json['Isfavourite'] as bool,
      imageUrl: json['image_url'],
      companyId: json['company_id'],
    );
  }
}