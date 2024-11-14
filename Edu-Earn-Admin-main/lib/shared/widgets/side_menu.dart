import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
    required this.onButtonPressed,
  });

  final Function(int) onButtonPressed;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String? logoUrl;

  @override
  void initState() {
    super.initState();
    fetchCompanyLogo();
  }

  Future<void> fetchCompanyLogo() async {
    if (currentUser != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('companies').doc(currentUser!.uid).get();
        if (doc.exists) {
          setState(() {
            logoUrl = doc['logo'];
          });
        }
      } catch (e) {
        debugPrint("Error getting document: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: ListView(
        children: [
          DrawerHeader(
            child: CircleAvatar(
              backgroundImage: logoUrl != null
                  ? NetworkImage(logoUrl!)
                  : const NetworkImage(
                      'data:image/jpeg;base64,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'),
            ),
          ),
          DrawerListTile(
            title: '  Dashboard',
            icon: Icons.apps,
            press: () {
              widget.onButtonPressed(0);
            },
          ),
          DrawerListTile(
            title: '  Applications',
            icon: Icons.person_add,
            press: () {
              widget.onButtonPressed(1);
            },
          ),
          DrawerListTile(
            title: '  Job Posts',
            icon: Icons.post_add,
            press: () {
              widget.onButtonPressed(2);
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.press,
  });

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
