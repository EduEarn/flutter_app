import 'package:cached_network_image/cached_network_image.dart';
import 'package:edu_earn/src/applications/domain/entity/job_application.dart';
import 'package:edu_earn/src/applications/presentation/bloc/job_application_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../../shared/data/image_assets.dart';

class JobApplicationListPage extends StatefulWidget {
  const JobApplicationListPage({super.key});

  @override
  State<JobApplicationListPage> createState() => _JobApplicationListPageState();
}

class _JobApplicationListPageState extends State<JobApplicationListPage> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    context.read<JobApplicationBloc>().add(JobApplicationFetched(userId: userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          title: Text(
            "Applications",
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
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<JobApplicationBloc, JobApplicationState>(
            builder: (context, state) {
              if (state is JobApplicationLoading) {
                return Center(
                  child: SpinKitFadingCircle(
                    color: Theme.of(context).primaryColor,
                    size: 45.0,
                  ),
                );
              } else if (state is JobApplicationFailure) {
                return const Center(
                  child: Text('Failed to load applications'),
                );
              } else if (state is JobApplicationLoaded) {
                List<JobApplication> applications = state.jobApplication;
                if (applications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImageAssets.noData,
                          width: 250,
                        ),
                        const Text('Your job applications will appear hear'),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: applications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final application = applications[index];
                    return Card(
                      elevation: 0,
                      color:
                          Theme.of(context).brightness == Brightness.dark ? Colors.grey[800]! : const Color(0xffF9F7FB),
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: application.job.image,
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
                        // SizedBox(
                        //   width: 50,
                        //   height: 100,
                        //   child: const PDF().cachedFromUrl(
                        //     application.cvUrl,
                        //     placeholder: (progress) => Center(child: Text('$progress %')),
                        //     errorWidget: (error) => Center(child: Text(error.toString())),
                        //   ),
                        // ),
                        title: Text(
                          application.job.companyName,
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(DateFormat('MMMM d, yyyy').format(application.createdAt)),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No applications available.'),
                );
              }
            },
          ),
        ));
  }
}
