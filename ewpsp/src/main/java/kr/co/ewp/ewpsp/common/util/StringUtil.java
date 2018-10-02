package kr.co.ewp.ewpsp.common.util;

import java.io.UnsupportedEncodingException;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.URLEncoder;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.StringTokenizer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class StringUtil {

  private static final Logger logger = LoggerFactory.getLogger(StringUtil.class);

  public static String concat(String s1, String s2) throws UnsupportedEncodingException {
    return s1 + s2;
  }

  public static String urlEncode(String value) throws UnsupportedEncodingException {
    return URLEncoder.encode(value, "UTF-8");
  }

  public static String encodeFileNm(String fileName, String browser) {
    String encodedFilename = null;
    if ("MSIE".equals(browser)) {
      try {
        encodedFilename = URLEncoder.encode(fileName, "UTF-8");
      } catch (UnsupportedEncodingException e) {
        logger.error(e.getMessage());
      }
    } else if ("Firefox".equals(browser)) {
      try {
        encodedFilename = "\"" + new String(fileName.getBytes("UTF-8"), "8859_1") + "\"";
      } catch (UnsupportedEncodingException e) {
        logger.error(e.getMessage());
      }
    } else if ("Opera".equals(browser)) {
      try {
        encodedFilename = "\"" + new String(fileName.getBytes("UTF-8"), "8859_1") + "\"";
      } catch (UnsupportedEncodingException e) {
        logger.error(e.getMessage());
      }
    } else if ("Chrome".equals(browser)) {
      StringBuffer sb = new StringBuffer();
      for (int i = 0; i < fileName.length(); i++) {
        char c = fileName.charAt(i);
        if (c > '~') {
          try {
            sb.append(URLEncoder.encode("" + c, "UTF-8"));
          } catch (UnsupportedEncodingException e) {
            // e.printStackTrace(); 2017.09.29 보안수정 RH.Jung AvoidPrintStackTrace
            logger.error(e.getMessage());
          }
        } else {
          sb.append(c);
        }
      }
      encodedFilename = sb.toString();
    } else if ("Safari".equals(browser)) {
      try {
        encodedFilename =

            "\"" + new String(fileName.getBytes("UTF-8"), "8859_1") + "\"";
      } catch (UnsupportedEncodingException e) {
        logger.error(e.getMessage());
      }
    } else {
      try {
        encodedFilename = URLEncoder.encode(fileName, "UTF-8");
      } catch (UnsupportedEncodingException e) {
        logger.error(e.getMessage());
      }
    }

    return encodedFilename;
  }

  public static String removeHtml(String value) {
    String content = value.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
    content = content.replaceAll("<(/)?[a-zA-Z]*:[a-zA-Z]*>", "");
    content = content.replaceAll("&nbsp;", "");
    return content;
  }

  /**
   * 숫자로만 이루어진 단어 삭제
   * 
   * @param content
   * @return
   */
  public static String removeNumberWord(String content) {
    return content//
        .replaceAll("^(\\d+)\\s", "  $1  ")//
        .replaceAll("\\s(\\d+)\\s", "  $1  ")//
        .replaceAll("\\s(\\d+)$", "  $1  ")//
        .replaceAll("\\s\\d+\\s", " ")//
        .replaceAll("\\s+", " ")//
    ;
  }

  // 영어 및 한글 및 숫자 제외하고 지우기
  public static String removeSign(String str) {
    String match = "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]";
    str = str.replaceAll(match, " ").replaceAll("\\s+", " ");
    return str;
  }

  public static List<String> getSplitFullIndetp(String fullIndept) {
    // if (fullIndept.isEmpty() || fullIndept == null) { 2017.09.29 RH.Jung
    // MisplacedNullCheck
    if (fullIndept == null || fullIndept.isEmpty()) {
      return null;
    }

    List<String> result = new ArrayList<String>();

    String tmp[] = fullIndept.split("\\|");

    String indept = "";
    for (int i = 0; i < tmp.length; i++) {
      if (tmp[i].length() > 0) {
        indept = indept.replace(",", "");
        indept += "|" + tmp[i] + "|,";
        indept = indept.replaceAll("\\|\\|", "\\|");
        result.add(indept);
      }
    }
    return result;
  }

  public static String nvl(String source) {
    return source == null ? "" : source;
  }

  public static String nvl(String source, String defaultValue) {
    return source == null ? defaultValue : source;
  }

  public static boolean isNotEmpty(String month) {
    return month != null && month.trim().length() > 0;
  }

  // 특수문자 제거 하기
  public static String stringReplace(String str) {
    if (str == null || "".equals(str)) {
      return str;
    }
    String match = "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]";
    str = str.replaceAll(match, "").replaceAll("\\s", "");
    return str;
  }

  public static String replace(String source, String fromStr, String toStr) {
    if (source == null) {
      return null;
    }
    int start = 0;
    int end = 0;
    StringBuffer result = new StringBuffer();
    while ((end = source.indexOf(fromStr, start)) >= 0) {
      result.append(source.substring(start, end));
      result.append(toStr);
      start = end + fromStr.length();
    }
    result.append(source.substring(start));
    return result.toString();
  }

  public static String toCurrencyFormat(long num) {
    String result = "";
    String format = "#,###";
    try {
      NumberFormat formatter = new DecimalFormat(format);
      result = formatter.format(num);
      // 2017.09.29 보안수정 RH.Jung PMD-AvoidCatchingGenericException
    } catch (ArithmeticException e) {
      logger.error("toCurrencyFormat", e);
    } catch (Exception e) {
      // 2017.09.29 보안수정 RH.Jung EmptyCatchBlock
      logger.error("toCurrencyFormat", e);
    }
    return result;
  }

  public static String[] stringTokenizer(String str, String delim) {
    if (str == null) {
      return null;
    } else {
      StringTokenizer st = new StringTokenizer(str, delim);

      ArrayList<String> resultList = new ArrayList<String>();
      String[] result = null;

      while (st.hasMoreTokens()) {
        resultList.add(st.nextToken().trim());
      }

      result = new String[resultList.size()];
      resultList.toArray(result);

      return result;
    }
  }

  public static String getLocalServerIp() {
    try {
      for (Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces(); en.hasMoreElements();) {
        NetworkInterface intf = en.nextElement();
        for (Enumeration<InetAddress> enumIpAddr = intf.getInetAddresses(); enumIpAddr.hasMoreElements();) {
          InetAddress inetAddress = enumIpAddr.nextElement();
          if (!inetAddress.isLoopbackAddress() && !inetAddress.isLinkLocalAddress() && inetAddress.isSiteLocalAddress()) {
            return inetAddress.getHostAddress().toString();
          }
        }
      }
    } catch (SocketException e) {
      // 2017.09.29 보안수정 RH.Jung EmptyCatchBlock
      logger.error(e.getMessage());
    }
    return null;
  }

  public static String nextAlphabet(String source) {
    int length = source.length();
    char lastChar = source.charAt(length - 1);
    if (lastChar == 'Z') {
      if (length == 1) {
        return source = "AA";
      }
      source = nextAlphabet(source.substring(0, length - 1));
      source += "A";
      return source;
    }
    return source.substring(0, length - 1) + String.valueOf((char) (lastChar + 1));
  }

  public static boolean isEmpty(String src) {
    return !isNotEmpty(src);
  }

  public static String substring(String str, int startIndex, int length) {
    byte[] b1 = null;
    byte[] b2 = null;

    if (str == null) {
      return "";
    }

    b1 = str.getBytes();
    if (b1.length <= length) {
      return str;
    }
    b2 = new byte[length];

    if (length > (b1.length - startIndex)) {
      length = b1.length - startIndex;
    }

    System.arraycopy(b1, startIndex, b2, 0, length);

    return new String(b2);
  }

  public static String join(String glue, List<Integer> list) {
    String result = null;
    if (list != null && list.size() > 0) {
      result = "";
      for (Integer src : list) {
        result += glue + src;
      }
      result = result.replaceFirst(glue, "");
    }
    return result;
  }

}
