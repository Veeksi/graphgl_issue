import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  GraphQLClient get gqlClient => GraphQLClient(
        cache: GraphQLCache(
          store: HiveStore(),
        ),
        // Put your local ip - you can find it by opening cmd and typing "ipconfig"
        // And checking adapter ethernet adapter field
        link: HttpLink('http://192.168.1.35:8080/query'),
      );
}
// https://rickandmortyapi.com/graphql
