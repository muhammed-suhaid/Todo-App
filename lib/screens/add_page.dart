import 'package:flutter/material.dart';
import 'package:todo_api_app/services/todo_services.dart';
import 'package:todo_api_app/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleContoller = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleContoller.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 95),
          child: Text(isEdit ? "Edit Todo" : "Add Todo"),
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
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(isEdit ? "Update" : "Submit"),
            ),
          )
        ],
      ),
    );
  }

  Future<void> submitData() async {
    //Submit data to the server
    final isSuccess = await TodoServices.createTodo(body);

    //Show success or fail message based on status
    if (isSuccess) {
      titleContoller.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: 'Creation Success');
    } else {
      showErrorMessage(context, message: 'Creation Failed');
    }
  }

  Future<void> updateData() async {
    //Get data from the form
    final todo = widget.todo;
    if (todo == null) {
      return;
    }
    final id = todo['_id'];

    //Submit data to the server

    final isSuccess = await TodoServices.updateTodo(id, body);

    //Show success or fail message based on status
    if (isSuccess) {
      showSuccessMessage(context, message: 'Update Success');
    } else {
      showErrorMessage(context, message: 'Updation Failed');
    }
  }

  //Get data from the form
  Map get body {
    final title = titleContoller.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
