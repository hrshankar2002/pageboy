import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  CollectionReference profileList =
      FirebaseFirestore.instance.collection('profileInfo');

  Future<void> createUserData(
      String name, String product, int amount, String uid) async {
    await profileList
        .doc(uid)
        .set({'name': name, 'amount': amount, 'product': product});
  }

  Future getUsersList() async {
    List itemsList = [];
    try {
      await profileList
          .get()
          .then((QuerySnapshot) => QuerySnapshot.docs.forEach((element) {
                itemsList.add(element.data());
              }));
      return itemsList;
    } catch (e) {
      //return null;
    }
  }

  Future updateUserList(
      String name, String product, int amount, String uid) async {
    return await profileList
        .doc(uid)
        .update({'name': name, 'amount': amount, 'product': product});
  }
}
