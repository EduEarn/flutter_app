import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_earn_admin/src/auth/presentation/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_page/search_page.dart';

import '../../core/applications/domain/entity/job_application.dart';
import '../../core/job/domain/entity/job.dart';
import '../../src/Home/bloc/menu_bloc.dart';
import '../../src/Home/bloc/menu_event.dart';
import '../responsive/responsive.dart';
import 'dart:js' as js;
class Header extends StatefulWidget {
  final String headerTitle;

  const Header({
    super.key,
    required this.headerTitle,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
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
    return Row(children: [
      if (!Responsive.isDesktop(context))
        IconButton(icon: const Icon(Icons.menu), onPressed: () => context.read<MenuBloc>().add(OpenDrawerEvent())),
      if (!Responsive.isMobile(context))
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.headerTitle,
                style: Theme.of(context).textTheme.titleLarge!.apply(fontSizeDelta: 2, fontWeightDelta: 2))),
      if (!Responsive.isMobile(context)) Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
      const Expanded(child: SearchField()),
      GestureDetector(
        onTapDown: (TapDownDetails details) {
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(details.globalPosition.dx, details.globalPosition.dy,
                details.globalPosition.dx, details.globalPosition.dy),
            items: <PopupMenuEntry>[
              const PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    title: Text('Notifications'),
                    leading: Icon(Icons.notifications_on, color: Colors.grey),
                  )),
              const PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    title: Text('Logout'),
                    leading: Icon(Icons.exit_to_app, color: Colors.grey),
                  ))
            ],
          ).then((value) async {
            // Handle menu item selection here
            switch (value) {
              case 1:
                break;
              case 2:
                const CircularProgressIndicator();
                if (FirebaseAuth.instance.currentUser != null) {
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) {
                    return;
                  }
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ));
                }
                break;
              case 3:
                print("3");
                break;
            }
          });
        },
        child: Container(
            margin: const EdgeInsets.only(left: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.white10)),
            child: Row(children: [
              const Icon(Icons.notifications_on, color: Colors.grey),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(Icons.mail, color: Colors.grey),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: logoUrl != null
                    ? Image.network(
                        logoUrl!,
                        width: 40,
                      )
                    : Image.network(
                        'data:image/jpeg;base64,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',
                        width: 40),
              ),
              if (!Responsive.isMobile(context))
                // FutureBuilder(
                //     future: bloc.authenticated(),
                //     builder: (BuildContext context, snapshot) {
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return const Text('');
                //       }
                //       return Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 8),
                //           child: Text(snapshot.requireData.email.split('@')[0]));
                //     }),
                const Icon(Icons.keyboard_arrow_down),
            ])),
      )
    ]);
  }
}

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  List<JobApplication> companyApplications = [];
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    fetchCompanyApplications();
    super.initState();
  }

  Future<String> fetchCompanyName() async {
    if (currentUser != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('companies').doc(currentUser!.uid).get();
        if (doc.exists) {
          final name = doc['name'] as String;
          return name;
        }
      } catch (e) {
        debugPrint("Error getting document: $e");
        return '';
      }
    }
    return '';
  }

  Future<void> fetchCompanyApplications() async {
    String companyName = await fetchCompanyName();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('job_applications')
        .where('job.company', isEqualTo: companyName)
        .get();

    final applications = querySnapshot.docs.map((doc) {
      final data = doc.data();
      final jobData = data['job'] as Map<String, dynamic>;
      final job = JobEntity.fromMap(jobData);

      return JobApplication(
        userId: data['userId'],
        jobId: data['jobId'],
        job: job,
        fullName: data['fullName'],
        email: data['email'],
        phoneNumber: data['phoneNumber'],
        cvUrl: data['cvUrl'],
        createdAt: data['createdAt'].toDate(),
        coverLetter: data['coverLetter'],
      );
    }).toList();
    setState(() {
      companyApplications = applications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextField(
        onTap: () => showSearch(
          context: context,
          delegate: SearchPage(
            items: companyApplications,
            searchLabel: 'Search Applications',
            suggestion: const Center(child: Text("Search application list by name, role, email or Educational level")),
            failure: const Center(child: Text('No User found :(')),
            filter: (applicant) => [
              applicant.fullName,
              applicant.email,
              applicant.job.role,
              applicant.job.level
            ],
            builder: (applicant) => InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTable(application: applicant),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
        decoration: InputDecoration(
          hintText: 'Search',
          fillColor: Colors.white,
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTable extends StatelessWidget {
  final JobApplication application;

  const CustomTable({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            application.fullName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text('Email: ${application.email}'),
          const SizedBox(height: 4.0),
          Text('Role: ${application.job.role}'),
          const SizedBox(height: 4.0),
          Text('Educational Level: ${application.job.level}'),
          const SizedBox(height: 8.0),
          InkWell(
            onTap: () {
              js.context.callMethod('open', [application.cvUrl]);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                'View CV',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
