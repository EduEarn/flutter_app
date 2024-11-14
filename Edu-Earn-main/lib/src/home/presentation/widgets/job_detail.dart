import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_earn/core/job/domain/entity/job.dart';
import 'package:edu_earn/core/user/domain/entity/user.dart';
import 'package:edu_earn/src/applications/domain/entity/job_application.dart';
import 'package:edu_earn/src/bookmark/domain/entity/bookmark.dart';
import 'package:edu_earn/src/applications/presentation/screens/job_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../shared/data/image_assets.dart';
import '../../../../shared/utils/snackbar.dart';
import '../../../bookmark/presentation/bloc/bookmark_bloc.dart';
import 'job_detail_card.dart';

class JobDetailPage extends StatefulWidget {
  const JobDetailPage({
    Key? key,
    required this.job,
    required this.user,
  }) : super(key: key);

  final JobEntity job;
  final UserEntity user;

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  String activeButton = 'Description';
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<bool> isBookmarked(Bookmark bookmark) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('bookmarks')
        .where('userId', isEqualTo: bookmark.userId)
        .where('jobId', isEqualTo: bookmark.jobId)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<bool> isJobApplied(JobApplication jobApplication) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('job_applications')
        .where('userId', isEqualTo: jobApplication.userId)
        .where('jobId', isEqualTo: jobApplication.job.id)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  bool isSaved = false;
  bool isApplied = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isBookmarked(Bookmark(userId: userId, jobId: widget.job.id)).then((value) => setState(() => isSaved = value));
      isJobApplied(JobApplication.initial().copyWith(job: widget.job, userId: userId))
          .then((value) => setState(() => isApplied = value));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late Widget page;
    if (activeButton == 'Description') {
      page = DescriptionPage(widget: widget);
    } else if (activeButton == 'Company') {
      page = CompanyPage(widget: widget);
    } else if (activeButton == 'Reviews') {
      page = ReviewPage(widget: widget);
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          Text(
            widget.user.fullName,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color:
                      Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFFFFE28D),
              foregroundImage: AssetImage(ImageAssets.profile),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                JobDetailCard(job: widget.job),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Button(
                      text: 'Description',
                      color: activeButton == 'Description' ? Theme.of(context).primaryColor : Colors.grey,
                      onTap: () {
                        setState(() => activeButton = 'Description');
                      },
                    ),
                    Button(
                      text: 'Company',
                      color: activeButton == 'Company' ? Theme.of(context).primaryColor : Colors.grey,
                      onTap: () {
                        setState(() => activeButton = 'Company');
                      },
                    ),
                    Button(
                      text: 'Reviews',
                      color: activeButton == 'Reviews' ? Theme.of(context).primaryColor : Colors.grey,
                      onTap: () {
                        setState(() => activeButton = 'Reviews');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                page,
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              isSaved
                  ? {
                      context
                          .read<BookmarkBloc>()
                          .add(DeleteBookmark(bookmark: Bookmark(userId: userId, jobId: widget.job.id))),
                      setState(() => isSaved = !isSaved)
                    }
                  : {
                      context
                          .read<BookmarkBloc>()
                          .add(SaveBookmark(bookmark: Bookmark(userId: userId, jobId: widget.job.id))),
                      setState(() => isSaved = !isSaved)
                    };
            },
            label: Text(
              isSaved ? "Saved" : "Save",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black, fontSize: 16),
            ),
            heroTag: 'btn1',
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: const StadiumBorder(),
            extendedPadding: const EdgeInsets.symmetric(horizontal: 40),
          ),
          const SizedBox(width: 30),
          FloatingActionButton.extended(
            onPressed: () async {
              !isApplied
                  ? Get.to(() => JobApplicationForm(user: widget.user, job: widget.job))
                  : CustomSnackBar.showSnackBar(
                      context: context,
                      title: "Job Applied",
                      message: "You have already applied for this job. Thank you for your interest!",
                      contentType: ContentType.help,
                    );
            },
            label: Text(
              isApplied ? "Applied" : "Apply now",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
            ),
            heroTag: 'btn2',
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            extendedPadding: const EdgeInsets.symmetric(horizontal: 45),
            shape: const StadiumBorder(),
          ),
        ],
      ),
    );
  }
}

class CompanyPage extends StatelessWidget {
  const CompanyPage({
    super.key,
    required this.widget,
  });

  final JobDetailPage widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Icon(Icons.edit_outlined),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "About Company",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(widget.job.aboutCompany)
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(25),
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle_outline),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Missions",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(widget.job.companyMission)
            ],
          ),
        ),
      ],
    );
  }
}

class DescriptionPage extends StatelessWidget {
  const DescriptionPage({
    super.key,
    required this.widget,
  });

  final JobDetailPage widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(25),
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Icon(Icons.edit_outlined),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Job description",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(widget.job.description)
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(25),
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle_outline),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Skills & Requirements",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(widget.job.skillRequired)
            ],
          ),
        ),
      ],
    );
  }
}

class ReviewPage extends StatelessWidget {
  const ReviewPage({
    super.key,
    required this.widget,
  });

  final JobDetailPage widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: 185,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Icon(Icons.edit_outlined),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Company Reviews ",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "4",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                              fontSize: 35,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 5),
                          ...List.generate(5, (index) {
                            if (index == 4) {
                              return const Icon(Icons.star_border, color: Colors.black, size: 20);
                            } else {
                              return const Icon(Icons.star, color: Color(0xffFFC500), size: 20);
                            }
                          }),
                        ],
                      ),
                      Text(
                        "100 Reviews",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '5',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                          ),
                          LinearPercentIndicator(
                            width: 140.0,
                            lineHeight: 7.0,
                            percent: 0.2,
                            backgroundColor: Colors.grey[300],
                            progressColor: const Color(0xffFFC500),
                            barRadius: const Radius.circular(8),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '4',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                          ),
                          LinearPercentIndicator(
                            width: 140.0,
                            lineHeight: 7.0,
                            percent: 0.15,
                            backgroundColor: Colors.grey[300],
                            progressColor: const Color(0xffFFC500),
                            barRadius: const Radius.circular(8),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '3',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                          ),
                          LinearPercentIndicator(
                            width: 140.0,
                            lineHeight: 7.0,
                            percent: 0.6,
                            backgroundColor: Colors.grey[300],
                            progressColor: const Color(0xffFFC500),
                            barRadius: const Radius.circular(8),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '2',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                          ),
                          LinearPercentIndicator(
                            width: 140.0,
                            lineHeight: 7.0,
                            percent: 0.35,
                            backgroundColor: Colors.grey[300],
                            progressColor: const Color(0xffFFC500),
                            barRadius: const Radius.circular(8),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '1',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                          ),
                          LinearPercentIndicator(
                            width: 140.0,
                            lineHeight: 7.0,
                            percent: 0.1,
                            backgroundColor: Colors.grey[300],
                            progressColor: const Color(0xffFFC500),
                            barRadius: const Radius.circular(8),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Employees & Testimonials",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      radius: 25,
                      foregroundImage: AssetImage(ImageAssets.profile),
                    ),
                    title: Text(
                      "Nathan",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    subtitle: const Text(
                      "August 28,2022",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      ...List.generate(5, (index) {
                        if (index == 4) {
                          // Last star not filled with color
                          return const Icon(Icons.star_border, color: Colors.black, size: 15);
                        } else {
                          // Filled stars
                          return const Icon(Icons.star, color: Color(0xffFFC500), size: 15);
                        }
                      }),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Great company to work for with very smart people.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 13),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.text,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 110,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: color,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
