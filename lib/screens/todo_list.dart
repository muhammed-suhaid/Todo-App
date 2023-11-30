import 'package:flutter/material.dart';
import 'package:todo_api_app/screens/add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Todo List"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAdd,
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }

  void navigateToAdd() {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    Navigator.push(context, route);
  }
}
