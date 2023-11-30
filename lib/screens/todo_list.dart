import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_api_app/screens/add_page.dart';
import 'package:http/http.dart' as http;
import 'package:todo_api_app/services/todo_services.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Todo List"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddPage,
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
              child: Text("No Todo item"),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(onSelected: (value) {
                      if (value == 'edit') {
                        navigateToEditPage(item);
                      } else if (value == 'delete') {
                        deleteById(id);
                      }
                    }, itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: "edit",
                          child: Text("Edit"),
                        ),
                        const PopupMenuItem(
                          value: "delete",
                          child: Text("Delete"),
                        ),
                      ];
                    }),
                  ),
                );
              },
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoServices.deleteById(id);
    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMessage('Deletion failed');
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoServices.fetchTodos();

    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage("Something went wrong");
    }
    setState(() {
      isLoading = false;
    });
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
