import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_test/bloc/character/character_bloc.dart';
import 'package:graphql_test/bloc/todo/todo_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<CharacterBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<TodoBloc>(),
        ),
      ],
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
    context.read<TodoBloc>().add(FetchTodosEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              context.read<TodoBloc>().add(FetchTodosEvent());
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              context.read<TodoBloc>().add(
                    const AddTodoEvent(text: 'Created todo', userId: '2'),
                  );
            },
            icon: const Icon(Icons.plus_one),
          ),
        ],
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state.status == TodoStatus.todoAdded) {
            ToastUtil.displayToast();
          }
        },
        builder: (context, state) {
          return Center(
            child: ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, i) {
                return ListTile(title: Text(state.todos[i].text));
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
        __typename
        results {
          id
          name
        }
      }
    }
  ''';

  static String todoQuery = '''
    query todoQuery {
      __typename
      todos {
        __typename
        id
        text
        done
      }
    }
  ''';

  static String todoMutation = '''
    mutation(\$text: String!, \$userId: String!) {
      createTodo(input: {
        text: \$text
        userId: \$userId
      }) {
        id
        text
        done
      }
    }
  ''';
}

class ToastUtil {
  static void displayToast([String? message]) {
    // Cancels previous error if there is any
    Fluttertoast.cancel();

    Fluttertoast.showToast(
      msg: 'Todo added',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
