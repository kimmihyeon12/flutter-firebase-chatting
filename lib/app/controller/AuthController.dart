import 'package:chatting_app/app/data/model/user_model.dart';
import 'package:chatting_app/app/routers/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  var isSkipIntro = true.obs; // intro 보여줄시 false
  var isAuth = false.obs;
  // ignore: prefer_final_fields, unused_field
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var user = UsersModel().obs;

  Future firstInitialized() async {
    print("로딩중...");
    await skipIntro().then((value) => {
          if (value) {isSkipIntro(true)}
        });
    await autoLogin().then((value) => {
          if (value) {isAuth(true)}
        });
  }

  Future skipIntro() async {
    final box = GetStorage();
    //이미 인트로 본 경우
    if (box.read('skipIntro') == true) {
      return true;
    }
    return false;
  }

  Future autoLogin() async {
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      //로그인 되어있을 경우에만 실행!!!!
      if (isSignIn) {
        final currentUser = await googleFirebaseSign(true);
        print("currentUser");
        print(currentUser);
        CollectionReference users = firestore.collection('users');
        await users.doc(currentUser!.user.email).update({
          "lastSignInTime":
              currentUser!.user!.metadata.lastSignInTime!.toIso8601String(),
        });
        // user 정보 얻어오기 ()
        getUser(users, currentUser!.user.email);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future login() async {
    final currentUser = await googleFirebaseSign(false);
    print("currentUser");
    print(currentUser);
    //로그인시 skip
    final box = GetStorage();
    box.write('skipIntro', true);
    CollectionReference users = firestore.collection('users');

    final checkuser = await users.doc(currentUser!.user.email).get();

    //이메일 storage에 존재하지 않으면
    if (checkuser.data() == null) {
      await users.doc(currentUser!.user.email).set({
        "uid": currentUser!.user!.uid,
        "name": currentUser!.name,
        "keyName": currentUser!.family_name.toUpperCase(),
        "email": currentUser!.email,
        "photoUrl": currentUser!.picture ?? "noimage",
        "status": "",
        "creationTime":
            currentUser!.user!.metadata.creationTime!.toIso8601String(),
        "lastSignInTime":
            currentUser!.user!.metadata.lastSignInTime!.toIso8601String(),
        "updatedTime": DateTime.now().toIso8601String(),
      });
    }
    //이메일 storage에 존재하면 (로그인후 로그아웃한 경우)
    else {
      await users.doc(currentUser!.user.email).update({
        "lastSignInTime":
            currentUser!.user!.metadata.lastSignInTime!.toIso8601String(),
      });
    }
    // user 정보 얻어오기 ()
    getUser(users, currentUser!.user.email);
    Get.offAllNamed(Routes.Nav);
  }

  Future getUser(users, email) async {
    final currUser = await users.doc(email).get();
    final currUserData = currUser.data() as Map<String, dynamic>;
    user(UsersModel.fromJson(currUserData));
    user.refresh();
    isAuth(true);
  }

  Future googleFirebaseSign(auto) async {
    if (!auto) {
      await _googleSignIn.signOut();
    }

    // signInSilently 창 안띄우고 login // signIn 창띄우고 로그인
    final currentUser = auto
        ? await _googleSignIn.signInSilently()
        : await _googleSignIn.signIn();
    final googleAuth = await currentUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    //firebase login
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return userCredential;
  }
}
