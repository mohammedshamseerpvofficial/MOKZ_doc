import 'dart:convert';
import 'dart:io';

import 'package:document_manager/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(DocumentManagerApp());
}

class DocumentManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Manager',
            debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true
    
      ),
      home: Home_page(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Document> documents = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Manager'),
      ),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: documents[index].thumbnail != null
                ? Image.file(File(documents[index].thumbnail.toString()))
                : Icon(Icons.insert_drive_file),
            title: Text(documents[index].title),
            subtitle: Text(documents[index].documentType.toString()),
            trailing: documents[index].expiryDate != null
                ? Text('Expiry: ${documents[index].expiryDate}')
                : null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(document: documents[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddScreen(),
            ),
          ).then((newDocument) {
            if (newDocument != null) {
              setState(() {
                documents.add(newDocument);
                  addTodocument();
              });
            }
          });
        },
      ),
    );
  }

  addTodocument()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

  }
}

class Document {
  String title;
  String description;
  String file;
  DateTime?expiryDate;
  String? documentType;
  String? thumbnail;

  Document({
    required this.title,
    required this.description,
    required this.file,
    this.expiryDate,
    this.documentType,
    this.thumbnail,
  });
}

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? filePath;
  DateTime? expiryDate;
  String? documentType;
  String? thumbnail;

  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        filePath = result.files.single.path!;
        documentType = result.files.single.extension;
        thumbnail = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Document'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              child: Text('Select File'),
              onPressed: selectFile,
            ),
            if (filePath != null)
              Text('Selected File: ${filePath!}'),
            TextFormField(
              decoration: InputDecoration(labelText: 'Expiry Date (optional)'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                setState(() {
                  expiryDate = pickedDate;
                });
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    filePath != null) {
                  Document newDocument = Document(
                    title: titleController.text,
                    description: descriptionController.text,
                    file: filePath!,
                    expiryDate: expiryDate,
                    documentType: documentType,
                    thumbnail: thumbnail,
                  );

                  Navigator.pop(context, newDocument);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  final Document document;

  DetailsScreen({required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${document.title}'),
                SizedBox(height: 8.0),
                Text('Description: ${document.description}'),
                SizedBox(height: 8.0),
                Text('Expiry Date: ${document.expiryDate ?? "N/A"}'),
                SizedBox(height: 8.0),
                Text('Document Type: ${document.documentType ?? "N/A"}'),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                child: Text('View Document'),
                onPressed: () {
OpenFile.open(document.file.toString().trim());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
