package kr.co.ewp.ewpsp.common.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;
import java.util.TimeZone;

public final class DateUtil {
  private static TimeZone timeZone;

  static {
    try {
      timeZone = TimeZone.getTimeZone("GMT+09:00");
    } catch (Exception e) {
    }
  }

  public static Date getDate() {

    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);

    return cal.getTime();
  }

  public static Date getDate(long offset) {

    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);
    cal.setTime(new Date(cal.getTime().getTime() + (offset * 1000)));

    return cal.getTime();
  }

  public static Date getDate(Date date, long offset) {

    return new Date(date.getTime() + (offset * 1000));
  }

  public static String getDateString(String format) {
    SimpleDateFormat simpleFormat = new SimpleDateFormat(format);
    simpleFormat.setTimeZone(timeZone);
    return simpleFormat.format(getDate());
  }

  public static String getDateString(String format, Locale locale) {
    SimpleDateFormat simpleFormat = new SimpleDateFormat(format, locale);
    simpleFormat.setTimeZone(timeZone);
    return simpleFormat.format(getDate());
  }

  public static String getDateString() {
    return getDateString("yyyy-MM-dd HH:mm:ss");
  }

  public static long getDateLong(String format) {

    SimpleDateFormat simpleFormat = new SimpleDateFormat(format);
    simpleFormat.setTimeZone(timeZone);
    return Long.parseLong(simpleFormat.format(getDate()));
  }

  public static long getDateLong() {
    return getDateLong("yyyyMMddHHmmss");
  }

  public static long getDateLongS() {
    return getDateLong("yyyyMMddHHmmssSSS");
  }

  public static Date getDate(int year, int month, int day, int hour, int minute, int second) {

    GregorianCalendar cal = new GregorianCalendar(timeZone, Locale.KOREAN);
    cal.set(year, month - 1, day, hour, minute, second);
    return cal.getTime();
  }

  public static String dateToString(Date date, String format) {
    if (date == null) {
      return null;
    }
    if (format == null || format.equals("")) {
      format = "yyyyMMdd";
    }
    SimpleDateFormat simpleFormat = new SimpleDateFormat(format);
    simpleFormat.setTimeZone(timeZone);
    return simpleFormat.format(date);
  }

  public static String dateToString(Calendar date, String format) {
    SimpleDateFormat simpleFormat = new SimpleDateFormat(format);
    simpleFormat.setTimeZone(timeZone);
    return simpleFormat.format(date.getTime());
  }

  public static String getDateToString(String format) {
    SimpleDateFormat simpleFormat = new SimpleDateFormat(format);
    Calendar now = Calendar.getInstance(timeZone, Locale.KOREAN);
    return simpleFormat.format(now.getTime());
  }

  public static Date stringToDate(String dateString, String format) {
    SimpleDateFormat simpleFormat = new SimpleDateFormat(format);
    simpleFormat.setTimeZone(timeZone);
    try {
      return simpleFormat.parse(dateString);
    } catch (ParseException e) {
      throw new RuntimeException(e);
    }
  }

  public static long dateToLong(Date date, String format) {

    SimpleDateFormat simpleFormat = new SimpleDateFormat(format);
    simpleFormat.setTimeZone(timeZone);
    return Long.parseLong(simpleFormat.format(date));
  }

  public static Date longToDate(long dateLong, String format) throws ParseException {

    SimpleDateFormat simpleFormat = new SimpleDateFormat(format);
    simpleFormat.setTimeZone(timeZone);
    return simpleFormat.parse(Long.toString(dateLong));
  }

  public static String longToString(long dateLong, String format) throws ParseException {
    return dateToString(longToDate(dateLong, "yyyyMMddHHmmss"), format);
  }

  public static int getAfterDays(Date date1, Date date2) {
    return (int) ((date1.getTime() - date2.getTime()) / 86400000);
  }

  public static void main(String[] args) {
    System.out.println(DateUtil.getAfterYears(1, "yyyyMMdd"));
  }

  public static int getAfterSeconds(Date date1, Date date2) {

    return (int) ((date1.getTime() - date2.getTime()) / 1000);
  }

  public static int getAfterMilliSeconds(Date date1, Date date2) {

    return (int) (date1.getTime() - date2.getTime());
  }

  /**
   * 해당 월의 첫 번째 날짜를 구한다.
   * 
   * @param year
   * @param month
   * @param format
   * @return
   */
  public static String getCurMonthFirstDate(String year, String month, String format) {

    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);

    int curYear = Integer.parseInt(year);
    int curMonth = Integer.parseInt(month);

    cal.set(curYear, curMonth - 1, 1);
    int curMinDay = cal.getActualMinimum(Calendar.DATE);

    Date curDate = DateUtil.getDate(curYear, curMonth, curMinDay, 0, 0, 0);

    return DateUtil.dateToString(curDate, format);
  }

  /**
   * 해당 주의 첫 번째 날짜를 구한다.
   * 
   * @param year
   * @param month
   * @param format
   * @return
   */
  public static Date getFirstDateOfWeek(Date date) {

    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);
    cal.setTime(date);
    while (cal.get(Calendar.DAY_OF_WEEK) != Calendar.SUNDAY) {
      cal.add(Calendar.DATE, -1);
    }
    return cal.getTime();
  }

  /**
   * 이번달 마지막 날짜
   * 
   * @param format
   * @return
   */
  public static String getCurMonthLastDate(String format) {
    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);
    cal.set(Calendar.DATE, cal.getActualMaximum(Calendar.DATE));
    return DateUtil.dateToString(cal, format);
  }

  /**
   * 지난달 첫번째 날짜
   * 
   * @param format
   * @return
   */
  public static String getPreMonthFirstDate(String format) {
    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);
    cal.add(Calendar.MONTH, -1);
    cal.set(Calendar.DATE, 1);
    return DateUtil.dateToString(cal, format);
  }

  public static String getMonthFirstDate(String format) {
    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);
    cal.set(Calendar.DATE, 1);
    return DateUtil.dateToString(cal, format);
  }

  /**
   * 지난달 마지막 날짜
   * 
   * @param format
   * @return
   */
  public static String getPreMonthLastDate(String format) {
    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);
    cal.set(Calendar.DATE, 1);
    cal.add(Calendar.DAY_OF_MONTH, -1);
    return DateUtil.dateToString(cal, format);
  }

  /**
   * 현재 요일을 구한다.
   * 
   * @return
   */
  public static String getDay() {
    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);
    int curDay = cal.get(Calendar.DAY_OF_WEEK);
    String[] days = { "", "일", "월", "화", "수", "목", "금", "토" };
    return days[curDay];
  }

  public static Calendar getCalendar() {
    return Calendar.getInstance(timeZone, Locale.KOREAN);
  }

  public static Calendar getCalendar(Date date) {
    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);
    cal.setTime(date);
    return cal;
  }

  public static Calendar getCalendar(String strDate, String format) {
    return DateUtil.getCalendar(DateUtil.stringToDate(strDate, format));
  }

  public static Calendar getCalendar(String format) {
    return DateUtil.getCalendar(DateUtil.stringToDate(DateUtil.getDateString(format), format));
  }

  /**
   * 현재 요일을 숫자로 구한다.
   * 
   * @return
   */
  public static int getIntDay() {
    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);
    return cal.get(Calendar.DAY_OF_WEEK);
  }

  public static String getAfterYears(int year) {
    SimpleDateFormat simpleFormat = new SimpleDateFormat("yyyyMMddHHmm", Locale.KOREA);
    Calendar now = Calendar.getInstance(timeZone, Locale.KOREAN);
    now.add(Calendar.YEAR, year);
    return simpleFormat.format(now.getTime());
  }

  public static String getAfterYears(int year, String format) {
    SimpleDateFormat simpleFormat = new SimpleDateFormat(format, Locale.KOREA);
    Calendar now = Calendar.getInstance(timeZone, Locale.KOREAN);
    now.add(Calendar.YEAR, year);
    return simpleFormat.format(now.getTime());
  }

  public static String getAfterMonths(int month) {
    SimpleDateFormat simpleFormat = new SimpleDateFormat("yyyyMMddHHmm", Locale.KOREA);
    Calendar now = Calendar.getInstance(timeZone, Locale.KOREAN);
    now.add(Calendar.MONTH, month);
    return simpleFormat.format(now.getTime());
  }

  public static String getAfterMonths(int month, String format) {
    SimpleDateFormat simpleFormat = new SimpleDateFormat(format, Locale.KOREA);
    Calendar now = Calendar.getInstance(timeZone, Locale.KOREAN);
    now.add(Calendar.MONTH, month);
    return simpleFormat.format(now.getTime());
  }

  public static String getAfterMonths(Date now, int month, String format) {
    SimpleDateFormat simpleFormat = new SimpleDateFormat(format, Locale.KOREA);
    Calendar nowCal = Calendar.getInstance(timeZone, Locale.KOREAN);
    nowCal.setTime(now);
    nowCal.add(Calendar.MONTH, month);
    return simpleFormat.format(nowCal.getTime());
  }

  public static Date getAfterMonths(Date now, int month) {
    if (now == null) {
      return null;
    }
    Calendar nowCal = Calendar.getInstance(timeZone, Locale.KOREAN);
    nowCal.setTime(now);
    nowCal.add(Calendar.MONTH, month);
    return nowCal.getTime();
  }

  /**
   * 오늘 날짜로 부터, day가 지난 날짜를 구함
   * 
   * @param day
   * @return
   */
  public static Date getAfterDays(int day) {
    Calendar now = Calendar.getInstance(timeZone, Locale.KOREAN);
    now.add(Calendar.DATE, day);
    return now.getTime();
  }

  /**
   * 특정 날짜로부터, day가 지난 날짜를 구함
   * 
   * @param date
   * @param day
   * @return
   */
  public static Date getAfterDays(Date date, int day) {
    Calendar now = Calendar.getInstance(timeZone, Locale.KOREAN);
    now.setTime(date);
    now.add(Calendar.DATE, day);
    return now.getTime();
  }

  /**
   * 특정 날짜로부터, 몇 주가 지난 날짜를 구함
   * 
   * @param date
   * @param week
   *          몇 주
   * @return
   */
  public static Date getAfterWeeks(Date date, int week) {
    Calendar now = Calendar.getInstance(timeZone, Locale.KOREAN);
    now.setTime(date);
    now.add(Calendar.WEEK_OF_MONTH, 1);
    return now.getTime();
  }

  public static String getAfterDays(int day, String format) {
    SimpleDateFormat simpleFormat = new SimpleDateFormat(format, Locale.KOREA);
    Calendar now = Calendar.getInstance(timeZone, Locale.KOREAN);
    now.add(Calendar.DATE, day);
    return simpleFormat.format(now.getTime());
  }

  public static String getAfterHours(int hour) {
    SimpleDateFormat simpleFormat = new SimpleDateFormat("yyyyMMddHHmm", Locale.KOREA);
    Calendar now = Calendar.getInstance(timeZone, Locale.KOREAN);
    now.add(Calendar.HOUR_OF_DAY, hour);
    return simpleFormat.format(now.getTime());
  }

  public static String getAfterMinute(int minute) {
    SimpleDateFormat simpleFormat = new SimpleDateFormat("yyyyMMddHHmm", Locale.KOREA);
    Calendar now = Calendar.getInstance(timeZone, Locale.KOREAN);
    now.add(Calendar.MINUTE, minute);
    return simpleFormat.format(now.getTime());
  }

  public static Date getAfterMinute(Date date, int minute) {
    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);
    cal.setTime(date);
    cal.add(Calendar.MINUTE, minute);
    return cal.getTime();
  }

  public static Date getAfterMinuteForDate(int minute) {
    Calendar now = Calendar.getInstance(timeZone, Locale.KOREAN);
    now.add(Calendar.MINUTE, minute);
    return now.getTime();
  }

  public static String getyyyyMMddHHmmssSSS() {
    return getDateString("yyyyMMddHHmmssSSS");
  }

  public boolean isHoliday(Date date) {
    boolean isHoliday = false;

    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);
    cal.setTime(date);

    if (cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY || cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY) {
      isHoliday = true;
    }

    // Now write logic to check the date for potential
    // matches among a list of public holidays stored
    // in an external location
    return isHoliday;
  }

  public static boolean isHoliday() {
    boolean isHoliday = false;

    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);

    if (cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY || cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY) {
      isHoliday = true;
    }

    // Now write logic to check the date for potential
    // matches among a list of public holidays stored
    // in an external location
    return isHoliday;
  }

  /**
   * Calendar에서 YYYYMMDDH24MISSMMM 추출
   * 
   * @param c
   *          Calendar
   * @param isMillisecond
   *          Millisecond 추가 여부
   * @return YYYYMMDDH24MISSMMM
   */
  public static String toDTime(Calendar c, boolean isMillisecond) {

    StringBuffer sb = new StringBuffer(17);

    /** 년 */
    if (c.get(Calendar.YEAR) < 10)
      sb.append('0');
    sb.append(c.get(Calendar.YEAR));

    /** 월 */
    if (c.get(Calendar.MONTH) + 1 < 10)
      sb.append('0');
    sb.append(c.get(Calendar.MONTH) + 1);

    /** 일 */
    if (c.get(Calendar.DAY_OF_MONTH) < 10)
      sb.append('0');
    sb.append(c.get(Calendar.DAY_OF_MONTH));

    /** 시 */
    if (c.get(Calendar.HOUR_OF_DAY) < 10)
      sb.append('0');
    sb.append(c.get(Calendar.HOUR_OF_DAY));

    /** 분 */
    if (c.get(Calendar.MINUTE) < 10)
      sb.append('0');
    sb.append(c.get(Calendar.MINUTE));

    /** 초 */
    if (c.get(Calendar.SECOND) < 10)
      sb.append('0');
    sb.append(c.get(Calendar.SECOND));

    /** MILLISECOND */
    if (isMillisecond) {
      int mil = c.get(Calendar.MILLISECOND);
      if (mil == 0) {
        sb.append("000");
      } else if (mil < 10) {
        sb.append("00");
      } else if (mil < 100) {
        sb.append("0");
      }

      sb.append(mil);
    }

    return sb.toString();
  }

  /**
   * <p>
   * Description : 남은 시간 계산
   * <p>
   * 
   * @param lTime
   *          {long} lTime 미리초단위 시간
   * @return 포매팅된 문자열
   */
  public static String remainingTime(long lTime) {
    long days = lTime / 86400000;// 60*60*24*1000
    lTime = lTime % 86400000;

    long hours = lTime / 3600000;// 60*60*1000
    lTime = lTime % 3600000;

    long minutes = lTime / 60000;// 60*1000
    lTime = lTime % 60000;

    long seconds = lTime / 1000;// 1000

    StringBuffer sb = new StringBuffer();
    if (days > 0) {
      sb.append(days).append("일 ");
      sb.append(hours).append("시간 ");
      sb.append(minutes).append("분 ");
    } else if (hours > 0) {
      sb.append(hours).append("시간 ");
      sb.append(minutes).append("분 ");
    } else if (minutes > 0) {
      sb.append(minutes).append("분 ");
    }
    sb.append(seconds).append("초");
    return sb.toString();
  }

  /**
   * 해당 달의 몇 주차인지 조회
   * 
   * @param date
   * @return
   */
  public static int getWeek(Date date) {
    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);
    cal.setTime(date);

    return cal.get(Calendar.DAY_OF_WEEK_IN_MONTH);
  }

  public static Date getMonthLastDate(Date date) {
    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);
    cal.setTime(date);
    cal.set(Calendar.DATE, cal.getActualMaximum(Calendar.DATE));
    cal.set(Calendar.HOUR, 23);
    cal.set(Calendar.MINUTE, 59);
    cal.set(Calendar.SECOND, 59);
    return cal.getTime();
  }

  public static Date getNextMonthFirstDate(Date date) {
    Calendar cal = Calendar.getInstance(timeZone, Locale.KOREAN);
    cal.setTime(date);
    cal.add(Calendar.MONTH, 1);
    cal.set(Calendar.DATE, 1);
    return cal.getTime();
  }
}
