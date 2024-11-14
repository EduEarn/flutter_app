import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_earn/core/job/domain/entity/job.dart';
import 'package:edu_earn/core/user/domain/entity/user.dart';
import 'package:edu_earn/src/authentication/presentation/bloc/auth_bloc.dart';
import 'package:edu_earn/src/home/presentation/screens/search_delegate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../core/job/service/job_update.dart';
import '../../../../shared/data/image_assets.dart';
import '../../../../shared/utils/amount_formatter.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../../../authentication/presentation/widgets/input_field.dart';
import '../../../notification/screens/notification.dart';
import '../../../notification/service/repository/notification_repository.dart';
import '../widgets/job_card.dart';
import '../widgets/job_detail.dart';
import '../widgets/recent_job_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final searchController = TextEditingController();

  final user = ValueNotifier<UserEntity>(UserEntity.initial());

  List<String> workPreference = ['All', 'PartTime', 'FullTime', 'Intern'];
  String selectedWorkPreference = 'All';
  String selectedJobType = 'All';
  String searchQuery = '';
  JobUpdateService? jobUpdateService;

  final FocusNode _focusNode = FocusNode();
  List<JobEntity> jobs = [];
  final NotificationRepository _repository = NotificationRepository();

  @override
  void initState() {
    context.loaderOverlay.hide();
    _focusNode.addListener(_onFocusChange);
    context.read<AuthBloc>().add(GetUserInfo());
    jobUpdateService = JobUpdateService(userId: FirebaseAuth.instance.currentUser!.uid);
    jobUpdateService?.startListening();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      FocusScope.of(context).requestFocus(FocusNode());
      showSearch(context: context, delegate: CustomSearchDelegate(jobs));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserInfoLoaded) {
          user.value = state.user;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: ValueListenableBuilder(
            valueListenable: user,
            builder: (context, value, _) {
              return Text(
                "Hello, ${value.fullName} 👋",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
              );
            },
          ),
          actions: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFFFFE28D),
                foregroundImage: AssetImage(ImageAssets.profile),
              ),
            ),
            StreamBuilder<int>(
              stream: Stream.periodic(Duration(seconds: 1)).asyncMap((_) => _repository.getUnreadNotificationCount()),
              initialData: 0,
              builder: (context, snapshot) {
                final unreadCount = snapshot.data ?? 0;
                return IconButton(
                  onPressed: () async {
                    await Get.to(() => const NotificationPage());
                    await _repository.markAllAsRead();
                  },
                  icon: unreadCount > 0
                      ? Badge.count(
                          count: unreadCount,
                          textColor: Colors.white,
                          child: Icon(Icons.notifications_none, size: 30),
                        )
                      : Icon(Icons.notifications_none, size: 30),
                );
              },
            ),
            SizedBox(width: 8),
          ],
          automaticallyImplyLeading: false,
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Start Your New Journey",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 290,
                        child: InputField(
                          focusNode: _focusNode,
                          controller: searchController,
                          placeholder: "Search for company or roles",
                          obscureText: false,
                          icon: Icons.search_rounded,
                          fillColor: Colors.grey[50],
                          filled: Theme.of(context).brightness == Brightness.dark ? false : true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.search, color: Colors.grey, size: 24),
                            onPressed: () {
                              showSearch(
                                  context: context, delegate: CustomSearchDelegate(jobs), useRootNavigator: true);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: InkWell(
                          onTap: () => showJobFilter(context),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 54,
                            height: 54,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Image.asset(ImageAssets.filter),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "For you",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        height: 164,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Let's find suitable\n job for you!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                Text("Get more attention and better\n chance of finding a great job.",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w300)),
                              ],
                            ),
                            SizedBox(
                              width: 120,
                              child: Image.asset(ImageAssets.jobSearch, fit: BoxFit.cover),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    "Recommended Jobs",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("jobs").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("An error occurred"),
                        );
                      }
                      List<DocumentSnapshot> filteredJobs = snapshot.data!.docs
                          .where((jobDoc) =>
                              (selectedWorkPreference == 'All' || jobDoc.data()['type'] == selectedWorkPreference) &&
                              (selectedJobType == 'All' || jobDoc.data()['role'] == selectedJobType))
                          .toList();

                      if (filteredJobs.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("No results found"),
                          ),
                        );
                      }
                      return Column(
                        children: [
                          SizedBox(
                            height: 90,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(8),
                              shrinkWrap: true,
                              itemCount: filteredJobs.length,
                              separatorBuilder: (context, _) => const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final jobDoc = filteredJobs[index];
                                JobEntity job = JobEntity.fromMap(jobDoc.data() as Map<String, dynamic>);
                                return JobCard(
                                  onTap: () => Get.to(() => JobDetailPage(job: job, user: user.value)),
                                  role: job.role,
                                  image: job.image,
                                  amount: '${AmountFormatter.formatAmount(job.amount)}/mo',
                                  company: job.companyName,
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Jobs",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () {
                          showSearch(context: context, delegate: CustomSearchDelegate(jobs), useRootNavigator: true);
                        },
                        child: Text(
                          "More",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("jobs").orderBy('time', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("An error occurred ${snapshot.error}"),
                      );
                    }
                    jobs.clear();
                    jobs.addAll(snapshot.data!.docs.map((jobDoc) {
                      return JobEntity.fromMap(jobDoc.data());
                    }).toList());
                    List<DocumentSnapshot> filteredJobs = snapshot.data!.docs
                        .where((jobDoc) =>
                            (selectedWorkPreference == 'All' || jobDoc.data()['type'] == selectedWorkPreference) &&
                            (selectedJobType == 'All' || jobDoc.data()['role'] == selectedJobType))
                        .toList();

                    if (filteredJobs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 80.0),
                        child: Column(
                          children: [
                            Center(
                              child: Image.asset(
                                ImageAssets.noData,
                                width: 250,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredJobs.length,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DocumentSnapshot jobDoc = filteredJobs[index];
                        JobEntity job = JobEntity.fromMap(jobDoc.data() as Map<String, dynamic>);
                        final timestamp = job.time;
                        String formattedDate = DateFormatter.formatDate(timestamp, 'Posted');

                        return RecentJobCard(
                            onTap: () => Get.to(() => JobDetailPage(job: job, user: user.value)),
                            image: job.image,
                            role: job.role,
                            type: job.type,
                            companyName: job.companyName,
                            location: job.location,
                            date: formattedDate,
                            level: job.level,
                            amount: '${AmountFormatter.formatAmount(job.amount)}/mo',
                            description: job.description);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showJobFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade900 : Colors.white,
          ),
          child: Column(
            children: [
              Text(
                "Set Filters",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Work Preference",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: DropdownButtonFormField(
                      hint: const Text('Work Preference'),
                      value: selectedWorkPreference,
                      isExpanded: true,
                      isDense: true,
                      onChanged: (newValue) {
                        setState(() => selectedWorkPreference = newValue!);
                      },
                      items: workPreference.map((preference) {
                        return DropdownMenuItem(
                          value: preference,
                          child: Text(preference),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Job Type",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: DropdownButtonFormField(
                      hint: const Text('Job Type'),
                      value: selectedJobType,
                      isExpanded: true,
                      isDense: true,
                      onChanged: (newValue) {
                        setState(() => selectedJobType = newValue!);
                      },
                      items: [
                        const DropdownMenuItem(
                          value: 'All',
                          child: Text('All'),
                        ),
                        ...user.value.job.map((job) {
                          return DropdownMenuItem(
                            value: job,
                            child: Text(job),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary,
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: Text(
                  "Apply Filters",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
