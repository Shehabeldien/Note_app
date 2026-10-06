import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, ReadContext;
import 'package:get/get.dart';
import 'package:note_app/hive.helper.dart';

import 'cubit/cubit/note_cubit.dart';

class NotePageState extends StatelessWidget {
  NotePageState({super.key});
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NoteCubit>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FC),

        surfaceTintColor: Colors.transparent,

        title: const Row(
          children: [
            Icon(Icons.note_alt_outlined, color: Color(0xFF263238), size: 28),

            SizedBox(width: 10),

            Text(
              'My Notes',
              style: TextStyle(
                color: Color(0xFF263238),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),

            child: TextButton(
              onPressed: () {
                if (HiveHelper.myNotes.isNotEmpty) {
                  cubit.deleteAllNotes();
                }
              },

              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFFFEBEE),
                foregroundColor: const Color(0xFFE53935),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              child: const Text(
                'Clear All',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                      cubit.addNote(_controller.text);
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

      body: BlocBuilder<NoteCubit, NoteState>(
        builder: (context, state) {
          if (state is Noteloadingstate) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NoteEmptyState) {
            return Center(child: Text('No notes available.'));
          } else {
            return ListView.builder(
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
                                  cubit.updateNote(index, _controller.text);
                                  Get.back();
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
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      height: 200,
                      decoration: BoxDecoration(
                        color: [
                          const Color(0xFFE8F5E9), // Light Green
                          const Color(0xFFE3F2FD), // Light Blue
                          const Color(0xFFFFF3E0), // Light Orange
                          const Color(0xFFF3E5F5), // Light Purple
                        ][index % 4],

                        borderRadius: BorderRadius.circular(20),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),

                      child: Stack(
                        children: [
                          // Note Content
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                HiveHelper.myNotes[index],
                                style: const TextStyle(
                                  color: Color(0xFF263238),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),

                          // Delete Button
                          Positioned(
                            top: 15,
                            right: 15,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(206),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  cubit.deleteNote(index);
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Color(0xFFE53935),
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
