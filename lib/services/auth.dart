import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Register
  Future<Object?> registerCompany(String email, String pass) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: pass)).user!;
      if(user!=null){
        return user.uid;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}