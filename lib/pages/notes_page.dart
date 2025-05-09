import 'package:auth_firebase/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController textController = TextEditingController();

  //open a dialog box
  void openNoteBox({String? docID, String? existingText}) {
    textController.text = existingText ?? '';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(docID == null ? 'Add Note' : 'Update Note'),
            content: Form(
              // key: _formKey,
              child: TextFormField(
                controller: textController,
                autofocus: true,
                decoration: InputDecoration(hintText: 'Enter your note here'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {
                  final text = textController.text.trim();
                  Navigator.pop(context);

                  // Decide whether to add or update
                  if (docID == null) {
                    firestoreService.addNote(text);
                  } else {
                    firestoreService.updateNote(docID, text);
                  }
                  // Reset the form
                  textController.clear();
                  // }
                },
                child: Text(docID == null ? 'Add' : 'Update'),
              ),
            ],
          ),
    ).then((_) {
      // Reset if user taps outside dialog
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes")),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed:
                            () => openNoteBox(
                              docID: docID,
                              existingText: noteText,
                            ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => firestoreService.deleteNote(docID),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text("no notes...");
          }
        },
      ),
    );
  }
}
