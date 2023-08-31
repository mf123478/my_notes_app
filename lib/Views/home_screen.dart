import 'package:flutter/material.dart';
import 'package:my_notes_app/DB_Modal/db_handler.dart';
import 'package:my_notes_app/DB_Modal/db_helper.dart';
import 'package:my_notes_app/new_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;

  late Future<List<NotesModal>> notesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() {
    notesList = dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text("Take Notes"), InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NoteScreen(
                      notesList: notesList,
                    )),
              );
              },
            child: Icon(Icons.add))],
      )),
      body: FutureBuilder(
        future: notesList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        dbHelper!.update(NotesModal(
                            id: snapshot.data![index].id,
                            title: "Note 2",
                            age: 25,
                            description: "My Second Note",
                            email: "123556"));
                        notesList = dbHelper!.getNotesList();
                      });
                    },
                    child: Dismissible(
                      key: ValueKey<int>(snapshot.data![index].id!),
                      background: Container(
                        color: Colors.red,
                        child: const Icon(Icons.delete_forever),
                      ),
                      onDismissed: (DismissDirection direction) {
                        setState(() {
                          dbHelper!.delete(snapshot.data![index].id!);
                          notesList = dbHelper!.getNotesList();
                          snapshot.data!.remove(snapshot.data![index]);
                        });
                      },
                      child: Card(
                        child: ListTile(
                          leading: Text(snapshot.data![index].title.toString()),
                          subtitle: Text(
                              snapshot.data![index].description.toString()),
                          trailing: Text(snapshot.data![index].age.toString()),
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return const Center(child: Text("Add New Note"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            notesList = dbHelper!.getNotesList();

          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
