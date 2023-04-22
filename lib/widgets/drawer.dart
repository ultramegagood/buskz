import 'dart:io';
import 'package:buskz/screens/route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class MyDrawer extends StatefulWidget {
  final String name;
  final String email;
  final String? avatarUrl;
  final Function(File)? onAvatarChanged;

  const MyDrawer({
    Key? key,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.onAvatarChanged,
  }) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late File _imageFile;
  final User _user = FirebaseAuth.instance.currentUser!;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

    if (_imageFile != null) {
      await _uploadImageToFirebase();
    }
  }

  Future<void> _uploadImageToFirebase() async {
    final Reference storageRef =
        FirebaseStorage.instance.ref().child('users/${_user.uid}/avatar.jpg');

    final UploadTask uploadTask = storageRef.putFile(_imageFile);
    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = (await downloadUrl.ref.getDownloadURL());

    await _user.updatePhotoURL(url);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: _user.photoURL != null
                      ? CachedNetworkImageProvider(_user.photoURL!)
                      : null,
                  radius: 35,
                  child: _user.photoURL == null
                      ? IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () => _pickImage(ImageSource.camera),
                        )
                      : null,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.email,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Шығу'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Page1()));
            },
          ),
        ],
      ),
    );
  }
}
