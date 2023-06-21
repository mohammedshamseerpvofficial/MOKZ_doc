import 'dart:convert';
import 'dart:io';
import 'package:action_slider/action_slider.dart';
import 'package:document_manager/pages/createPage/create_document.dart';
import 'package:document_manager/theme/colros.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/document/document_model.dart';
import '../doumentDetails/document_details.dart';
import 'package:bouncing_button/bouncing_button.dart';
import 'package:intl/intl.dart';

class Home_page extends StatefulWidget {
  const Home_page({super.key});

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  List<Document> documents = [];
  @override
  void initState() {
    // TODO: implement initState
    getLocalStorageData();
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // appBar: AppBar(
      //   title: Text('Document Manager'),
      // ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MOKZ DOC',
                    style: GoogleFonts.getFont(
                      'Poppins',
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1587397845856-e6cf49176c70?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80'),
                    backgroundColor: Color.fromARGB(255, 239, 237, 237),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 15),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 237, 234, 234).withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: TextField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(CupertinoIcons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15, top: 9),
                          hintText: 'Search file...',
                          hintStyle: TextStyle(
                              color:
                                  Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                              fontSize: 12)),
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12, top: 12, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rcent Files',
                    style: GoogleFonts.getFont(
                      'Noto Sans',
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ),
                  Icon(Icons.more_horiz)
                ],
              ),
            ),
            documents.length == 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/icons/empty-box.png',
                            height: 230,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Please add documents',
                            style: GoogleFonts.getFont(
                              'Noto Sans',
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Flexible(
                    child: ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        print(documents);
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 18, right: 15, top: 8, bottom: 8),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 204, 203, 203)
                                      .withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.only(
                              left: 12,
                            ),
                            child: Stack(
                              children: [
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Icon(Icons.more_horiz),
                                    )),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: documentThumbnailes(index),
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
                                          color: Color.fromARGB(
                                              255, 254, 254, 254)),
                                      height: 70,
                                      width: 70,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 14),
                                        child: ListTile(
                                          // leading: documents[index].thumbnail != null
                                          //     ? Image.file(
                                          //         File(documents[index].thumbnail.toString()))
                                          //     : Icon(Icons.insert_drive_file),
                                          title: Text(documents[index].title),
                                          // trailing: Icon(
                                          //   Icons.more_horiz,
                                          //   color: Colors.black,
                                          // ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              documents[index].expiryDate !=
                                                      null
                                                  ? Text(
                                                      '${DateFormat('dd/MM/yyyy').format(documents[index].expiryDate!)}',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              168,
                                                              244,
                                                              67,
                                                              54)),
                                                    )
                                                  : SizedBox(),
                                              Text(
                                                documents[index]
                                                    .documentType
                                                    .toString()
                                                    .replaceAll('.', ''),
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(.3)),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         DetailsScreen(
                                            //             document:
                                            //                 documents[index]),
                                            //   ),
                                            // );

                                            showModalBottomSheet<void>(
                                              backgroundColor: backgroundColor,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: SizedBox(
                                                    height: 480,
                                                    child: Center(
                                                      child: Stack(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                height: 5,
                                                                width: 100,
                                                                decoration: BoxDecoration(
                                                                    color: Color(
                                                                        0xFF121212),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12)),
                                                              )
                                                            ],
                                                          ),
                                                          DetailsScreen(
                                                            document: documents[
                                                                index],
                                                            CuretntDocument:
                                                                documents,
                                                            index: index,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).then((value) {
                                              setState(() {});
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.note_add_outlined),
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => Create_document(),
      //       ),
      //     ).then((newDocument) {
      //       if (newDocument != null) {
      //         setState(() {
      //           documents.add(newDocument);
      //           // addTodocument();
      //         });
      //       }
      //     });
      //   },
      // ),

      floatingActionButton: BouncingButton(
        scaleFactor: 0.1,
        onPressed: () {
          HapticFeedback.heavyImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Create_document(),
            ),
          ).then((newDocument) {
            if (newDocument != null) {
              setState(() {
                documents.add(newDocument);
                addtoLocalStorage();
                // getLocalStorageData();
              });
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 55,
          width: 55,
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  documentThumbnailes(index) {
    if (documents[index].documentType.toString() == '.png' ||
        documents[index].documentType.toString() == '.jpeg' ||
        documents[index].documentType.toString() == '.jpg') {
      return FileImage(
        File(
          documents[index].thumbnail.toString(),
        ),
      );
    } else if (documents[index].documentType.toString() == '.pdf') {
      return AssetImage('assets/icons/pdficon.png');
    } else if (documents[index].documentType.toString() == '.xlsx') {
      return AssetImage('assets/icons/mexcel1.png');
    }
  }

  addtoLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Extract the necessary data from the documents list
    // List<String> documentData = documents.map((document) => document.toString()).toList();

    // Save the document data to shared preferences
  String documentsJson = jsonEncode(documents);
  await prefs.setString('Documents', documentsJson);


    // var dd=await prefs.setString('Documents', dds);
    // print(dd);

    getLocalStorageData();
    setState(() {
      
    });
  } 

  getLocalStorageData() async {
    print('start');
    //   SharedPreferences prefs = await SharedPreferences.getInstance();

    //  var dd = await prefs.getString(
    //     'Documets',
    //   );

    //     List<Document> jsonList = dd;
    //     print(jsonList);

    //   print(dd);

    SharedPreferences prefs = await SharedPreferences.getInstance();

 
  // Retrieve the string value from SharedPreferences
  String? documentsString = prefs.getString('Documents');
    print('start1');
  if (documentsString != null) {
        print('start2');
    // Parse the JSON-encoded string back to List<dynamic>
    List<dynamic> jsonList = jsonDecode(documentsString.toString().trim());
    print('start3');
    // Convert each element to Document and populate the List<Document>
 documents = jsonList.map((json) => Document.fromJson(json)).toList();
     print('start4');
 print(documents);

 setState(() {
   
 });

    // return documents;
  }
  }
}
