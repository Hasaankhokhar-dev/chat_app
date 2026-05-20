import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    'dpzp0acnu',
    'flutter_upload',
     cache: false,
  );
  Future<String> uploadImage(File image) async {
     try{
       CloudinaryResponse res = await _cloudinary.uploadFile(
         CloudinaryFile.fromFile(image.path, folder: 'chat_app_profiles'),
       );
       return res.secureUrl;
     }catch(e){
      throw Exception('Failed to upload image: $e');
     }
  }

}