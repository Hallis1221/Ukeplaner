Future<QuerySnapshot> getDocs() async {
  final DocumentReference cacheDocRef = db.doc('status/status');
  final String cacheField = 'updatedAt';
  final Query query = db.collection('classes');
  final QuerySnapshot snapshot = await FirestoreCache.getDocuments(
    query: query,
    cacheDocRef: cacheDocRef,
    firestoreCacheField: cacheField,
  );

  return snapshot;
}
