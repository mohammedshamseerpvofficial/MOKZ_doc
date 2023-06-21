import 'dart:convert';
import 'dart:io';

import 'package:action_slider/action_slider.dart';
import 'package:bouncing_button/bouncing_button.dart';
import 'package:document_manager/pages/doumentEdite/document_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/document/document_model.dart';

class DetailsScreen extends StatefulWidget {
  final Document document;

  var CuretntDocument;

  var index;

  DetailsScreen(
      {required this.document,
      required this.CuretntDocument,
      required this.index});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
          child: Container(
            height: 70,
            width: double.infinity,
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
                                        widget.document.documentType,
                                        widget.document.file),
                                    fit: BoxFit.cover),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 119, 118, 118)
                                        .withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                color: Color.fromARGB(255, 254, 254, 254)),
                            height: 50,
                            width: 50,
                          ),
                          Expanded(
                              child: ListTile(
                            title: Container(
                                // color: Colors.green,
                                height: 20,
                                child:
                                    Text(path.basename(widget.document.file))),
                          )),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        BouncingButton(
                          scaleFactor: .1,
                          onPressed: () {
                            OpenFile.open(
                                widget.document.file.toString().trim());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(9)),
                            height: 40,
                            width: 60,
                            child: Center(
                              child: Text(
                                'OPEN',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        BouncingButton(
                          scaleFactor: .1,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Document_edite(
                                    UpdateTitel: widget.document.title,
                                    UpdateDescriptione:
                                        widget.document.description,
                                    UpdateFile: widget.document.file,
                                    expiryDate: widget.document.expiryDate,
                                    Thumbnaile: widget.document.thumbnail,
                                    CuretntDocument: widget.CuretntDocument,
                                    index: widget.index),
                              ),
                            ).then((value) {
                              if (value != null) {
                                setState(() {
                                  Navigator.pop(context, 'data');
                                });
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(9)),
                            height: 40,
                            width: 40,
                            child: Center(
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(13.0),
          child: Container(
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    show_text(
                      Titel1: 'Title',
                      documentTitel: widget.document.title,
                      documentTitelColor: Color.fromARGB(255, 118, 118, 118),
                    ),
                    show_text(
                      Titel1: 'Description',
                      documentTitel: widget.document.description,
                      documentTitelColor: Color.fromARGB(255, 118, 118, 118),
                    ),
                    show_text(
                      Titel1: 'Expiry Date',
                      documentTitel:
                          '${DateFormat('dd/MM/yyyy').format(widget.document.expiryDate!) ?? "N/A"}',
                      documentTitelColor: Colors.red,
                    ),

                    show_text(
                      Titel1: 'Size',
                      documentTitel: getFileSize(widget.document.file),
                      documentTitelColor: Color.fromARGB(255, 118, 118, 118),
                    ),
                    show_text(
                      Titel1: 'Document Type',
                      documentTitel:
                          '${widget.document.documentType!.replaceAll('.', '').toString() ?? "N/A"}',
                      documentTitelColor: Colors.grey,
                    ),

                    show_text(
                      Titel1: 'Location',
                      documentTitel: '${widget.document.file}',
                      documentTitelColor: Colors.blue,
                    ),

                    Divider(
                      color: Color.fromARGB(0, 214, 213, 213),
                    ),
                    // Container(
                    //   height: 100,
                    //   width: 200,
                    //   // color: Colors.green,
                    //   child: Center(
                    //     child: Row(
                    //       children: [
                    //         Text(
                    //           'TO',
                    //           style: TextStyle(
                    //               color: Colors.black,
                    //               fontSize: 50,
                    //               fontWeight: FontWeight.bold),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.only(top: 25,left: 5),
                    //           child: Column(
                    //             children: [
                    //               Stack(
                    //                 children: [
                    //                   Text(
                    //                     'DO',
                    //                     style: TextStyle(
                    //                         color: Colors.black,
                    //                         fontSize: 25,
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.only(top: 22),
                    //                     child: Text(
                    //                       'Day',
                    //                       style: TextStyle(
                    //                           color: Colors.black,
                    //                           fontSize: 20,
                    //                           fontWeight: FontWeight.bold),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               )
                    //             ],
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // )

                    // ElevatedButton(
                    //     onPressed: () {
                    //       widget.CuretntDocument[widget.index] = Document(
                    //           title: 'Game',
                    //           description: 'dfdfd',
                    //           file: widget.document.file,
                    //           thumbnail:
                    //               widget.document.thumbnail.toString().trim(),
                    //           documentType: widget.document.documentType,
                    //           expiryDate: widget.document.expiryDate);
                    //       setState(() {});
                    //     },
                    //     child: Text('data')),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     BouncingButton(
                    //       scaleFactor: .1,
                    //       onPressed: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => Document_edite(
                    //                 UpdateTitel: widget.document.title,
                    //                 UpdateDescriptione:
                    //                     widget.document.description,
                    //                 UpdateFile: widget.document.file,
                    //                 expiryDate: widget.document.expiryDate,
                    //                 Thumbnaile: widget.document.thumbnail,
                    //                 CuretntDocument: widget.CuretntDocument,
                    //                 index: widget.index),
                    //           ),
                    //         ).then((value) {
                    //           if (value != null) {
                    //             setState(() {
                    //               Navigator.pop(context, 'data');
                    //             });
                    //           }
                    //         });
                    //       },
                    //       child: Container(
                    //         height: 40,
                    //         width: 80,
                    //         decoration: BoxDecoration(
                    //             color: Colors.black,
                    //             borderRadius: BorderRadius.circular(12)),
                    //         child: Center(
                    //           child: Text(
                    //             'Edite',
                    //             style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 17),
                    //           ),
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // )
                  ],
                ),
              ),
            ),
          ),
        ),
        Center(
          child: ActionSlider.standard(
            child: const Text(
              'Slide to delete',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            toggleColor: Colors.black,
            actionThresholdType: ThresholdType.release,
            loadingIcon: CircularProgressIndicator(
              color: Colors.white,
            ),
            successIcon: Icon(
              Icons.done,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.navigate_next_rounded,
              color: Colors.white,
            ),
            action: (controller) async {
              controller.loading(); //starts loading animation
              await Future.delayed(const Duration(seconds: 1)).whenComplete(() {
                File file = File(widget.document.file);

                file.delete();
              });

// Obtain shared preferences.
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              widget.CuretntDocument.removeAt(widget.index);
              String documentsJson = jsonEncode(widget.CuretntDocument);
              await prefs.setString('Documents', documentsJson);

              setState(() {});
              controller.success(); //starts success animation
              Navigator.pop(context);
            },
          ),
        ),
      ],
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

  getFileSize(file) {
    file = File(file);
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
}

class show_text extends StatelessWidget {
  var Titel1;

  var documentTitel;

  Color? documentTitelColor;

  show_text({
    super.key,
    required this.documentTitel,
    required this.Titel1,
    required this.documentTitelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '${Titel1}',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        children: <TextSpan>[
          TextSpan(
            text: ': ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '${documentTitel}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: documentTitelColor),
          ),
        ],
      ),
    );
  }
}
