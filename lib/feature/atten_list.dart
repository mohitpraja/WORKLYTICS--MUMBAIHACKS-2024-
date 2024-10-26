import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:worklytics/core/constant.dart';
import 'package:worklytics/core/globals.dart';

class AttenList extends StatefulWidget {
  const AttenList({super.key});

  @override
  AttenListState createState() => AttenListState();
}

class AttenListState extends State<AttenList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: MyConstant().addEmp.where('ownerId',isEqualTo: phone).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No employees found."));
            }

            // Map each document snapshot to a map for easier access
            final employees = snapshot.data!.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();

            // Check if employees list is not empty
            if (employees.isEmpty) {
              return const Center(child: Text("No employees found."));
            }

            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return ListTile(
                  trailing: Checkbox(
                    value: employee['isWorking'] == 'no' ? false : true,
                    onChanged: (bool? value) {
                      // handle checkbox change here if needed
                    },
                  ),
                  leading: CircleAvatar(
                    child: Text(
                      (employee['nameLogin'] != null && employee['nameLogin'].isNotEmpty)
                          ? employee['nameLogin']![0]
                          : "N/A",
                    ),
                  ),

                  title: Text(employee['nameLogin'] ?? "No Name"),
                  subtitle: Text(employee['geofenceSts'] ?? "Not fetched",style: TextStyle(
                    color: employee['geofenceSts'].isNotEmpty && employee['geofenceSts'].contains('Inside') ? Colors.green: Colors.red
                  ),),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

