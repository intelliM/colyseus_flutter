library carousel_slider;

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'room.dart';

class MatchMakeError extends Error {
  final String message;

  MatchMakeError(this.message);
}

class Client {
  String endpoint;

  Client(this.endpoint);

  Future<Room> joinOrCreate(String roomName, {Map<String, dynamic> options}) {
    return _createMatchMakeRequest('joinOrCreate', roomName, options: options);
  }

  Future<List<Room>> getAvailableRooms(String roomName) async {
    final url = '${endpoint.replaceFirst("ws", "http")}/matchmake/$roomName';

    final response =
        await http.get(url, headers: {'Accept': 'application/json'});

    Iterable jsonResult = jsonDecode(response.body);
    return jsonResult.map((e) => Room.fromJson(e)).toList();
  }

  Future<Room> _consumeSeatReservation(dynamic response) async {
    final jsonResponse = jsonDecode(response.body);
    final room = Room.fromJson(jsonResponse['room']);
    room.sessionId = jsonResponse['sessionId'];

    room.connect(_buildEndpoint(room, {'sessionId': room.sessionId}));

    return room;
  }

  Future<Room> _createMatchMakeRequest(String method, String roomName,
      {Map<String, dynamic> options}) async {
    final url =
        '${endpoint.replaceFirst("ws", "http")}/matchmake/$method/$roomName';

    try {
      final response = await http.post(url,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(options ?? {}));

      return _consumeSeatReservation(response);
    } catch (_) {
      throw MatchMakeError('joinOrCreate');
    }
  }

  String _buildEndpoint(Room room, Map<String, dynamic> options) {
    final params = [];

    options.forEach((key, value) {
      params.add('$key=$value');
    });

    return '$endpoint/${room.processId}/${room.roomId}?${params.join('&')}';
  }
}
