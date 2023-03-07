import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/FirebaseUser.dart';
import '../models/loginuser.dart';
import '../models/model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('users');
  static Reference refStorage = FirebaseStorage.instance.ref();


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

      /*final User? userr = _auth.currentUser;
      final _uid = userr?.uid;*/
      /*user?.updatePhotoURL(imageUrl);
      user?.reload();*/

      //Add user details
      //addUserDetails(fullName, mobileNumber, email, age);
      updateUserData(fullName, mobileNumber, email, age, 'Patient');

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

  getImage(String imageName){
    refStorage.child(_auth.currentUser!.uid).child(imageName);
  }

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child(_auth.currentUser!.uid);
    Reference referenceImageToUpload = referenceDirImage.child(fileName);
    try {
      //await storage.ref('test/$fileName').putFile(file);
      await referenceImageToUpload.putFile(file);
      imageUrl = await referenceImageToUpload.getDownloadURL();
      final Reference storage =
          FirebaseStorage.instance.ref().child("${_auth.currentUser!.uid}.jpg");
      final UploadTask task = storage.putFile(file);
      task.then((value) async {
        String url = (await storage.getDownloadURL()).toString();
        FirebaseFirestore.instance.collection("history").add({
          'id': _auth.currentUser!.uid,
          'email': _auth.currentUser!.email,
          'image': url,
          'diagnosis': 'Tumor',
          'time': DateTime.now(),
        });
      });
      print('task $task');
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

  Future<void> listPhotos() async {
    firebase_storage.ListResult result = await storage.ref(_auth.currentUser!.uid).listAll();

    for (firebase_storage.Reference ref in result.items) {
      String url = await firebase_storage.FirebaseStorage.instance
          .ref(ref.fullPath)
          .getDownloadURL();
      print(url);
    }
  }

  Future<String> downloadURL(String imageName) async {
    String downloadURL = (await storage
        .ref(_auth.currentUser!.uid + '/$imageName')
        .getDownloadURL()) as String;
    return downloadURL;
  }

  Future updateUserData(String fullName, String mobileNumber,
      String email, String age, String role) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    userModel.email = email;
    userModel.uid = user!.uid;
    userModel.role = role;
    userModel.name = fullName;
    userModel.number = mobileNumber;
    userModel.age = age;
    userModel.isAssigned = 'NA';

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
  }
}
