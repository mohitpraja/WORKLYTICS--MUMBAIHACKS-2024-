import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worklytics/core/globals.dart';
import 'package:worklytics/feature/add_employee.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  // List to store employee names (you could add more fields as needed)
  List<String> employees = ["John Doe", "Jane Smith", "Emily Johnson"];



  // Function to add a new employee
  void _addEmployee() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  AddEmployeePage()),
    );

    /*  setState(() {
      employees.add("New Employee ${employees.length + 1}");
    });
  */}
  @override
  void initState() {
    // TODO: implement initState
    initPlatformState();
    super.initState();
  }
  void initPlatformState() async {
    print(DateTime.now().timeZoneName);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String a = prefs.getString('email') ?? '';
    String? b = prefs.getString('nameLogin');
    phone = prefs.getInt('phone');
    password = prefs.getString('password');
    phone = prefs.getInt('phone');
    setState(() {
      userEmail = a;
      nameLogin = b;
    });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worklytics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/human.png'),

                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameLogin.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("Admin"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Employee List Container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(employees[index][0]),
                      ),
                      title: Text(employees[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button for Adding Employee
      floatingActionButton: FloatingActionButton(
        onPressed: _addEmployee,
        child: Icon(Icons.add),
        tooltip: "Add Employee",
      ),
    );
  }
}
