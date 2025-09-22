import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PokemonModel {
  final int id;
  final String name;
  String defaultArtwork;
  String shinyArtwork;
  PokemonModel({
    required this.id,
    required this.name,
    this.defaultArtwork = '',
    this.shinyArtwork = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'defaultArtwork': defaultArtwork,
      'shinyArtwork': shinyArtwork,
    };
  }

  factory PokemonModel.fromMap(Map<String, dynamic> map) {
    return PokemonModel(
      id:
          map['id'] ??
          int.tryParse(
            (map['url']).replaceAll('/', '').split('pokemon-species')[1],
          ) ??
          0,
      name: map['name'] ?? '',
      defaultArtwork: map['defaultArtwork'] ?? '',
      shinyArtwork: map['shinyArtwork'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PokemonModel.fromJson(String source) =>
      PokemonModel.fromMap(json.decode(source) as Map<String, dynamic>);

  PokemonModel copyWith({
    int? id,
    String? name,
    String? defaultArtwork,
    String? shinyArtwork,
  }) {
    return PokemonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      defaultArtwork: defaultArtwork ?? this.defaultArtwork,
      shinyArtwork: shinyArtwork ?? this.shinyArtwork,
    );
  }
}
