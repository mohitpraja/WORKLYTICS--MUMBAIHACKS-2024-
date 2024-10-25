import 'package:cloud_firestore/cloud_firestore.dart';


class MyConstant{

CollectionReference SignUpAlfa = FirebaseFirestore.instance.collection('SignUpTimeInOut');
CollectionReference addEmp = FirebaseFirestore.instance.collection('addEmp');

}
