import 'package:auth_firebase/services/firestore_service.dart';
import 'package:auth_firebase/services/notification_service.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Color darkGreen = const Color(0xFF537D5D);
  final Color mediumGreen = const Color(0xFF73946B);
  final Color lightGreen = const Color(0xFF9EBC8A);
  final Color beige = const Color(0xFFD2D0A0);

  // Open dialog for add or update note
  void openNoteBox({String? docID, String? existingText}) {
    textController.text = existingText ?? '';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              docID == null ? 'Add Note' : 'Update Note',
              style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
            ),
            content: Form(
              key: _formKey,
              child: TextFormField(
                controller: textController,
                autofocus: true,
                maxLines: 4,
                minLines: 2,
                decoration: InputDecoration(
                  hintText: 'Enter your note here',
                  filled: true,
                  fillColor: beige.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: mediumGreen),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: lightGreen, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(foregroundColor: mediumGreen),
                onPressed: () {
                  Navigator.pop(context);
                  textController.clear();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final text = textController.text.trim();
                    Navigator.pop(context);
                    if (docID == null) {
                      firestoreService.addNote(text);
                      await NotificationService.createNotification(
                        id: 0,
                        title: 'You have been added a new note',
                        body: text,
                      );
                    } else {
                      firestoreService.updateNote(docID, text);
                      await NotificationService.createNotification(
                        id: docID.hashCode,
                        title: 'You have updated a note',
                        body: text,
                      );
                    }
                    textController.clear();
                  }
                },
                child: Text(
                  docID == null ? 'Add' : 'Update',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    ).then((_) {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beige,
      appBar: AppBar(
        title: const Text(
          'NOTES',
          style: TextStyle(color: Colors.white, letterSpacing: 4),
        ),
        backgroundColor: darkGreen,
        centerTitle: true,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 4),
            child: IconButton(
              icon: Icon(Icons.account_circle_rounded, size: 32, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, 'user');
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: lightGreen,
        onPressed: () => openNoteBox(),
        child: Icon(Icons.add, color: darkGreen, size: 32),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading notes',
                style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No notes available. Tap + to add one.",
                style: TextStyle(color: mediumGreen, fontSize: 16),
              ),
            );
          }

          final notesList = snapshot.data!.docs;

          return ListView.separated(
            // sort list ini
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            itemCount: notesList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final document = notesList[index];
              final docID = document.id;
              final data = document.data() as Map<String, dynamic>;
              final noteText = data['note'] ?? '';

              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: darkGreen.withOpacity(0.3),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  title: Text(
                    noteText,
                    style: TextStyle(
                      color: darkGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  trailing: SizedBox(
                    width: 96,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          tooltip: 'Edit',
                          icon: Icon(Icons.edit, color: mediumGreen),
                          onPressed:
                              () => openNoteBox(
                                docID: docID,
                                existingText: noteText,
                              ),
                        ),
                        IconButton(
                          tooltip: 'Delete',
                          icon: Icon(Icons.delete, color: Colors.red[400]),
                          onPressed: () => firestoreService.deleteNote(docID),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
