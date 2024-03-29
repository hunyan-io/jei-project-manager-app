import 'package:flutter/material.dart';
import 'package:jei_project_manager_app/models/task.dart';
import 'package:jei_project_manager_app/services/task_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jei_project_manager_app/widgets/input_theme_provider.dart';
import 'package:jei_project_manager_app/widgets/rounded_button.dart';
import 'package:jei_project_manager_app/widgets/text_field_widget.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final descriptionController = TextEditingController();
  final deadlineController = TextEditingController();

  String? value;

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: TextFieldWidget(item, 15),
      );
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return InputThemeProvider(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              Row(
                children: [
                  const SizedBox(width: 10.0),
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    "Ajouter une tâche",
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  children: [
                    TextFieldWidget("Nom : ", 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => nameController.clear(),
                            icon: const Icon(
                              Icons.close,
                              color: Color(0xFF171a33),
                              size: 20,
                            ),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    TextFieldWidget("Description : ", 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: TextFormField(
                        maxLines: 3,
                        controller: descriptionController,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    TextFieldWidget("Date limite : ", 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF171a33),
                              width: 1,
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${selectedDate.toLocal()}".split(' ')[0],
                              style: const TextStyle(
                                color: Color(0xFF171a33),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _selectDate(context),
                              icon: const Icon(Icons.calendar_today),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedButton(
                  text: "Ajouter",
                  onPressed: () {
                    if (nameController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Veuillez entrer le nom de la tâche",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFF8a2831),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else if (descriptionController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Veuillez ajouter une description pour la tâche",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFF8a2831),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else if (selectedDate.isAtSameMomentAs(DateTime.now())) {
                      Fluttertoast.showToast(
                          msg: "Veuillez ajouter une date limite",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFF8a2831),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      Task data = Task(
                        name: nameController.text,
                        project: arguments["project"],
                        description: descriptionController.text,
                        deadline: selectedDate,
                        status: arguments["status"],
                      );
                      TaskServices.postTask(data).then((_) {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
