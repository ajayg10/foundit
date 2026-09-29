/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class Location
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Location._({
    this.id,
    required this.name,
    required this.type,
    this.address,
    required this.latitude,
    required this.longitude,
    this.description,
    this.logoUrl,
    required this.isActive,
    required this.createdAt,
  });

  factory Location({
    int? id,
    required String name,
    required String type,
    String? address,
    required double latitude,
    required double longitude,
    String? description,
    String? logoUrl,
    required bool isActive,
    required DateTime createdAt,
  }) = _LocationImpl;

  factory Location.fromJson(Map<String, dynamic> jsonSerialization) {
    return Location(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      type: jsonSerialization['type'] as String,
      address: jsonSerialization['address'] as String?,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      description: jsonSerialization['description'] as String?,
      logoUrl: jsonSerialization['logoUrl'] as String?,
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String type;

  String? address;

  double latitude;

  double longitude;

  String? description;

  String? logoUrl;

  bool isActive;

  DateTime createdAt;

  /// Returns a shallow copy of this [Location]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Location copyWith({
    int? id,
    String? name,
    String? type,
    String? address,
    double? latitude,
    double? longitude,
    String? description,
    String? logoUrl,
    bool? isActive,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Location',
      if (id != null) 'id': id,
      'name': name,
      'type': type,
      if (address != null) 'address': address,
      'latitude': latitude,
      'longitude': longitude,
      if (description != null) 'description': description,
      if (logoUrl != null) 'logoUrl': logoUrl,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Location',
      if (id != null) 'id': id,
      'name': name,
      'type': type,
      if (address != null) 'address': address,
      'latitude': latitude,
      'longitude': longitude,
      if (description != null) 'description': description,
      if (logoUrl != null) 'logoUrl': logoUrl,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LocationImpl extends Location {
  _LocationImpl({
    int? id,
    required String name,
    required String type,
    String? address,
    required double latitude,
    required double longitude,
    String? description,
    String? logoUrl,
    required bool isActive,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         type: type,
         address: address,
         latitude: latitude,
         longitude: longitude,
         description: description,
         logoUrl: logoUrl,
         isActive: isActive,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Location]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Location copyWith({
    Object? id = _Undefined,
    String? name,
    String? type,
    Object? address = _Undefined,
    double? latitude,
    double? longitude,
    Object? description = _Undefined,
    Object? logoUrl = _Undefined,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Location(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address is String? ? address : this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description is String? ? description : this.description,
      logoUrl: logoUrl is String? ? logoUrl : this.logoUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
