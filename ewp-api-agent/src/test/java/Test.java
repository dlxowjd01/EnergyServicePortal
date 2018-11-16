import java.util.Calendar;
import java.util.Date;

import kr.co.ewp.api.util.DateUtil;

public class Test {
  public static void main(String[] args) {
    System.out.println(new Date(1535641200000L));
    System.out.println(new Date(1535554800000L));
    System.out.println(new Date(1509461100000L));
    Calendar calendar = DateUtil.getCalendar();
    calendar.set(Calendar.MONTH, 1);
    calendar.set(Calendar.DATE, 300);
    DateUtil.truncateHms(calendar);
    System.out.println(DateUtil.dateToString(calendar, "yyyyMMddHHmmss"));
  }
}
