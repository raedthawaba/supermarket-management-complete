import 'package:flutter/material.dart';
import '../models/models.dart';
import 'storage_service.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    await StorageService.init();
    final savedUser = StorageService.getCurrentUser();
    if (savedUser != null) {
      _currentUser = User.fromJson(savedUser);
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final users = StorageService.getUsers();
      
      // Check if it's admin login
      if (username == 'admin' && password == 'admin123') {
        _currentUser = User(
          id: '1',
          username: 'admin',
          email: 'admin@supermarket.com',
          role: UserRole.admin,
          fullName: 'مدير النظام',
          phone: '',
          createdAt: DateTime.now(),
        );
        await StorageService.saveCurrentUser(_currentUser!.toJson());
        _isLoading = false;
        notifyListeners();
        return true;
      }

      // Check regular users
      for (final userData in users) {
        final user = User.fromJson(userData);
        if (user.username == username && user.password == password) {
          _currentUser = user;
          await StorageService.saveCurrentUser(user.toJson());
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await StorageService.clearCurrentUser();
    _currentUser = null;
    notifyListeners();
  }

  Future<List<User>> getUsers() async {
    final usersData = StorageService.getUsers();
    return usersData.map((userData) => User.fromJson(userData)).toList();
  }

  Future<void> addUser(User user) async {
    final users = await getUsers();
    users.add(user);
    
    final usersJson = users.map((user) => user.toJson()).toList();
    await StorageService.saveUsers(usersJson);
    
    notifyListeners();
  }

  Future<void> updateUser(User updatedUser) async {
    final users = await getUsers();
    final index = users.indexWhere((user) => user.id == updatedUser.id);
    
    if (index != -1) {
      users[index] = updatedUser;
      final usersJson = users.map((user) => user.toJson()).toList();
      await StorageService.saveUsers(usersJson);
      notifyListeners();
    }
  }

  Future<void> deleteUser(String userId) async {
    final users = await getUsers();
    users.removeWhere((user) => user.id == userId);
    
    final usersJson = users.map((user) => user.toJson()).toList();
    await StorageService.saveUsers(usersJson);
    notifyListeners();
  }

  Future<void> createDefaultAdmin() async {
    final users = await getUsers();
    final adminExists = users.any((user) => user.username == 'admin');
    
    if (!adminExists) {
      final adminUser = User(
        id: '1',
        username: 'admin',
        password: 'admin123',
        email: 'admin@supermarket.com',
        role: UserRole.admin,
        fullName: 'مدير النظام',
        phone: '',
        createdAt: DateTime.now(),
      );
      await addUser(adminUser);
    }
  }
}