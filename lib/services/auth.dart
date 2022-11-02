import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/FirebaseUser.dart';
import '../models/loginuser.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('users');

  String imageUrl = '';

  FirebaseUser? _firebaseUser(User? user) {
    return user != null ? FirebaseUser(uid: user.uid) : null;
  }

  Stream<FirebaseUser?> get user {
    return _auth.authStateChanges().map(_firebaseUser);
  }

  Future signInAnonymous() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;
      return _firebaseUser(user);
    } catch (e) {
      return FirebaseUser(code: e.toString(), uid: null);
    }
  }

  Future signInEmailPassword(LoginUser _login) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _login.email.toString(),
              password: _login.password.toString());
      User? user = userCredential.user;
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    }
  }

  Future singInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final googleSingInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSingInAuthentication.accessToken,
            idToken: googleSingInAuthentication.idToken);

        UserCredential userCredential =
            await _auth.signInWithCredential(authCredential);
        User? user = userCredential.user;
        return _firebaseUser(user);
      }
    } catch (e) {
      return FirebaseUser(code: e.toString(), uid: null);
    }
  }

  Future registerEmailPassword(LoginUser _login, String fullName,
      String mobileNumber, String email, String age) async {
    try {
      //Create user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _login.email.toString(),
              password: _login.password.toString());

      final User? userr = _auth.currentUser;
      final _uid = userr?.uid;
      userr?.updatePhotoURL(imageUrl);
      userr?.reload();

      //Add user details
      //addUserDetails(fullName, mobileNumber, email, age);
      updateUserData(FirebaseAuth.instance.currentUser?.uid, fullName,
          mobileNumber, email, age);

      //Return user
      User? user = userCredential.user;
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    } catch (e) {
      return FirebaseUser(code: e.toString(), uid: null);
    }
  }

  Future signOut() async {
    try {
      FirebaseAuth.instance.signOut();
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future googleSignOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child(_auth.currentUser!.uid);
    Reference referenceImageToUpload = referenceDirImage.child(fileName);
    try {
      //await storage.ref('test/$fileName').putFile(file);
      await referenceImageToUpload.putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> uploadImageFromCamera(String filePath, String fileName) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child(_auth.currentUser!.uid);
    Reference referenceImageToUpload = referenceDirImage.child(fileName);
    try{
      await referenceImageToUpload.putFile(File(filePath));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    }catch(error){
      print(error);
    }
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await storage.ref(_auth.currentUser!.uid).listAll();

    results.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });
    return results;
  }

  Future updateUserData(String? uid, String fullName, String mobileNumber, String email, String age) async{
    collection.where(uid!, isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot){
          if(querySnapshot.docs.isEmpty){
            collection.add({
              'uid': uid,
              'fullName': fullName,
              'mobileNumber': mobileNumber,
              'email': email,
              'age': age,
            }
            );
          }
    })
    .catchError((error){});
  }
}
