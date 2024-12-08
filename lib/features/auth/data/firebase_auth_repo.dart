import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media/features/auth/domain/entities/app_user.dart';
import 'package:social_media/features/auth/domain/repository/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  @override
  Future<AppUser> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      AppUser appUser = AppUser(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName!);
      return appUser;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<AppUser> getCurrentUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      AppUser appUser =
          AppUser(uid: user.uid, email: user.email!, name: user.displayName!);
      return appUser;
    } else {
      throw Exception("User not found");
    }
  }

  @override
  Future<void> logout() async {
    return await FirebaseAuth.instance.signOut();
  }

  @override
  Future<AppUser> registerWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      AppUser appUser = AppUser(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName!);
      return appUser;
    } catch (e) {
      throw Exception(e);
    }
  }
}
