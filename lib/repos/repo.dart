abstract class Repo {
  void deleteAll(List<int> ids);
  void delete(int id);
  Future findById(int id);
  Future findAll();
  Future<int?> findMaxID();
  Future save(Object entity);
}
