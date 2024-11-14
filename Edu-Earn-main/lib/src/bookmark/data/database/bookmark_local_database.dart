import 'package:hive/hive.dart';

import '../../../../core/job/domain/entity/job.dart';

abstract class BookmarkLocalDatabase {
  void uploadLocalBookmarks({required List<JobEntity> jobs});

  List<JobEntity> loadBookmarks();
}

class BookmarkLocalDatabaseImpl implements BookmarkLocalDatabase {
  final Box box;

  BookmarkLocalDatabaseImpl({required this.box});

  // BookmarkLocalDatabaseImpl() : box = Hive.box(name: "bookmarks");

  @override
  List<JobEntity> loadBookmarks() {
    List<JobEntity> jobs = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        Map<String, dynamic> jobMap = box.get(i.toString()) as Map<String, dynamic>;
        JobEntity job = JobEntity(
          id: jobMap['id'],
          role: jobMap['role'],
          location: jobMap['location'],
          amount: jobMap['amount'],
          companyName: jobMap['company'],
          reviews: jobMap['reviews'],
          image: jobMap['image'],
          description: jobMap['description'],
          aboutCompany: jobMap['about_company'],
          skillRequired: jobMap['skill_required'],
          companyMission: jobMap['company_mission'],
          type: jobMap['type'],
          level: jobMap['level'],
          time: DateTime.parse(jobMap['time']),
        );
        jobs.add(job);
      }
    });
    return jobs;
  }

  @override
  void uploadLocalBookmarks({required List<JobEntity> jobs}) {
    box.clear();
    box.write(() {
      for (int i = 0; i < jobs.length; i++) {
        box.put(
          i.toString(),
          {
            'id': jobs[i].id,
            'role': jobs[i].role,
            'location': jobs[i].location,
            'amount': jobs[i].amount,
            'company': jobs[i].companyName,
            'reviews': jobs[i].reviews,
            'image': jobs[i].image,
            'description': jobs[i].description,
            'about_company': jobs[i].aboutCompany,
            'skill_required': jobs[i].skillRequired,
            'company_mission': jobs[i].companyMission,
            'type': jobs[i].type,
            'level': jobs[i].level,
            'time': jobs[i].time.toIso8601String(),
          },
        );
      }
    });
  }
}
