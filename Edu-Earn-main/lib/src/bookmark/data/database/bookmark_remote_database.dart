import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_earn/core/job/domain/entity/job.dart';

import '../../domain/entity/bookmark.dart';

abstract class BookmarkRemoteDatabase {
  Future<Bookmark> addBookmark(Bookmark bookmark);

  Future<Bookmark?> removeBookmark(Bookmark bookmark);

  Future<List<JobEntity>> getUserBookmarks(String userId);
}

class BookmarkRemoteDatabaseImpl implements BookmarkRemoteDatabase {
  @override
  Future<Bookmark> addBookmark(Bookmark bookmark) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bookmarks')
          .where('userId', isEqualTo: bookmark.userId)
          .where('jobId', isEqualTo: bookmark.jobId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update(bookmark.toJson());
        return bookmark;
      } else {
        await FirebaseFirestore.instance.collection('bookmarks').add(bookmark.toJson());
        return bookmark;
      }
    } catch (e) {
      throw Exception('Failed to add bookmark: $e');
    }
  }

  @override
  Future<List<JobEntity>> getUserBookmarks(String userId) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('bookmarks').where('userId', isEqualTo: userId).get();

    List<Bookmark> bookmarks = [];
    for (DocumentSnapshot doc in querySnapshot.docs) {
      bookmarks.add(Bookmark.fromJson(doc.data() as Map<String, dynamic>));
    }
    List<JobEntity> jobs = [];
    for (Bookmark bookmark in bookmarks) {
      DocumentSnapshot jobDoc = await FirebaseFirestore.instance.collection('jobs').doc(bookmark.jobId).get();
      if (jobDoc.exists) {
        jobs.add(JobEntity.fromMap(jobDoc.data() as Map<String, dynamic>));
      }
    }
    return jobs;
  }

  @override
  Future<Bookmark?> removeBookmark(Bookmark bookmark) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('bookmarks')
        .where('userId', isEqualTo: bookmark.userId)
        .where('jobId', isEqualTo: bookmark.jobId)
        .get();

    Bookmark? deletedBookmark;

    for (DocumentSnapshot doc in querySnapshot.docs) {
      deletedBookmark = Bookmark.fromJson(doc.data() as Map<String, dynamic>);
      await doc.reference.delete();
    }
    return deletedBookmark;
  }
}
