import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  GraphQLClient get gqlClient => GraphQLClient(
        cache: GraphQLCache(
          store: HiveStore(),
        ),
        link: HttpLink('https://rickandmortyapi.com/graphql'),
      );
}
