import 'package:flutter/material.dart';
import 'package:worklytics/core/colors.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  // List to store employee names (you could add more fields as needed)
  List<String> employees = ["All Attendances", "All emoplyees"];

  // Function to add a new employee
  void _addEmployee() {
    setState(() {
      employees.add("New Employee ${employees.length + 1}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashoboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: white,
              shadowColor: Colors.black54,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: Icon(
                        Icons.person,
                        size: 30,
                      ), // Placeholder image URL
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "John Doe",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("Manager"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Employee List Container
            Expanded(
              child: ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    color: white,
                    shadowColor: Colors.black54,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(employees[index]),
                        ),
                        const IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            ))
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button for Adding Employee
      floatingActionButton: FloatingActionButton(
        onPressed: _addEmployee,
        child: Icon(Icons.add_task,color: primaryColor,),
      ),
    );
  }
}
