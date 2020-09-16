import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Stream<String> get onAuthStateChanged;
  Future<String> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<String> createUserWithEmailAndPassword(
    String email,
    String password,
  );

  Future<String> currentUser();
  Future<void> signOut();
  Future<String> signInWithGoogle();
  Future<String> signInWithFacebook();
  Future<String> verifyPhoneNumber(PhoneNo);
  bool getIfCodeSent();
  bool setCodeSentFalse();
  Future<String> signInWithOTP(smsCode, PhoneNo);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );

  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user
        .uid;
  }

  @override
  Future<String> currentUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user
        .uid;
  }

  @override
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _auth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: _auth.accessToken,
      idToken: _auth.idToken,
    );
    return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
  }

  @override
  Future<void> signOut() {
    codeSent = false;
    setCodeSentFalse();
    return _firebaseAuth.signOut();
  }

  @override
  String verificationId, smsCode;
  bool codeSent = false;

  @override
  bool getIfCodeSent() {
    return codeSent;
  }

  @override
  bool setCodeSentFalse() {
    codeSent = false;
  }

  @override
  Future<String> verifyPhoneNumber(PhoneNo) async {
    final PhoneVerificationCompleted verified =
        (AuthCredential authResult) async {
      return (await _firebaseAuth.signInWithCredential(authResult)).user.uid;
    };
    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      codeSent = true;
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId;
    };

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: PhoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  @override
  Future<String> signInWithOTP(smsCode, PhoneNo) async {
    final PhoneVerificationCompleted verified =
        (AuthCredential authResult) async {
      return (await _firebaseAuth.signInWithCredential(authResult)).user.uid;
    };
    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      codeSent = true;
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId;
    };

    AuthCredential authcreds = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    return (await _firebaseAuth.signInWithCredential(authcreds)).user.uid;
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
