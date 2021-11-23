import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_test/bloc/character_bloc.dart';
import 'package:graphql_test/injection/injection.dart';
import 'package:injectable/injectable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  await configureInjection(Environment.prod);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CharacterBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'GraphQL demo'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    context.read<CharacterBloc>().add(FetchCharactersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          return Center(
            child: ListView.builder(
              itemCount: state.characters.length,
              itemBuilder: (context, i) {
                return ListTile(title: Text(state.characters[i].name));
              },
            ),
          );
        },
      ),
    );
  }
}

mixin GqlQuery {
  static String charactersQuery = '''
    query (\$page: Int!){
      characters(page: \$page){
        results {
          name
        }
      }
    }
  ''';
}
