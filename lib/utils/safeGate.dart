dynamic safeGet(dynamic obj, List<dynamic> path) {

  dynamic acc = obj;

  for (final key in path) {

    if (acc == null) {
      return null;
    }

    // 🔹 Support -1 for last array item
    if (key == -1 && acc is List) {

      acc = acc.isNotEmpty
          ? acc.last
          : null;

      continue;
    }

    if (acc is List && key is int) {

      if (key < 0 || key >= acc.length) {
        return null;
      }

      acc = acc[key];

    } else if (acc is Map) {

      acc = acc[key];

    } else {

      return null;
    }

    if (acc == null) {
      return null;
    }
  }

  return acc;
}