import 'package:flutter/material.dart';
import 'package:my_notes_app/DB_Modal/db_helper.dart';

import 'DB_Modal/db_handler.dart';

class NoteScreen extends StatefulWidget {

  late Future<List<NotesModal>> notesList;
   NoteScreen({super.key, required this.notesList});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  TextEditingController titleController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  DBHelper? dbHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Note"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                  helperText: "TITLE",
                  helperStyle:const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                  hintText: "Enter the Title",
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20))),
            ),
            const SizedBox(height: 15,),
            TextFormField(

                controller: ageController,
                decoration: InputDecoration(
                  helperText: "AGE",
                  helperStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
              hintText: "Enter the Age",
              border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(20)),
            )),
            const SizedBox(height: 15,),
            TextFormField(
              controller: descriptionController,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Description",
                hintText: "Description",
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),

              ),
            ),
            const SizedBox(height: 15,),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                helperText: "Email",
                helperStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
                hintText: "Email",
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20)
                  ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            dbHelper!.insert(NotesModal(title: titleController.text, age: int.parse(ageController.text), description: descriptionController.text, email: emailController.text)).then((value){
              print("added Successfully");
              setState(() {
                widget.notesList = dbHelper!.getNotesList();
                Navigator.pop(context);
              });

            }).onError((error, stackTrace){
              print(error.toString());
            });
          },
        child:const Icon(Icons.add),
      ),
    );
  }
}
