import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter_clone/controller/userdata_controller.dart';
import 'package:instagram_flutter_clone/resources/firestore_method.dart';
import 'package:instagram_flutter_clone/resources/storage_method.dart';
import 'package:instagram_flutter_clone/utils/colors.dart';
import 'package:instagram_flutter_clone/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final userController = Get.put(UserController());
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isloading = false;
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text('Create a Post'),
              children: [
                SimpleDialogOption(
                  padding: EdgeInsets.all(20),
                  child: Text('Take a photo'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  },
                ),
                SimpleDialogOption(
                  padding: EdgeInsets.all(20),
                  child: Text('Choose from gallery'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  },
                ),
                SimpleDialogOption(
                  padding: EdgeInsets.all(20),
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void PostImage(String uid, String username, String profileImage) async {
    setState(() {
      _isloading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profileImage);

      if (res == 'success') {
        setState(() {
          _isloading = false;
        });
        Get.snackbar('YAY', 'You have successfully posted the post');
        clearImage();
      } else {
        setState(() {
          _isloading = false;
        });
        Get.snackbar('SORRY', res);
      }
    } catch (err) {
      Get.snackbar('SORRY', err.toString());
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _file == null
        ? Center(
            child: IconButton(
                onPressed: () {
                  _selectImage(context);
                },
                icon: Icon(Icons.upload)),
          )
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => clearImage(),
                ),
                title: Text('Post to'),
                centerTitle: false,
                actions: [
                  TextButton(
                      onPressed: () {
                        PostImage(
                            userController.userData.value!.uid,
                            userController.userData.value!.username,
                            userController.userData.value!.photoURL);
                      },
                      child: Text(
                        'Post',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              body: Column(
                children: [
                  _isloading
                      ? LinearProgressIndicator()
                      : Padding(padding: EdgeInsets.only(top: 0)),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            userController.userData.value!.photoURL),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            hintText: 'Write an caption ....',
                            border: InputBorder.none,
                          ),
                          maxLines: 8,
                        ),
                      ),
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.fill,
                                    alignment: FractionalOffset.topCenter)),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
