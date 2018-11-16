package kr.co.ewp.api.util;

public class IfUtil {
  public static <T> T nvl(T target, T defaultValue) {
    if (target == null) {
      return defaultValue;
    } else {
      return target;
    }
  }
}
