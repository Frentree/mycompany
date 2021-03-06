import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfileEditFunction {
  Future<PickedFile?> selectImage({
    required ImageSource imageSource,
  }) async {
    ImagePicker imagePicker = ImagePicker();

    PickedFile? pickImage = await imagePicker.getImage(source: imageSource);

    return pickImage;
  }

  Future<String?> uploadImageToStorage({
    required BuildContext context,
    required String pickImagePath, pickImage,
  }) async {

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false,);
    UserModel loginUserData = userInfoProvider.getUserData()!;

    Reference profileReference = firebaseStorage.ref("profile/${loginUserData.mail}");
    
    UploadTask uploadTask = profileReference.putFile(File(pickImagePath));

    String imageUrl = await (await uploadTask).ref.getDownloadURL();

    return imageUrl;
  }

  Future<String?> uploadCompanyImageToStorage({
    required BuildContext context,
    required String pickImagePath, pickImage,
  }) async {

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false,);
    UserModel loginUserData = userInfoProvider.getUserData()!;

    Reference profileReference = firebaseStorage.ref().child("company/${loginUserData.companyCode}");

    UploadTask uploadTask = profileReference.putFile(File(pickImagePath));

    String imageUrl = await (await uploadTask).ref.getDownloadURL();

    return imageUrl;
  }
}

void aaa(){

}