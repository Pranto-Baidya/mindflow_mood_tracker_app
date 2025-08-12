
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier{

  final _auth = FirebaseAuth.instance;

  String? _errorMsg = '';
  String? get errorMsg => _errorMsg;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> signIn(String email, String password)async{
    try{
      _isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return true;
    }
    on FirebaseAuthException catch(e){
      _errorMsg = e.message;
      return false;
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password, String name)async{
    try{
      _isLoading = true;
      notifyListeners();

      UserCredential? userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

      return true;
    }
    on FirebaseAuthException catch(e){
      _errorMsg = e.message;
      return false;
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut()async{
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));
    await _auth.signOut();
    await GoogleSignIn().signOut();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> resetPassword(String email)async{
   try{
     _isLoading = true;
     notifyListeners();

     await _auth.sendPasswordResetEmail(email: email);
     return true;
   }
   on FirebaseAuthException catch(e){
     _errorMsg = e.message;
     return false;
   }
   finally{
     _isLoading = false;
     notifyListeners();
   }
  }

  Future<UserCredential?> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception("Sign in aborted by user");
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      _errorMsg = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> reauthenticateAndChangePassword({ required String email, required String currentPassword, required String newPassword})async{

    try{
      _isLoading = true;
      notifyListeners();

      final credential = EmailAuthProvider.credential(email: email, password: currentPassword);

      await _auth.currentUser?.reauthenticateWithCredential(credential);

      await _auth.currentUser?.updatePassword(newPassword);

      return true;
    }

    on FirebaseAuthException catch(e){
      _errorMsg = e.message;
      return false;
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }

  }

  Future<bool> reauthenticateAndDeleteAccount({String? email, String? password}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) return false;

      final isGoogleUser = user.providerData.any((info) => info.providerId == 'google.com');

      if (isGoogleUser) {
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) throw Exception("Google sign-in aborted");

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await user.reauthenticateWithCredential(credential);
      } else {
        if (email == null || password == null) throw Exception("Missing credentials");
        final credential = EmailAuthProvider.credential(email: email, password: password);
        await user.reauthenticateWithCredential(credential);
      }

      await user.delete();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMsg = e.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}