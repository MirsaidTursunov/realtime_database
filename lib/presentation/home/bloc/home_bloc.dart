import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoginWithEmailEvent>(_emailLogin);
    on<SignUpEvent>(_emailSignUp);
    on<GoogleEvent>(_googleSignUp);
  }


  Future<void> _emailLogin(LoginWithEmailEvent event, Emitter<HomeState> emit) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      // emit(state.copyWith(firebaseStatus: Status.success));
    } on FirebaseAuthException catch (e) {
      print('error----${e.code}');
      // emit(state.copyWith(firebaseStatus: Status.error));
    }
  }

  Future<void> _emailSignUp(SignUpEvent event, Emitter<HomeState> emit) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email, password: event.password);
      // emit(state.copyWith(firebaseStatus: Status.success));
    } on FirebaseAuthException catch (e) {
      print('error----${e.code}');
      // emit(state.copyWith(firebaseStatus: Status.error));
    }
  }

  Future<void> _googleSignUp(GoogleEvent event, Emitter<HomeState> emit) async {
    final _googleSign = GoogleSignIn(
      scopes: [
        'email',
        // 'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    try {
      final GoogleSignInAccount? googleUser = await _googleSign.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      print(userCredential.user);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    } catch (e, s) {
      debugPrint('$e, $s');
    }
  }
}
