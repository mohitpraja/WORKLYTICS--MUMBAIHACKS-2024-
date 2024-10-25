import 'package:flutter/material.dart';
import 'package:worklytics/core/constant.dart';
import 'package:worklytics/core/globals.dart';

class AddEmployeePage extends StatefulWidget {
  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController designationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: designationController,
              decoration: InputDecoration(
                labelText: 'Designation',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Add employee data handling logic here
                  String name = nameController.text;
                  String addPhone = phoneController.text;
                  String designation = designationController.text;

                  // For now, just printing the data
                  print('Name: $name');
                  print('Phone: $addPhone');
                  print('Designation: $designation');

                  // Clear the fields after saving
                  nameController.clear();
                  phoneController.clear();
                  designationController.clear();
                  setState(() {

                  });

                await  MyConstant().addEmp.add({
                    "nameLogin": name,
                    "designation": designation,
                    "phone": addPhone,
                    "ownerId": phone,
                    "owner": 'no',
                    "isWorking": 'no',
                  });


                  // Show a confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Employee added successfully')),
                  );
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
