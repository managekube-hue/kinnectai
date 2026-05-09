abstract class DnaKitRepository {
  Future<Map<String, dynamic>> orderKit({required Map<String, dynamic> shippingAddress});
  Future<Map<String, dynamic>> getKitStatus(String kitId);
  Future<void> registerKit(String kitId, String barcode);
  Future<Map<String, dynamic>> getResults(String kitId);
  Future<void> requestRawDeletion(String kitId);
  Future<void> connectProvider(String provider, String oauthToken);
  Future<void> disconnectProvider(String provider);
}
