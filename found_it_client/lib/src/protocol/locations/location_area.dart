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

abstract class LocationArea
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LocationArea._({
    this.id,
    required this.locationId,
    required this.name,
    this.latitude,
    this.longitude,
    this.description,
    required this.isActive,
  });

  factory LocationArea({
    int? id,
    required int locationId,
    required String name,
    double? latitude,
    double? longitude,
    String? description,
    required bool isActive,
  }) = _LocationAreaImpl;

  factory LocationArea.fromJson(Map<String, dynamic> jsonSerialization) {
    return LocationArea(
      id: jsonSerialization['id'] as int?,
      locationId: jsonSerialization['locationId'] as int,
      name: jsonSerialization['name'] as String,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      description: jsonSerialization['description'] as String?,
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int locationId;

  String name;

  double? latitude;

  double? longitude;

  String? description;

  bool isActive;

  /// Returns a shallow copy of this [LocationArea]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LocationArea copyWith({
    int? id,
    int? locationId,
    String? name,
    double? latitude,
    double? longitude,
    String? description,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LocationArea',
      if (id != null) 'id': id,
      'locationId': locationId,
      'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (description != null) 'description': description,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LocationArea',
      if (id != null) 'id': id,
      'locationId': locationId,
      'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (description != null) 'description': description,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LocationAreaImpl extends LocationArea {
  _LocationAreaImpl({
    int? id,
    required int locationId,
    required String name,
    double? latitude,
    double? longitude,
    String? description,
    required bool isActive,
  }) : super._(
         id: id,
         locationId: locationId,
         name: name,
         latitude: latitude,
         longitude: longitude,
         description: description,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [LocationArea]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LocationArea copyWith({
    Object? id = _Undefined,
    int? locationId,
    String? name,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? description = _Undefined,
    bool? isActive,
  }) {
    return LocationArea(
      id: id is int? ? id : this.id,
      locationId: locationId ?? this.locationId,
      name: name ?? this.name,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      description: description is String? ? description : this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}
