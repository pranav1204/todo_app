import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore_for_file: prefer_const_constructors

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime dateTime = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addtasktofirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String uid = user!.uid;
    var time = dateTime;
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': time.toString(),
      'timestamp': time
    });
  }

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if(date == null) return;

    TimeOfDay? time = await pickTime();
    if(time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      this.dateTime = dateTime;
    });
  }

  Future pickDate() => showDatePicker(context: context,
      initialDate: dateTime,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100));

  Future pickTime() => showTimePicker(context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute)
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Task')),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
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
              ElevatedButton(
                  onPressed: pickDateTime,
                  child: Text('$dateTime')
              ),
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
                      'Add Task',
                      style: GoogleFonts.roboto(fontSize: 18),
                    ),
                    onPressed: () {
                      addtasktofirebase();
                      Navigator.pop(context);
                    },
                  ))
            ],
          )),
    );
  }
}
