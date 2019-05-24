abstract class IParser<T> {
  T parseJsonToObject(dynamic json);
  List<T> parseJsonToListObjects(dynamic json);
}
