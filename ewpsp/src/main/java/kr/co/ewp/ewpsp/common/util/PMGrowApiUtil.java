package kr.co.ewp.ewpsp.common.util;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;

import com.fasterxml.jackson.core.type.TypeReference;

import kr.co.ewp.ewpsp.model.Soc;

public class PMGrowApiUtil {
  private static final String API_VERSION = "2.0.0";
  private static final String API_ACCESS_TOKEN = "<access_token>";
  
  private static final Logger logger = LoggerFactory.getLogger(PMGrowApiUtil.class);

//  public static String getSoc(String host, String equipmentId) {
//	  logger.debug("PMGrowApiUtil.getSoc", "ERROR");
//	  System.out.println("PMGrowApiUtil.getSoc 시작");
//    String resultBody = null;
//    try {
//      StringBuffer url = new StringBuffer(host + "/openapi/soc");
//      url.append("?equipmentId=").append(equipmentId);
//
//      logger.debug("URL은!!!! : "+ url);
//      System.out.println("URL은!!!! : "+ url);
//      resultBody = HttpUtil.get(url.toString(), getHeaders());
////      return JsonUtil.toObject(resultBody, new TypeReference<List<ChargingDischarging>>() {
////      });
//      logger.debug("api 결과는?? "+resultBody);
//      System.out.println("api 결과는?? "+resultBody);
//      return "";
//    } catch (Exception e) {
//    	e.printStackTrace();
////      throw e;
//      return "";
//    } finally {
//    	logger.debug("끗");
//    }
//  }
  public static Soc getSoc(String host, String equipmentId) {
	  logger.debug("PMGrowApiUtil.getSoc");
	  
	  String resultBody = null;
	  Soc returnSoc = null;
	  try {
//		  StringBuffer url = new StringBuffer(host + "/openapi/charging-discharging-schedule-list");
		  StringBuffer url = new StringBuffer(host + "/openapi/soc");
		  url.append("?equipmentId=").append(equipmentId);
//	      url.append("&startDt=").append("20180831");
//	      url.append("&endDt=").append("20180831");
//	      url.append("&intervalType=").append("1");
//	      url.append("&interval=").append("15");
		  
		  logger.debug("pmgrow api URL : "+ url);
		  resultBody = HttpUtil.get(url.toString(), getHeaders());
		  logger.debug("result "+resultBody);
		  returnSoc = JsonUtil.toObject(resultBody, Soc.class);
	  } catch (Exception e) {
//		  e.printStackTrace();
		  logger.error("error is : "+e.toString());
	  } finally {
		  logger.debug("PMGrowApiUtil.getSoc end");
		  return returnSoc;
	  }
  }
//  
//  /**
//   * ESS충방전량 조회
//   * 
//   * @param url
//   *          TODO
//   * @param equipmentId
//   * @param startDt
//   *          yyyyMMdd
//   * @param endDt
//   *          yyyyMMdd
//   * @param intervalType
//   * @param interval
//   * @param prettyLog
//   * 
//   * @return
//   */
//  public static List<ChargingDischarging> getEssCharge(String host, String equipmentId, String startDt, String endDt, String intervalType, String interval, PrettyLog prettyLog) {
//	  prettyLog.start("PMGrowApiUtil.getEssCharge", "ERROR");
//	  String resultBody = null;
//	  try {
//		  StringBuffer url = new StringBuffer(host + "/openapi/equipment-charging-discharging-list");
//		  url.append("?equipmentId=").append(equipmentId);
//		  url.append("&startDt=").append(startDt);
//		  url.append("&endDt=").append(endDt);
//		  url.append("&intervalType=").append(intervalType);
//		  url.append("&interval=").append(interval);
//		  
//		  prettyLog.append("URL", url);
//		  resultBody = HttpUtil.get(url.toString(), getHeaders());
//		  return JsonUtil.toObject(resultBody, new TypeReference<List<ChargingDischarging>>() {
//		  });
//	  } catch (Exception e) {
//		  prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
//		  throw e;
//	  } finally {
//		  prettyLog.append("RESULT", resultBody);
//		  prettyLog.stop();
//	  }
//  }
//
//  /**
//   * ESS충방전계획량 조회
//   * 
//   * @param equipmentId
//   * @param startDt
//   *          yyyyMMdd
//   * @param endDt
//   *          yyyyMMdd
//   * @param intervalType
//   * @param interval
//   * @param prettyLog
//   * @return
//   */
//  public static List<ChargingDischargingSchedule> getEssChargePlan(String host, String equipmentId, String startDt, String endDt, String intervalType, String interval, PrettyLog prettyLog) {
//    prettyLog.start("PMGrowApiUtil.getEssChargePlan", "ERROR");
//    String resultBody = null;
//    try {
//      StringBuffer url = new StringBuffer(host + "/openapi/charging-discharging-schedule-list");
//      url.append("?equipmentId=").append(equipmentId);
//      url.append("&startDt=").append(startDt);
//      url.append("&endDt=").append(endDt);
//      url.append("&intervalType=").append(intervalType);
//      url.append("&interval=").append(interval);
//
//      prettyLog.append("URL", url);
//      resultBody = HttpUtil.get(url.toString(), getHeaders());
//      return JsonUtil.toObject(resultBody, new TypeReference<List<ChargingDischargingSchedule>>() {
//      });
//    } catch (Exception e) {
//      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
//      throw e;
//    } finally {
//      prettyLog.append("RESULT", resultBody);
//      prettyLog.stop();
//    }
//  }
//
//  /**
//   * PV 발전량 조회
//   * 
//   * @param equipmentId
//   * @param startDt
//   *          yyyyMMdd
//   * @param endDt
//   *          yyyyMMdd
//   * @param intervalType
//   * @param interval
//   * @param prettyLog
//   * @return
//   */
//  public static List<PvPowerGenModel> getPvPowerGenList(String host, String equipmentId, String startDt, String endDt, String intervalType, String interval, PrettyLog prettyLog) {
//    prettyLog.start("PMGrowApiUtil.getPvPowerGenList", "ERROR");
//    String resultBody = null;
//    try {
//      StringBuffer url = new StringBuffer(host + "/openapi/pv-power-gen-list");
//      url.append("?equipmentId=").append(equipmentId);
//      url.append("&startDt=").append(startDt);
//      url.append("&endDt=").append(endDt);
//      url.append("&intervalType=").append(intervalType);
//      url.append("&interval=").append(interval);
//
//      prettyLog.append("URL", url);
//      resultBody = HttpUtil.get(url.toString(), getHeaders());
//      return JsonUtil.toObject(resultBody, new TypeReference<List<PvPowerGenModel>>() {
//      });
//    } catch (Exception e) {
//      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
//      throw e;
//    } finally {
//      prettyLog.append("RESULT", resultBody);
//      prettyLog.stop();
//    }
//  }
//
//  /**
//   * ESS 사용량 조회
//   * 
//   * @param equipmentId
//   * @param startDt
//   *          yyyyMMdd
//   * @param endDt
//   *          yyyyMMdd
//   * @param intervalType
//   * @param interval
//   * @param prettyLog
//   * @return
//   */
//  public static List<EssUsageModel> getEssUsageList(String host, String equipmentId, String startDt, String endDt, String intervalType, String interval, PrettyLog prettyLog) {
//    prettyLog.start("PMGrowApiUtil.getEssUsageList", "ERROR");
//    String resultBody = null;
//    try {
//      StringBuffer url = new StringBuffer(host + "/openapi/ess-usage-list");
//      url.append("?equipmentId=").append(equipmentId);
//      url.append("&startDt=").append(startDt);
//      url.append("&endDt=").append(endDt);
//      url.append("&intervalType=").append(intervalType);
//      url.append("&interval=").append(interval);
//      prettyLog.append("URL", url);
//      resultBody = HttpUtil.get(url.toString(), getHeaders());
//      return JsonUtil.toObject(resultBody, new TypeReference<List<EssUsageModel>>() {
//      });
//    } catch (Exception e) {
//      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
//      throw e;
//    } finally {
//      prettyLog.append("RESULT", resultBody);
//      prettyLog.stop();
//    }
//  }
//
//  /**
//   * PCS 운전상태 조회
//   * 
//   * @param equipmentId
//   * @param startDt
//   *          yyyyMMdd
//   * @param endDt
//   *          yyyyMMdd
//   * @param intervalType
//   * @param interval
//   * @param prettyLog
//   * @return
//   */
//  public static List<PcsEquipmentModel> getPcsEquipmentList(String host, String equipmentId, PrettyLog prettyLog) {
//    prettyLog.start("PMGrowApiUtil.getPcsEquipmentList", "ERROR");
//    String resultBody = null;
//    try {
//      StringBuffer url = new StringBuffer(host + "/openapi/pcs-equipment-list");
//      url.append("?equipmentId=").append(equipmentId);
//      prettyLog.append("URL", url);
//      resultBody = HttpUtil.get(url.toString(), getHeaders());
//      return JsonUtil.toObject(resultBody, new TypeReference<List<PcsEquipmentModel>>() {
//      });
//    } catch (Exception e) {
//      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
//      throw e;
//    } finally {
//      prettyLog.append("RESULT", resultBody);
//      prettyLog.stop();
//    }
//  }
//
//  /**
//   * BMS 운전상태 조회
//   * 
//   * @param equipmentId
//   * @param startDt
//   *          yyyyMMdd
//   * @param endDt
//   *          yyyyMMdd
//   * @param intervalType
//   * @param interval
//   * @param prettyLog
//   * @return
//   */
//  public static List<BmsEquipmentModel> getBmsEquipmentList(String host, String equipmentId, PrettyLog prettyLog) {
//    prettyLog.start("PMGrowApiUtil.getPcsEquipmentList", "ERROR");
//    String resultBody = null;
//    try {
//      StringBuffer url = new StringBuffer(host + "/openapi/bms-equipment-list");
//      url.append("?equipmentId=").append(equipmentId);
//      prettyLog.append("URL", url);
//      resultBody = HttpUtil.get(url.toString(), getHeaders());
//      return JsonUtil.toObject(resultBody, new TypeReference<List<BmsEquipmentModel>>() {
//      });
//    } catch (Exception e) {
//      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
//      throw e;
//    } finally {
//      prettyLog.append("RESULT", resultBody);
//      prettyLog.stop();
//    }
//  }
//
//  /**
//   * PV 운전상태 조회
//   * 
//   * @param equipmentId
//   * @param startDt
//   *          yyyyMMdd
//   * @param endDt
//   *          yyyyMMdd
//   * @param intervalType
//   * @param interval
//   * @param prettyLog
//   * @return
//   */
//  public static List<PvEquipmentModel> getPvEquipmentList(String host, String equipmentId, PrettyLog prettyLog) {
//    prettyLog.start("PMGrowApiUtil.getPvEquipmentList", "ERROR");
//    String resultBody = null;
//    try {
//      StringBuffer url = new StringBuffer(host + "/openapi/pv-equipment-list");
//      url.append("?equipmentId=").append(equipmentId);
//      prettyLog.append("URL", url);
//      resultBody = HttpUtil.get(url.toString(), getHeaders());
//      return JsonUtil.toObject(resultBody, new TypeReference<List<PvEquipmentModel>>() {
//      });
//    } catch (Exception e) {
//      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
//      throw e;
//    } finally {
//      prettyLog.append("RESULT", resultBody);
//      prettyLog.stop();
//    }
//  }

  private static HttpHeaders getHeaders() {
    HttpHeaders headers = new HttpHeaders();
    headers.set("authorization", "Bearer  " + API_ACCESS_TOKEN);
    headers.set("accept-version", API_VERSION);
    return headers;
  }
}
