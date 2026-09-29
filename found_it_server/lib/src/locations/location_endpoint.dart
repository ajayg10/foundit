import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint handling Location and LocationArea management, lookup, and search.
class LocationEndpoint extends Endpoint {
  /// Fetches a location by ID.
  Future<Location?> getLocation(Session session, int id) async {
    return await Location.db.findById(session, id);
  }

  /// Lists all active locations with optional search and type filtering.
  Future<List<Location>> listLocations(
    Session session, {
    String? query,
    String? type,
  }) async {
    return await Location.db.find(
      session,
      where: (t) {
        Expression filter = t.isActive.equals(true);
        if (type != null && type.isNotEmpty && type != 'all') {
          filter = filter & t.type.equals(type);
        }
        if (query != null && query.trim().isNotEmpty) {
          final q = query.trim().toLowerCase();
          filter = filter & (t.name.ilike('%$q%') | t.address.ilike('%$q%'));
        }
        return filter;
      },
      orderBy: (t) => t.name,
    );
  }

  /// Creates a new location.
  Future<Location> createLocation(Session session, Location location) async {
    final now = DateTime.now();
    final toInsert = location.copyWith(
      createdAt: now,
      isActive: true,
    );
    return await Location.db.insertRow(session, toInsert);
  }

  /// Fetches areas belonging to a specific location.
  Future<List<LocationArea>> getLocationAreas(
    Session session,
    int locationId,
  ) async {
    return await LocationArea.db.find(
      session,
      where: (t) => t.locationId.equals(locationId) & t.isActive.equals(true),
      orderBy: (t) => t.name,
    );
  }

  /// Creates an area within a location.
  Future<LocationArea> createLocationArea(
    Session session,
    LocationArea area,
  ) async {
    final toInsert = area.copyWith(
      isActive: true,
    );
    return await LocationArea.db.insertRow(session, toInsert);
  }
}
