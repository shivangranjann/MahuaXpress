class UserAddressModel {
  final String id;
  final String label;
  final String flatNumber;
  final String buildingName;
  final String addressLine;
  final String area;
  final String city;
  final bool isDefault;

  UserAddressModel({
    required this.id,
    required this.label,
    required this.flatNumber,
    required this.buildingName,
    required this.addressLine,
    required this.area,
    required this.city,
    this.isDefault = false,
  });

  String get shortDisplay => '$label - $flatNumber, $buildingName';
  String get fullDisplay => '$flatNumber, $buildingName, $addressLine, $area, $city';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'flatNumber': flatNumber,
      'buildingName': buildingName,
      'addressLine': addressLine,
      'area': area,
      'city': city,
      'isDefault': isDefault,
    };
  }

  factory UserAddressModel.fromJson(Map<String, dynamic> json) {
    return UserAddressModel(
      id: json['id'] as String,
      label: json['label'] as String,
      flatNumber: json['flatNumber'] as String,
      buildingName: json['buildingName'] as String,
      addressLine: json['addressLine'] as String,
      area: json['area'] as String,
      city: json['city'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }
}
