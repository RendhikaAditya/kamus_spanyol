// To parse this JSON data, do
//
//     final modelKosakata = modelKosakataFromJson(jsonString);

import 'dart:convert';

ModelKosakata modelKosakataFromJson(String str) => ModelKosakata.fromJson(json.decode(str));

String modelKosakataToJson(ModelKosakata data) => json.encode(data.toJson());

class ModelKosakata {
  bool sukses;
  int status;
  String pesan;
  List<Datum> data;

  ModelKosakata({
    required this.sukses,
    required this.status,
    required this.pesan,
    required this.data,
  });

  factory ModelKosakata.fromJson(Map<String, dynamic> json) => ModelKosakata(
    sukses: json["sukses"],
    status: json["status"],
    pesan: json["pesan"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sukses": sukses,
    "status": status,
    "pesan": pesan,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String kosakata;
  String arti;

  Datum({
    required this.id,
    required this.kosakata,
    required this.arti,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    kosakata: json["kosakata"],
    arti: json["arti"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "kosakata": kosakata,
    "arti": arti,
  };
}
