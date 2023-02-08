import 'package:firebase_proj_1/database_manager/database_manager.dart';
import 'package:firebase_proj_1/main.dart';
import 'package:firebase_proj_1/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthenticationService _auth = AuthenticationService();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _productController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  List userProfileList = [];
  String userID = "";

  @override
  void initState() {
    fetchUserInfo();
    fetchDatabaseList();
    super.initState();
  }

  fetchDatabaseList() async {
    dynamic resultant = await DatabaseManager().getUsersList();
    if (resultant != null) {
      setState(() {
        userProfileList = resultant;
      });
    }
  }

  fetchUserInfo() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    userID = getUser!.uid;
  }

  updateData(String name, String product, int amount, String userID) async {
    await DatabaseManager().updateUserList(name, product, amount, userID);
    fetchDatabaseList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(color: Colors.deepPurple, child: Text('♉')),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            onPressed: () {
              openDialogBox(context);
            },
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
          ),
          ElevatedButton(
            onPressed: () async {
              await _auth.signOut().then((result) => Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(
                      builder: ((context) => const LoginScreen()))));
            },
            child: Icon(Icons.exit_to_app),
            style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
          )
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: userProfileList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(userProfileList[index]['name']),
                subtitle: Text('Product: ${userProfileList[index]['product']}'),
                leading: CircleAvatar(
                  child: Image(
                    image: AssetImage('assets/images/img2.png'),
                  ),
                ),
                trailing: Text('Cost ₹: ${userProfileList[index]["amount"]}'),
              ),
            );
          },
        ),
      ),
    );
  }

  openDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit User Details'),
          content: Container(
            height: 200,
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _productController,
                  decoration: const InputDecoration(hintText: 'Product'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(hintText: 'Amount'),
                )
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                  onPressed: () {
                    submitAction(context);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Submit'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  submitAction(BuildContext context) {
    updateData(_nameController.text, _productController.text,
        int.parse(_amountController.text), userID);
    _nameController.clear();
    _amountController.clear();
    _productController.clear();
  }
}
