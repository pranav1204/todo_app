import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/auth/logged_in_widget.dart';
// ignore_for_file: prefer_const_constructors
import 'add_task.dart';
import 'description.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = '';
  bool isDescending = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    getuid();
    super.initState();
  }

  Future getuid() async {
    final  user = FirebaseAuth.instance.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
        actions: [
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () async {
               await Navigator.push(context, MaterialPageRoute(builder: (context)=>LoggedInWidget()));
              }),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              }),
        ],
      ),
      body: Column(
        children: [
          TextButton.icon(
            icon: RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.compare_arrows,size: 28,),
            ),
              label: Text(isDescending ? "Ascending" : "Descending",style: TextStyle(fontSize: 16),),
              onPressed: ()=> setState(() {
                isDescending = !isDescending;
              }),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tasks')
                    .doc(uid)
                    .collection('mytasks')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      reverse: isDescending,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var time = (docs[index]['timestamp'] as Timestamp).toDate();

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Description(
                                          title: docs[index]['title'],
                                          description: docs[index]['description'],
                                        )));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(10)),
                            height: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                    ),
                                    onPressed: ()  {
                                      titleController.text = docs[index]['title'];
                                      descriptionController.text = docs[index]['description'];
                                      showDialog(context: context, builder: (context) => Dialog(
                                        child: Container(
                                            padding: EdgeInsets.all(20),
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: [
                                                TextField(
                                                  controller: titleController,
                                                  decoration: InputDecoration(
                                                      labelText: 'Enter Title', border: OutlineInputBorder()),
                                                ),
                                                SizedBox(height: 10),
                                                TextField(
                                                  controller: descriptionController,
                                                  decoration: InputDecoration(
                                                      labelText: 'Enter Description',
                                                      border: OutlineInputBorder()),
                                                ),
                                                SizedBox(height: 10),
                                                SizedBox(
                                                    width: double.infinity,
                                                    height: 50,
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(backgroundColor:
                                                      MaterialStateProperty.resolveWith<Color>(
                                                              (Set<MaterialState> states) {
                                                            if (states.contains(MaterialState.pressed)) {
                                                              return Colors.purple.shade100;
                                                            }
                                                            return Theme.of(context).primaryColor;
                                                          })),
                                                      child: Text(
                                                        'Save',
                                                        style: GoogleFonts.roboto(fontSize: 18),
                                                      ),
                                                      onPressed: () {
                                                        snapshot.data?.docs[index].reference.update(
                                                            {
                                                              'title': titleController.text,
                                                              'description': descriptionController.text,
                                                              'time': time.toString(),
                                                              'timestamp': time
                                                            }).whenComplete(() => Navigator.pop(context));
                                                      },
                                                    ))
                                              ],
                                            )),
                                      ));
                                    }),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Text(docs[index]['title'],
                                              style:
                                                  GoogleFonts.roboto(fontSize: 20))),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Text(
                                              DateFormat.yMd().add_jm().format(time)))
                                    ]),
                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                    ),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('tasks')
                                          .doc(uid)
                                          .collection('mytasks')
                                          .doc(docs[index]['time'])
                                          .delete();
                                    })
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddTask()));
          },
          child: Icon(Icons.add, color: Colors.white)),
    );
  }
}
