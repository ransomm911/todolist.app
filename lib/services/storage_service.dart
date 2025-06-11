import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User tidak ditemukan');

      // Buat referensi ke file di Firebase Storage
      final storageRef = _storage.ref().child('profile_images/$userId.jpg');

      // Upload file
      await storageRef.putFile(imageFile);

      // Dapatkan URL download
      final downloadUrl = await storageRef.getDownloadURL();

      // Update photoURL di user profile
      await _auth.currentUser?.updatePhotoURL(downloadUrl);

      return downloadUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      rethrow;
    }
  }

  Future<void> deleteProfileImage() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User tidak ditemukan');

      // Hapus file dari Firebase Storage
      final storageRef = _storage.ref().child('profile_images/$userId.jpg');
      await storageRef.delete();

      // Hapus photoURL dari user profile
      await _auth.currentUser?.updatePhotoURL(null);
    } catch (e) {
      print('Error deleting profile image: $e');
      rethrow;
    }
  }
} 