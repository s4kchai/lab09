import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<void> signUpWithEmail(
      String email, String password, String name, String tel) async {
    try {
      // Create New User Account to Firebase Authen
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      print(uid);

      // Store User infomation (name, tel) to FireStore
      FirebaseFirestore.instance.collection("Users").doc(uid).set({
        "name": name,
        "tel": tel,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  
  }

  Future<void> addNewInfo(String name, String tel) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser!.uid;

    // Store User infomation (name, tel) to FireStore
    FirebaseFirestore.instance.collection("Users").doc(uid).set({
      "name": name,
      "tel": tel,
    });
  }

