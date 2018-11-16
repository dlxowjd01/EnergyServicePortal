package kr.co.ewp.api.util;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import kr.co.ewp.api.model.CblResponseModel;
import kr.co.ewp.api.model.DeviceModel;
import kr.co.ewp.api.model.DrPaymentModel;
import kr.co.ewp.api.model.DrRequestTarget;
import kr.co.ewp.api.model.UsageModel;
import kr.co.ewp.api.model.UsageRealtimeModel;
import kr.co.ewp.api.util.EnertalkApiUtil.Period;
import kr.co.ewp.api.util.EnertalkApiUtil.TimeType;
import kr.co.ewp.api.util.EnertalkApiUtil.UsageType;

public class EnertalkApiUtilTest {
  /**
   * @param args
   */
  public static void main(String[] args) {
//	  String siteId = "TestSite1";
//	  String siteId = "1126187a";
    String siteId = "59c0cd19";// 구례1_전기실
    // String siteId = "3b5d0a40";// PMGROW
//     String siteId = "s1234567";// DR수익
//    getDrPaymentsTest(siteId);
//    getDrRequestTest(siteId);
//    getDrRequestTestTest(siteId);
//	  getDevicesTest(siteId);
//     String deviceId = "a8324a51";// 전기실 테스트
     String deviceId = "62ba07d3";
//     String deviceId = "d93e28eb";// 전기실 테스트
     getDeviceUsageTest(deviceId);
//     getSiteUsageTest(siteId);
//     getDeviceTest(deviceId);
//     getDeviceRealTimeTest(deviceId);
//     getCBLTest(siteId);
//     getCBLTest2(siteId);
  }

  public static void getDrPaymentsTest(String siteId) {
    PrettyLog prettyLog = new PrettyLog("getDrPaymentsTest");
    try {
      String beginMonth = DateUtil.getAfterMonths(-2, "yyyyMM");
      String endMonth = DateUtil.getDateString("yyyyMM");
      List<DrPaymentModel> payments = EnertalkApiUtil.getDrPayments(siteId, beginMonth, endMonth, prettyLog);
      prettyLog.append("RESULT", JsonUtil.toJson(payments));
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }

  public static void getDeviceUsageTest(String deviceId) {
    PrettyLog prettyLog = new PrettyLog("getUsageTest");
    try {
    	long e = Long.parseLong("1542348720000");
		  long s= Long.parseLong("1542348000000");
	      Date end = new Date(e);
	      Date start = new Date(s);
	      ////////////////////////////
//    	 Timestamp tp = Timestamp.valueOf("2018-11-06 00:00:00");
//		  Timestamp tp2 = Timestamp.valueOf("2018-11-06 23:59:59");
//		  Date start = new Date(tp.getTime());
//		  Date end = new Date(tp.getTime());
	      ////////////////////////////		  
//      Date start = new Date();
//      Date end = DateUtil.getAfterMinuteForDate(60);
      Period period = Period._15min;
      System.out.println(start+"   ,    "+end);
      UsageModel usageRealtime = EnertalkApiUtil.getUsagePeriodicByDeviceId(deviceId, period, start, end, TimeType.past, UsageType.positiveEnergy, prettyLog);
      prettyLog.append("RESULT", JsonUtil.toJson(usageRealtime));
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }
  
  public static void getSiteUsageTest(String siteId) {
	  PrettyLog prettyLog = new PrettyLog("getSiteUsageTest");
	  try {
		  long e = Long.parseLong("1541656800000");
		  long s= Long.parseLong("1541751287281");
	      Date end = new Date(e);
	      Date start = new Date(s);
//		  Timestamp tp = Timestamp.valueOf("2018-11-06 00:00:00");
//		  Timestamp tp2 = Timestamp.valueOf("2018-11-06 00:15:00");
//		  Date start = new Date(tp.getTime());
//		  Date end = new Date(tp.getTime());
		  Period period = Period._15min;
		  System.out.println(start+", "+end);
		  UsageModel usageRealtime = EnertalkApiUtil.getUsagePeriodicBySiteId(siteId, period, start, end, TimeType.past, UsageType.positiveEnergy, prettyLog);
		  prettyLog.append("RESULT", JsonUtil.toJson(usageRealtime));
	  } finally {
		  prettyLog.stop();
		  System.out.println(prettyLog.prettyPrint());
	  }
  }

  public static void getDevicesTest(String siteId) {
    PrettyLog prettyLog = new PrettyLog("getDevicesTest");
    try {
      List<DeviceModel> devices = EnertalkApiUtil.getDevices(siteId, prettyLog);
      prettyLog.append("RESULT", JsonUtil.toJson(devices));
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }

  public static void getDeviceTest(String deviceId) {
    PrettyLog prettyLog = new PrettyLog("getDeviceTest");
    try {
      DeviceModel device = EnertalkApiUtil.getDevice(deviceId, prettyLog);
      prettyLog.append("RESULT", JsonUtil.toJson(device));
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }
  
  public static void getDeviceRealTimeTest(String deviceId) {
	  PrettyLog prettyLog = new PrettyLog("getDeviceRealTimeTest");
	  try {
		  UsageRealtimeModel usage = EnertalkApiUtil.getDeviceRealTime(deviceId, prettyLog);
		  prettyLog.append("RESULTㅋㅋㅋㅋㅋㅋ      ", JsonUtil.toJson(usage));
	  } finally {
		  prettyLog.stop();
		  System.out.println(prettyLog.prettyPrint());
	  }
  }
  
  public static void getDrRequestTest(String siteId) {
	  PrettyLog prettyLog = new PrettyLog("getDrRequestTest");
	  int offset = 0;
	  int limit = 50;
	  try {
		  List<DrRequestTarget> resultList = EnertalkApiUtil.getDrRequest(siteId, offset, limit, prettyLog);
		  prettyLog.append("RESULT      ", JsonUtil.toJson(resultList));
	  } finally {
		  prettyLog.stop();
		  System.out.println(prettyLog.prettyPrint());
	  }
  }
  
  public static void getDrRequestTestTest(String siteId) {
	  PrettyLog prettyLog = new PrettyLog("getDrRequestTestTest");
	  int offset = 0;
	  int limit = 50;
//	  Timestamp tp = Timestamp.valueOf("2018-11-06 00:00:00");
//	  Timestamp tp2 = Timestamp.valueOf("2018-11-06 23:59:59");
//	  Date start = new Date(tp.getTime());
//	  Date end = new Date(tp.getTime());
	  Date end = new Date();
      Date start = DateUtil.getAfterDays(-25);
	  try {
		  List<DrRequestTarget> resultList = EnertalkApiUtil.getDrRequestTerm(siteId, start, end, offset, limit, prettyLog);
		  prettyLog.append("RESULT      ", JsonUtil.toJson(resultList));
	  } finally {
		  prettyLog.stop();
		  System.out.println(prettyLog.prettyPrint());
	  }
  }
  
  public static void getCBLTest(String siteId) {
	  PrettyLog prettyLog = new PrettyLog("getCBLTest");
//	  Date end = new Date();
//      Date start = DateUtil.getAfterDays(-1);
	  long e = Long.parseLong("1541581199000");
	  long s= Long.parseLong("1541577600000");
      Date end = new Date(e);
      Date start = new Date(s);
      System.out.println(start+", "+end);
	  try {
		  CblResponseModel resultList = EnertalkApiUtil.getCBL(siteId, start, end, prettyLog);
		  prettyLog.append("RESULT      ", JsonUtil.toJson(resultList));
	  } finally {
		  prettyLog.stop();
		  System.out.println(prettyLog.prettyPrint());
	  }
  }
  
  public static void getCBLTest2(String siteId) {
	  PrettyLog prettyLog = new PrettyLog("getCBLTest");
	  Date today = new Date();
	  System.out.println("today = "+today);
	    Calendar cal = Calendar.getInstance();
	    cal.setTimeInMillis(   today.getTime()   );
	    Calendar cal2 = Calendar.getInstance();
		cal2.setTimeInMillis(   today.getTime()   );
		
//	    DateUtil.setHms(cal, cal.get(Calendar.HOUR_OF_DAY)-2, 0, 0, 000);
	    DateUtil.setHms(cal, -1, 0, 0, 000);
	    cal.add(Calendar.HOUR, -9);
	    Date start = new Date(cal.getTime().getTime());
	    cal.add(Calendar.HOUR, -1);
	    Date beforeStart = new Date(cal.getTime().getTime());
	    cal.add(Calendar.HOUR, 2);
	    Date start2 = new Date(cal.getTime().getTime());
	    cal.add(Calendar.HOUR, 1);
	    Date start3 = new Date(cal.getTime().getTime());
	    cal.add(Calendar.HOUR, 1);
	    Date start4 = new Date(cal.getTime().getTime());
	    
//	    DateUtil.setHms(cal2, cal2.get(Calendar.HOUR_OF_DAY)-1, 0, 0, 000);
//	    DateUtil.setHms(cal2, cal2.get(Calendar.HOUR_OF_DAY) + 1, 0, 0, 000);
	    DateUtil.setHms(cal2, -1, 59, 59, 999);
	    cal2.add(Calendar.HOUR, -9);
	    Date end = new Date(cal2.getTime().getTime());
	    cal2.add(Calendar.HOUR, -1);
	    Date beforeEnd = new Date(cal2.getTime().getTime());
	    cal2.add(Calendar.HOUR, 2);
	    Date end2 = new Date(cal2.getTime().getTime());
	    cal2.add(Calendar.HOUR, 1);
	    Date end3 = new Date(cal2.getTime().getTime());
	    cal2.add(Calendar.HOUR, 1);
	    Date end4 = new Date(cal2.getTime().getTime());
	    
	    System.out.println("before   "+beforeStart+", "+beforeEnd);
	  System.out.println("start            "+start+", "+end);
	  System.out.println("start2  "+start2+", "+end2);
	  System.out.println("start3     "+start3+", "+end3);
	  System.out.println("start4     "+start4+", "+end4);
	  
	  try {
		  CblResponseModel cbl = EnertalkApiUtil.getCBL(siteId, beforeStart, beforeEnd, prettyLog);
		  prettyLog.append("RESULT      ", JsonUtil.toJson(cbl));
		  CblResponseModel cbl2 = EnertalkApiUtil.getCBL(siteId, start, end, prettyLog);
		  prettyLog.append("RESULT2      ", JsonUtil.toJson(cbl2));
		  CblResponseModel cbl3 = EnertalkApiUtil.getCBL(siteId, start2, end2, prettyLog);
		  prettyLog.append("RESULT3      ", JsonUtil.toJson(cbl3));
		  CblResponseModel cbl4 = EnertalkApiUtil.getCBL(siteId, start3, end3, prettyLog);
		  prettyLog.append("RESULT4      ", JsonUtil.toJson(cbl4));
		  CblResponseModel cbl5 = EnertalkApiUtil.getCBL(siteId, start4, end4, prettyLog);
		  prettyLog.append("RESULT5      ", JsonUtil.toJson(cbl5));
	  } finally {
		  prettyLog.stop();
		  System.out.println(prettyLog.prettyPrint());
	  }
  }
}
