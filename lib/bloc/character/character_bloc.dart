import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_test/data/character_datasource.dart';
import 'package:graphql_test/domain/character.dart';
import 'package:injectable/injectable.dart';

part 'character_event.dart';
part 'character_state.dart';

@injectable
class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  CharacterBloc(this._dataSource) : super(const CharacterState()) {
    on<CharacterEvent>(_onFetchCharacters);
  }

  Future<void> _onFetchCharacters(
    CharacterEvent event,
    Emitter<CharacterState> emit,
  ) async {
    final result = await _dataSource.getCharacters();
    return emit(
      state.copyWith(
        characters: result,
      ),
    );
  }

  final ICharacterDatasource _dataSource;
}
