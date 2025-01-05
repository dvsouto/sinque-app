class EnumUtil {
  static T namedBy<T>(List<T> values, String name) {
    return values.firstWhere(
      (item) => item.toString() == name,
    );
  }
}
