// safe way of getting values from a map

extension ExtendedMap on Map {
  String strForKey(String key) {
    final dynamic result = this[key];

    if (result == null) {
      return '';
    }

    if (result is String) {
      return result;
    } else {
      print('strForKey: not string $result');
    }

    return '';
  }

  Map<K, V> mapForKey<K, V>(String key) {
    final dynamic result = this[key];

    if (result == null) {
      return null;
    }

    if (result is Map) {
      Map mapResult = result;

      if (mapResult is! Map<K, V>) {
        mapResult = Map<K, V>.from(mapResult);
      }
      return mapResult as Map<K, V>;
    } else {
      print('mapForKey: not map $result');
    }

    return null;
  }

  double doubleForKey(String key) {
    final dynamic result = this[key];

    if (result == null) {
      return 0.0;
    }

    if (result is double) {
      return result;
    } else {
      print('doubleForKey: not double $result');
    }

    return 0.0;
  }

  int intForKey(String key) {
    final dynamic result = this[key];

    if (result == null) {
      return 0;
    }

    if (result is int) {
      return result;
    } else {
      print('intForKey: not int $result');
    }

    return 0;
  }

  bool boolForKey(String key) {
    final dynamic result = this[key];

    if (result == null) {
      return false;
    }

    if (result is bool) {
      return result;
    } else {
      print('boolForKey: not bool $result');
    }

    return false;
  }

  List<T> listForKey<T>(String key) {
    final dynamic result = this[key];

    if (result == null) {
      return null;
    }

    if (result is List) {
      List listResult = result;

      if (listResult is! List<T>) {
        listResult = List<T>.from(listResult);
      }
      return listResult as List<T>;
    } else {
      print('listForKey: not List $result');
    }

    return null;
  }
}
