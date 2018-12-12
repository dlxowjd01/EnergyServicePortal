package kr.co.ewp.api.util;

import java.util.Date;
import java.util.List;

import kr.co.ewp.api.model.BmsEquipmentModel;
import kr.co.ewp.api.model.ChargingDischarging;
import kr.co.ewp.api.model.EssUsageModel;
import kr.co.ewp.api.model.PcsEquipmentModel;
import kr.co.ewp.api.model.PvEquipmentModel;
import kr.co.ewp.api.model.PvPowerGenModel;
import kr.co.ewp.api.model.SocModel;

public class PMGrowApiUtilTest {
//  public static final String API_HOST = "http://112.219.230.170:42000";
  public static final String API_HOST = "https://13.125.50.136";

  public static void main(String[] args) {
    // adf4537b: ESS 측정
    // 0dbe72b9: 총량 측정
	  String deviceId = "1";
//	  getEssChargeTest();
//	  getPvGenListTest(deviceId);
    getPcsEquipmentListTest(deviceId);
//    getBmsEquipmentListTest(deviceId);
//    getPvEquipmentListTest(deviceId);
//    getSoc("3");
  }

  public static void getEssChargeTest() {
    PrettyLog prettyLog = new PrettyLog("getEssChargeTest");
    try {
      String equipmentId = "1";
      Date startDt = new Date(Long.parseLong("1533481200000"));//"20180806";
      Date endDt = new Date(Long.parseLong("1533826800000"));//"20180810";
//      String startDt = "20180806";
//      String endDt = "20180810";
      String intervalType = "1";
      String interval = "15";
      ChargingDischarging chargingDischargingList = PMGrowApiUtil.getEssCharge(API_HOST, equipmentId, startDt, endDt, intervalType, interval, prettyLog);
      prettyLog.append("RESULT", JsonUtil.toJson(chargingDischargingList));
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }

  public static void getEssUsageListTest() {
    PrettyLog prettyLog = new PrettyLog("getEssUsageListTest");
    try {
      String equipmentId = "0dbe72b9";
      Date startDt = new Date(Long.parseLong("1535727600000"));//"20180901";
      Date endDt = new Date(Long.parseLong("1536159600000"));//"20180906";
//      String startDt = "20180901";
//      String endDt = "20180906";
      String intervalType = "1";
      String interval = "15";
      List<EssUsageModel> chargingDischargingList = PMGrowApiUtil.getEssUsageList(API_HOST, equipmentId, startDt, endDt, intervalType, interval, prettyLog);
      prettyLog.append("RESULT", JsonUtil.toJson(chargingDischargingList));
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }
  
  public static void getPvGenListTest(String equipmentId) {
	  PrettyLog prettyLog = new PrettyLog("getPvGenListTest");
	  try {
//		  String equipmentId = "0dbe72b9";
		  Date startDt = new Date(Long.parseLong("1535727600000"));//"20180901";
	      Date endDt = new Date(Long.parseLong("1536159600000"));//"20180906";
//		  String startDt = "20180901";
//		  String endDt = "20180906";
		  String intervalType = "1";
		  String interval = "15";
		  PvPowerGenModel resultList = PMGrowApiUtil.getPvPowerGenList(API_HOST, equipmentId, startDt, endDt, "1", "15", prettyLog);
		  prettyLog.append("RESULT", JsonUtil.toJson(resultList));
	  } finally {
		  prettyLog.stop();
		  System.out.println(prettyLog.prettyPrint());
	  }
  }

  public static void getPcsEquipmentListTest(String deviceId) {
    PrettyLog prettyLog = new PrettyLog("getPcsEquipmentListTest");
    try {
//      String equipmentId = "d93e28eb";
      String equipmentId = deviceId;
      List<PcsEquipmentModel> pcsEquipmentModelList = PMGrowApiUtil.getPcsEquipmentList(API_HOST, equipmentId, prettyLog);
      prettyLog.append("RESULT", JsonUtil.toJson(pcsEquipmentModelList));
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }
  
  public static void getBmsEquipmentListTest(String deviceId) {
	  PrettyLog prettyLog = new PrettyLog("getBmsEquipmentListTest");
	  try {
		  String equipmentId = deviceId;
		  List<BmsEquipmentModel> pcsEquipmentModelList = PMGrowApiUtil.getBmsEquipmentList(API_HOST, equipmentId, prettyLog);
		  prettyLog.append("RESULT", JsonUtil.toJson(pcsEquipmentModelList));
	  } finally {
		  prettyLog.stop();
		  System.out.println(prettyLog.prettyPrint());
	  }
  }
  
  public static void getPvEquipmentListTest(String deviceId) {
	  PrettyLog prettyLog = new PrettyLog("getPvEquipmentListTest");
	  try {
		  String equipmentId = deviceId;
		  List<PvEquipmentModel> pcsEquipmentModelList = PMGrowApiUtil.getPvEquipmentList(API_HOST, equipmentId, prettyLog);
		  prettyLog.append("RESULT", JsonUtil.toJson(pcsEquipmentModelList));
	  } finally {
		  prettyLog.stop();
		  System.out.println(prettyLog.prettyPrint());
	  }
  }
  
  public static void getSoc(String deviceId) {
	  PrettyLog prettyLog = new PrettyLog("getPvEquipmentListTest");
	  try {
		  String equipmentId = deviceId;
		  SocModel pcsEquipmentModelList = PMGrowApiUtil.getSoc(API_HOST, equipmentId, prettyLog);
		  prettyLog.append("RESULT", JsonUtil.toJson(pcsEquipmentModelList));
	  } finally {
		  prettyLog.stop();
		  System.out.println(prettyLog.prettyPrint());
	  }
  }
}
