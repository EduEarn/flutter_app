import 'package:cached_network_image/cached_network_image.dart';
import 'package:edu_earn/core/job/domain/entity/job.dart';
import 'package:edu_earn/src/authentication/presentation/bloc/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../../core/user/domain/entity/user.dart';
import '../../../../shared/data/image_assets.dart';

import '../../../../shared/utils/date_formatter.dart';
import '../../../home/presentation/widgets/job_detail.dart';
import '../bloc/bookmark_bloc.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  final user = ValueNotifier<UserEntity>(UserEntity.initial());

  @override
  void initState() {
    context.read<BookmarkBloc>().add(RetrieveUserBookmark(userId: userId));
    context.read<AuthBloc>().add(GetUserInfo());
    super.initState();
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
          foregroundColor: Colors.black,
          title: Text(
            "Bookmarks",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFFFFE28D),
                foregroundImage: AssetImage(ImageAssets.profile),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocConsumer<BookmarkBloc, BookmarkState>(
            listener: (context, state) {
              if (state is BookmarkRemoveSuccess) {
                context.read<BookmarkBloc>().add(RetrieveUserBookmark(userId: userId));
              }
              if (state is BookmarkSaveSuccess) {
                context.read<BookmarkBloc>().add(RetrieveUserBookmark(userId: userId));
              }
            },
            builder: (context, state) {
              if (state is BookmarkLoading) {
                return Center(
                  child: SpinKitFadingCircle(
                    color:  Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).colorScheme.primary,
                    size: 45.0,
                  ),
                );
              } else if (state is BookmarkFailure) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is UserBookmarkListSuccess) {
                List<JobEntity> jobs = state.jobs;
                if (jobs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImageAssets.noData,
                          width: 250,
                        ),
                        const Text('Your Bookmarks will appear here...'),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: jobs.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return BookmarkCard(
                      onTap: () => Get.to(() => JobDetailPage(job: job, user: user.value)),
                      jobData: job,
                      formattedDate: DateFormatter.formatDate(job.time, 'Posted'),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No bookmarks available.'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class BookmarkCard extends StatelessWidget {
  const BookmarkCard({
    super.key,
    required this.jobData,
    required this.formattedDate,
    this.onTap,
    this.removeBookmark,
  });

  final JobEntity jobData;
  final String formattedDate;
  final void Function()? onTap;
  final void Function()? removeBookmark;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 85,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800]! : const Color(0xffF9F7FB),
            borderRadius: BorderRadius.circular(
              12,
            )),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: jobData.image,
                placeholder: (context, url) => const SizedBox(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(jobData.role),
                    Text(
                      jobData.companyName,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  formattedDate,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white :  Colors.black54,
                      ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              child:  Icon(
                  Icons.bookmark,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary,
                ),
            ),
          ],
        ),
      ),
    );
  }
}
