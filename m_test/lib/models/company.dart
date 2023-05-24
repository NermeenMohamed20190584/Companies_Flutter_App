class Company {
  final dynamic companyId;
  final dynamic name;
  final dynamic address;
  final dynamic phone;
  final dynamic email;
  final dynamic imageUrl;
  final dynamic logoUrl;
  final dynamic description;
  final dynamic location;
  final dynamic size;

  Company({
    required this.companyId,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.imageUrl,
    required this.logoUrl,
    required this.description,
    required this.size,
    required this.location

  });

  //get id => null;
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyId: json['Id'],
      name: json['companyname'],
      address: json['companyddress'],
      phone: json['contactpersonphonenumber'],
      email: json['Email'],
      imageUrl: json['Image'],
      logoUrl: json['logourl'],
      description: json['Description'],
      location: json['Location'],
      size: json['companysize']
    );
  }
}