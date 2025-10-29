// lib/src/domain/entities/pokemon_entity.dart
import 'package:equatable/equatable.dart';

class PokemonEntity extends Equatable {
  final int id;
  final String name;
  final String defaultArtwork;
  final String shinyArtwork;

  const PokemonEntity({
    required this.id,
    required this.name,
    required this.defaultArtwork,
    required this.shinyArtwork,
  });

  @override
  List<Object?> get props => [id, name, defaultArtwork, shinyArtwork];
}
