import 'package:edu_earn/core/job/domain/entity/job.dart';
import 'package:edu_earn/core/user/domain/entity/user.dart';
import 'package:edu_earn/src/home/presentation/widgets/job_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/data/image_assets.dart';
import '../../../../shared/utils/amount_formatter.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../widgets/recent_job_card.dart';

class CustomSearchDelegate extends SearchDelegate<JobEntity> {
  final List<JobEntity> jobs;

  CustomSearchDelegate(this.jobs);

  @override
  TextStyle get searchFieldStyle => const TextStyle(fontWeight: FontWeight.w600);

  @override
  get searchFieldLabel => 'Search for company or roles';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final matchQuery = jobs
        .where((job) =>
            job.companyName.toLowerCase().contains(query.toLowerCase()) ||
            job.role.toLowerCase().contains(query.toLowerCase()) ||
            job.type.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (matchQuery.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageAssets.noData, width: 300),
            const Text('No Jobs found'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 24),
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final result = matchQuery[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: RecentJobCard(
              onTap: () => Get.to(() => JobDetailPage(job: result, user: UserEntity.initial())),
              image: result.image,
              role: result.role,
              type: result.type,
              companyName: result.companyName,
              location: result.location,
              date: DateFormatter.formatDate(result.time,'Posted'),
              level: result.level,
              amount: '${AmountFormatter.formatAmount(result.amount)}/mo',
              description: result.description),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<JobEntity> initialJobs = jobs;

    if (query.isNotEmpty) {
      initialJobs = jobs
          .where((job) =>
              job.companyName.toLowerCase().contains(query.toLowerCase()) ||
              job.role.toLowerCase().contains(query.toLowerCase()) ||
              job.type.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    if (query.isEmpty && initialJobs.isEmpty) {
      return const Center(
        child: Text('Search for company or roles'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 24),
      itemCount: initialJobs.length,
      itemBuilder: (context, index) {
        final result = initialJobs[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: RecentJobCard(
            onTap: () => Get.to(() => JobDetailPage(job: result, user: UserEntity.initial())),
            image: result.image,
            role: result.role,
            type: result.type,
            companyName: result.companyName,
            location: result.location,
            date: DateFormatter.formatDate(result.time, 'Posted'),
            level: result.level,
            amount: '${AmountFormatter.formatAmount(result.amount)}/mo',
            description: result.description,
          ),
        );
      },
    );
  }

}
