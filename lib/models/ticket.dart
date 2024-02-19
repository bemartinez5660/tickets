import 'dart:convert';

// Model of ticket entity 
class Ticket {
  final int? id;
  final String clientName;
  final String address;
  final DateTime date;
  final String phoneNumber;

  Ticket( {
     this.id,
    required this.clientName,
    required this.address,
    required this.date,
    required this.phoneNumber,
  });

  factory Ticket.fromRawJson(String str) => Ticket.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        id: json["id"],
        clientName: json["clientName"],
        address: json["address"],
        phoneNumber: json["phoneNumber"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "clientName": clientName,
        "address": address,
        "phoneNumber": phoneNumber,
        "date": date.toString(),
      };
}
