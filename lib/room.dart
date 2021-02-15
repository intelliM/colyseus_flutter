import 'connection.dart';

class Room {
  String sessionId;
  Connection connection;

  int clients;
  String createdAt;
  int maxClients;
  String name;
  String processId;
  String roomId;

  Room(
      {this.clients,
      this.createdAt,
      this.maxClients,
      this.name,
      this.processId,
      this.roomId});

  Room.fromJson(dynamic json) {
    clients = json["clients"];
    createdAt = json["createdAt"];
    maxClients = json["maxClients"];
    name = json["name"];
    processId = json["processId"];
    roomId = json["roomId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["clients"] = clients;
    map["createdAt"] = createdAt;
    map["maxClients"] = maxClients;
    map["name"] = name;
    map["processId"] = processId;
    map["roomId"] = roomId;
    return map;
  }

  @override
  String toString() {
    return 'Room{clients: $clients, createdAt: $createdAt, maxClients: $maxClients, name: $name, processId: $processId, roomId: $roomId}';
  }

  void connect(String endpoint) {
    connection = Connection(endpoint);
    connection.stream.listen((event) {
      print('connect =========');
      print(event);
    });
  }
}
