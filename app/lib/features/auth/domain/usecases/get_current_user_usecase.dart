import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoon/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;
  GetCurrentUserUseCase({required AuthRepository repository})
    : _repository = repository;

  Future<User?> call() async {
    return Future.delayed(Durations.short3, () => _repository.currentUser);
  }
}
