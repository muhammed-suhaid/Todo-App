import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleContoller = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 95),
          child: Text("Add Todo"),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleContoller,
            decoration: const InputDecoration(
              hintText: "Title",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: "Description",
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: submitData,
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }

  Future<void> submitData() async {
    //Get data from the form
    final title = titleContoller.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    //Submit data to the server
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    //Show success or fail message based on status
    if (response.statusCode == 201) {
      titleContoller.text = '';
      descriptionController.text = '';
      showSuccessMessage('Creation Success');
    } else {
      showErrorMessage('Creation Failed');
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
