import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/hive.helper.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _controller = TextEditingController();
  bool isloading = false;
  @override
  void didChangeDependencies() async {
    isloading = true;

    await HiveHelper.getNotes();
    isloading = false;
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6200EE),
        title: const Text('Note App'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                HiveHelper.deleteAllNotes();
                setState(() {});
              },
              child: const Text(
                'Clear All',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text(
                'Add Note',
                style: TextStyle(color: Colors.black),
              ),

              content: TextFormField(
                decoration: const InputDecoration(hintText: 'Enter your note'),
                controller: _controller,
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cancel'),
                ),

                TextButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      HiveHelper.addNote(_controller.text);
                      setState(() {});

                      Get.back();

                      _controller.clear();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: isloading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: HiveHelper.myNotes.length,
              itemBuilder: (context, index) => Stack(
                children: [
                  InkWell(
                    onTap: () {
                      _controller.text = HiveHelper.myNotes[index];
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            'Update Note',
                            style: TextStyle(color: Colors.black),
                          ),

                          content: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Update your note',
                            ),
                            controller: _controller,
                          ),

                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Cancel'),
                            ),

                            TextButton(
                              onPressed: () {
                                if (_controller.text.isNotEmpty) {
                                  HiveHelper.updateNote(
                                    index,
                                    _controller.text,
                                  );

                                  setState(() {});

                                  Get.back();

                                  _controller.clear();
                                }
                              },
                              child: const Text('Update'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(20),
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: index == 0
                            ? const Color.fromARGB(255, 52, 201, 52)
                            : index % 2 == 0
                            ? const Color.fromARGB(255, 100, 100, 100)
                            : const Color.fromARGB(255, 255, 0, 0),
                      ),
                      child: Center(
                        child: Text(
                          HiveHelper.myNotes[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      onPressed: () {
                        HiveHelper.deleteNote(index);

                        setState(() {});
                      },
                      icon: const Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
