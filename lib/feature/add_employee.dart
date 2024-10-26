import 'package:flutter/material.dart';
import 'package:worklytics/core/constant.dart';
import 'package:worklytics/core/globals.dart';

class AddEmployeePage extends StatefulWidget {
  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController designationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: designationController,
              decoration: const InputDecoration(
                labelText: 'Designation',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Add employee data handling logic here
                  String name = nameController.text;
                  String addPhone = phoneController.text;
                  String designation = designationController.text;
                  String email = emailController.text;

                  // For now, just printing the data
                  print('Name: $name');
                  print('Phone: $addPhone');
                  print('Designation: $designation');
                  print('email: $email');

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
                    "password": 'abcd1234',
                    "ownerId": phone,
                    "owner": 'no',
                    "isWorking": 'no',
                    "geofenceSts": 'within',
                  });
                  await MyConstant().SignUpAlfa.add({
                    "nameLogin": name,
                    "email": emailController.text.toLowerCase(),
                    "phone": addPhone,
                    "password": 'abcd1234',
                    "ownerId": phone,
                    "owner": 'no',
                  });


                  // Show a confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Employee added successfully')),
                  );
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
