// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:graphql_flutter/graphql_flutter.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;

import '../bloc/character/character_bloc.dart' as _i7;
import '../bloc/todo/todo_bloc.dart' as _i6;
import '../data/character_datasource.dart' as _i4;
import '../data/todo_datasource.dart' as _i5;
import 'register_module.dart' as _i8; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.lazySingleton<_i3.GraphQLClient>(() => registerModule.gqlClient);
  gh.lazySingleton<_i4.ICharacterDatasource>(
      () => _i4.CharacterDatasource(get<_i3.GraphQLClient>()));
  gh.lazySingleton<_i5.ITodoDatasource>(
      () => _i5.CharacterDatasource(get<_i3.GraphQLClient>()));
  gh.factory<_i6.TodoBloc>(() => _i6.TodoBloc(get<_i5.ITodoDatasource>()));
  gh.factory<_i7.CharacterBloc>(
      () => _i7.CharacterBloc(get<_i4.ICharacterDatasource>()));
  return get;
}

class _$RegisterModule extends _i8.RegisterModule {}
