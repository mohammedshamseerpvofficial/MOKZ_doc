import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:another_flushbar/flushbar.dart';
import 'package:bouncing_button/bouncing_button.dart';
import 'package:document_manager/theme/colros.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/document/document_model.dart';
import 'package:path/path.dart' as path;

class Document_edite extends StatefulWidget {
  var UpdateTitel;

  var UpdateDescriptione;

  var UpdateFile;

  var expiryDate;

  var Thumbnaile;

  var CuretntDocument;

  var index;

  Document_edite(
      {required this.index,
      required this.CuretntDocument,
      required this.UpdateTitel,
      required this.UpdateDescriptione,
      required this.UpdateFile,
      required this.expiryDate,
      required this.Thumbnaile});

  @override
  _Document_editeState createState() => _Document_editeState();
}

class _Document_editeState extends State<Document_edite> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? filePath;
  DateTime? expiryDate;
  String? documentType;
  String? thumbnail;
  var fileSize;

  @override
  void initState() {
    // TODO: implement initState
    titleController = TextEditingController(text: widget.UpdateTitel);
    descriptionController =
        TextEditingController(text: widget.UpdateDescriptione);
    expiryDate = widget.expiryDate;
    filePath = widget.UpdateFile;
    thumbnail = widget.Thumbnaile;
    documentType = path.extension(widget.UpdateFile);
    fileSize = getFileSize(File(widget.UpdateFile));
    super.initState();
  }

  void selectFile() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc'],
      );

      if (result != null) {
        PlatformFile file = result.files.single;

        String fileName = path.basename(file.path!);
        Directory targetDirectory = Directory('/storage/emulated/0/Mokz Docs');

        if (!(await targetDirectory.exists())) {
          targetDirectory.createSync(recursive: true);
        }

        String filePaths =
            '${targetDirectory.path}/${Random().nextInt(100)} $fileName';
        final uploadFIle = File(file.path.toString().trim());

        File newFile = File(filePaths);
        newFile.writeAsBytesSync(await uploadFIle.readAsBytesSync());
        fileSize = getFileSize(newFile);

        if (newFile.existsSync()) {
          print('File saved successfully');

          print(newFile);
        } else {
          print('Failed to save the file');
        }

        setState(() {
          filePath = newFile.path;
          documentType = path.extension(newFile.path);
          thumbnail = newFile.path;
        });
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Edite Document'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Create_text_input_widget(
              titleController: titleController,
              Hint: 'Enter Titel',
              Titel: 'Title',
            ),

            SizedBox(
              height: 15,
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 7, bottom: 6),
                  child: Text(
                    'Expiry Date',
                    style: GoogleFonts.getFont(
                      'Noto Sans',
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ),
                ),
                Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 144, 142, 142).withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(expiryDate == null
                              ? 'Select expiry date'
                              : '${DateFormat('dd/MM/yyyy').format(expiryDate!)}'),
                          BouncingButton(
                            scaleFactor: .1,
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: Colors.black, // <-- SEE HERE
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          primary:
                                              Colors.black, // button text color
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              setState(() {
                                expiryDate = pickedDate;
                              });
                            },
                            child: Icon(Icons.calendar_month_rounded),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 7, bottom: 6),
                  child: Text(
                    'Document',
                    style: GoogleFonts.getFont(
                      'Noto Sans',
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ),
                ),
                if (filePath == null) ...{
                  Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 144, 142, 142)
                              .withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Upload documnt'),
                            BouncingButton(
                              scaleFactor: .1,
                              onPressed: selectFile,
                              child: Container(
                                height: 40,
                                width: 85,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Select File',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                } else ...{
                  Container(
                    height: 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 144, 142, 142)
                              .withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: documentThumbnailes(
                                                documentType, filePath),
                                            fit: BoxFit.cover),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                    255, 119, 118, 118)
                                                .withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                        color:
                                            Color.fromARGB(255, 254, 254, 254)),
                                    height: 50,
                                    width: 50,
                                  ),
                                  Expanded(
                                      child: ListTile(
                                    title: Container(
                                        // color: Colors.green,
                                        height: 25,
                                        child: Text(path.basename(filePath!))),
                                    subtitle: Text(
                                      '${fileSize}',
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        filePath = null;
                                      });
                                    },
                                    icon: Icon(Icons.close))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                }
              ],
            ),

            SizedBox(
              height: 15,
            ),

            Create_text_input_widget(
              titleController: descriptionController,
              Hint: 'Enter Description',
              Titel: 'Descriptione',
              height: 100,
            ),
            // ElevatedButton(
            //   child: Text('Select File'),
            //   onPressed: selectFile,
            // ),

            // ElevatedButton(
            //   child: Text('Save'),
            //   onPressed: () {
            //     if (titleController.text.isNotEmpty &&
            //         descriptionController.text.isNotEmpty &&
            //         filePath != null) {
            //       Document newDocument = Document(
            //         title: titleController.text,
            //         description: descriptionController.text,
            //         file: filePath!,
            //         expiryDate: expiryDate,
            //         documentType: documentType,
            //         thumbnail: thumbnail,
            //       );

            //       Navigator.pop(context, newDocument);
            //     }
            //   },
            // ),

            BouncingButton(
              scaleFactor: .1,
              onPressed: () async {
                if (titleController.text.isEmpty) {
                  notificationErro('Error', 'Title is Empty');
                } else if (descriptionController.text.isEmpty) {
                  notificationErro('Error', 'Descriptione is Empty');
                } else if (filePath == null) {
                  notificationErro('Error', 'plese select document');
                } else {
                  // notificationsucss('successfully', 'Created new document');
                }
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    filePath != null) {
                  // Document newDocument = Document(
                  //   title: titleController.text,
                  //   description: descriptionController.text,
                  //   file: filePath!,
                  //   expiryDate: expiryDate,
                  //   documentType: documentType,
                  //   thumbnail: thumbnail,
                  // );

                  widget.CuretntDocument[widget.index] = Document(
                      title: titleController.text,
                      description: descriptionController.text,
                      file: filePath!,
                      thumbnail: thumbnail,
                      documentType: documentType,
                      expiryDate: expiryDate);
                            final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
         
 String documentsJson = jsonEncode(widget.CuretntDocument);
              await prefs.setString('Documents', documentsJson);

                  Navigator.pop(context, 'Update');
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: 50),
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  documentThumbnailes(type, image) {
    if (type.toString() == '.png' ||
        type.toString() == '.jpeg' ||
        type.toString() == '.jpg') {
      return FileImage(
        File(
          image.toString().trim(),
        ),
      );
    } else if (type.toString() == '.pdf') {
      return AssetImage('assets/icons/pdficon.png');
    } else if (type.toString() == '.xlsx') {
      return AssetImage('assets/icons/mexcel1.png');
    }
  }

  String getFileSize(File file) {
    int bytes = file.lengthSync();
    double kb = bytes / 1024;
    double mb = kb / 1024;
    double gb = mb / 1024;

    if (gb >= 1) {
      return '${gb.toStringAsFixed(2)} GB';
    } else if (mb >= 1) {
      return '${mb.toStringAsFixed(2)} MB';
    } else if (kb >= 1) {
      return '${kb.toStringAsFixed(2)} KB';
    } else {
      return '$bytes bytes';
    }
  }

  notificationErro(titel, message) {
    Flushbar(
      boxShadows: [
        BoxShadow(
          offset: Offset(2, 2),
          blurRadius: 12,
          color: Color.fromRGBO(0, 0, 0, 0.16),
        )
      ],
      backgroundColor: Colors.white,
      margin: EdgeInsets.all(8),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(8),
      title: '${titel}',
      message: '${message}',
      titleColor: Colors.black,
      messageColor: Colors.black,
      icon: Container(
        padding: EdgeInsets.only(
          left: 8,
        ),
        child: Center(
          child: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.red,
          ),
        ),
      ),
      duration: Duration(seconds: 3),
      // leftBarIndicatorColor: Colors.blue[300],
    )..show(context);
  }

  notificationsucss(titel, message) {
    Flushbar(
      boxShadows: [
        BoxShadow(
          offset: Offset(2, 2),
          blurRadius: 12,
          color: Color.fromRGBO(0, 0, 0, 0.16),
        )
      ],
      backgroundColor: Colors.white,
      margin: EdgeInsets.all(8),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(8),
      title: '${titel}',
      message: '${message}',
      titleColor: Colors.black,
      messageColor: Colors.black,
      icon: Container(
        padding: EdgeInsets.all(12),
        child: Center(
          child: Icon(
            Icons.check_circle_outline_rounded,
            size: 28.0,
            color: Colors.green,
          ),
        ),
      ),
      duration: Duration(seconds: 3),
      // leftBarIndicatorColor: Colors.blue[300],
    )..show(context);
  }
}

class Create_text_input_widget extends StatelessWidget {
  var Titel;

  var Hint;

  double? height;

  Create_text_input_widget({
    super.key,
    required this.titleController,
    required this.Titel,
    required this.Hint,
    this.height,
  });

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 7),
          child: Text(
            '${Titel}',
            style: GoogleFonts.getFont(
              'Noto Sans',
              textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Container(
          height: height != null ? height : 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 144, 142, 142).withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: titleController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
            ],
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15, top: 5),
                hintText: '${Hint}',
                hintStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                    fontSize: 12)),
          ),
        ),
      ],
    );
  }
}
