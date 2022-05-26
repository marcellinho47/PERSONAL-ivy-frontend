abstract class Repo {
  deleteAll(List<int> ids);
  delete(int id);
  Future findById(int id);
  Future findAll();
  Future<int?> findMaxID();
  Future save(Object entity);
}
