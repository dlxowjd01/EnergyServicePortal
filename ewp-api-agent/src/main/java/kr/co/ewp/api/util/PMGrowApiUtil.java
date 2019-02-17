package kr.co.ewp.api.util;

import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;

import com.fasterxml.jackson.core.type.TypeReference;

import kr.co.ewp.api.aop.DaoAspect;
import kr.co.ewp.api.model.BmsEquipmentModel;
import kr.co.ewp.api.model.ChargingDischarging;
import kr.co.ewp.api.model.ChargingDischargingSchedule;
import kr.co.ewp.api.model.EssUsageModel;
import kr.co.ewp.api.model.PcsEquipmentModel;
import kr.co.ewp.api.model.PvEquipmentModel;
import kr.co.ewp.api.model.PvPowerGenModel;
import kr.co.ewp.api.model.SocModel;

public class PMGrowApiUtil {
  private static final String API_VERSION = "2.0.0";
  private static final String API_ACCESS_TOKEN = "<access_token>";
  private static final Logger logger = LoggerFactory.getLogger(PMGrowApiUtil.class);

  /**
   * ESS충방전량 조회
   * 
   * @param url
   *          TODO
   * @param equipmentId
   * @param startDt
   *          yyyyMMdd
   * @param endDt
   *          yyyyMMdd
   * @param intervalType
   * @param interval
   * @param prettyLog
   * 
   * @return
   */
  public static ChargingDischarging getEssCharge(String host, String equipmentId, Date startDt, Date endDt, String intervalType, String interval, PrettyLog prettyLog) {
	  prettyLog.start("PMGrowApiUtil.getEssCharge", "ERROR");
	  String resultBody = null;
	  try {
		  StringBuffer url = new StringBuffer(host + "/v1/pcses/:pcsId/energy".replace(":pcsId", equipmentId));
//		  url.append("?equipmentId=").append(equipmentId);
		  url.append("?startDt=").append(startDt.getTime());
		  url.append("&endDt=").append(endDt.getTime());
		  url.append("&intervalType=").append(intervalType);
		  url.append("&interval=").append(interval);
		  
		  System.out.println(equipmentId+" ESS충방전량 조회 url  ==>  "+url);
		  prettyLog.append("URL", url);
		  resultBody = HttpUtil.get(url.toString(), getHeaders());
		  System.out.println(equipmentId+" ESS충방전량 조회 resultBody  ==>  "+resultBody);
		  return JsonUtil.toObject(resultBody, ChargingDischarging.class);
	  } catch (NullPointerException e) {
	  	  logger.error("error is : "+e.toString());
	  	  throw e;
	  } catch (Exception e) {
		  prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
		  throw e;
	  } finally {
		  prettyLog.append("RESULT", resultBody);
		  prettyLog.stop();
	  }
  }

  /**
   * ESS충방전계획량 조회
   * 
   * @param equipmentId
   * @param startDt
   *          yyyyMMdd
   * @param endDt
   *          yyyyMMdd
   * @param intervalType
   * @param interval
   * @param prettyLog
   * @return
   */
  public static ChargingDischargingSchedule getEssChargePlan(String host, String equipmentId, Date startDt, Date endDt, String intervalType, String interval, PrettyLog prettyLog) {
	  prettyLog.start("PMGrowApiUtil.getEssChargePlan", "ERROR");
	  String resultBody = null;
	  try {
		  StringBuffer url = new StringBuffer(host + "/v1/pcses/:pcsId/schedule".replace(":pcsId", equipmentId));
//		  url.append("?equipmentId=").append(equipmentId);
		  url.append("?startDt=").append(startDt.getTime());
		  url.append("&endDt=").append(endDt.getTime());
		  url.append("&intervalType=").append(intervalType);
		  url.append("&interval=").append(interval);
		  
		  System.out.println(equipmentId+" ESS충방전계획량 조회 url  ==>  "+url);
		  prettyLog.append("URL", url);
		  resultBody = HttpUtil.get(url.toString(), getHeaders());
		  System.out.println(equipmentId+" ESS충방전계획량 조회 resultBody  ==>  "+resultBody);
		  return JsonUtil.toObject(resultBody, ChargingDischargingSchedule.class);
	  } catch (NullPointerException e) {
	  	  logger.error("error is : "+e.toString());
	  	  throw e;
	  } catch (Exception e) {
		  prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
		  throw e;
	  } finally {
		  prettyLog.append("RESULT", resultBody);
		  prettyLog.stop();
	  }
  }

  /**
   * PV 발전량 조회
   * 
   * @param equipmentId
   * @param startDt
   *          yyyyMMdd
   * @param endDt
   *          yyyyMMdd
   * @param intervalType
   * @param interval
   * @param prettyLog
   * @return
   */
  public static PvPowerGenModel getPvPowerGenList(String host, String equipmentId, Date startDt, Date endDt, String intervalType, String interval, PrettyLog prettyLog) {
	  System.out.println("localems pv4444");
	  prettyLog.start("PMGrowApiUtil.getPvPowerGenList", "ERROR");
	  String resultBody = null;
	  try {
		  StringBuffer url = new StringBuffer(host + "/v1/ivtes/:ivtId/energy".replace(":ivtId", equipmentId));
//		  url.append("?equipmentId=").append(equipmentId);
		  url.append("?startDt=").append(startDt.getTime());
		  url.append("&endDt=").append(endDt.getTime());
		  url.append("&intervalType=").append(intervalType);
		  url.append("&interval=").append(interval);
		  
		  System.out.println(equipmentId+" PV 발전량 조회 url  ==>  "+url);
		  prettyLog.append("URL", url);
		  resultBody = HttpUtil.get(url.toString(), getHeaders());
		  System.out.println(equipmentId+" PV 발전량 조회 resultBody  ==>  "+resultBody);
		  return JsonUtil.toObject(resultBody, PvPowerGenModel.class);
	  } catch (NullPointerException e) {
	  	  logger.error("error is : "+e.toString());
	  	  throw e;
	  } catch (Exception e) {
		  prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
		  throw e;
	  } finally {
		  prettyLog.append("RESULT", resultBody);
		  prettyLog.stop();
	  }
  }

  /**
   * ESS 사용량 조회
   * 
   * @param equipmentId
   * @param startDt
   *          yyyyMMdd
   * @param endDt
   *          yyyyMMdd
   * @param intervalType
   * @param interval
   * @param prettyLog
   * @return
   */
  public static List<EssUsageModel> getEssUsageList(String host, String equipmentId, Date startDt, Date endDt, String intervalType, String interval, PrettyLog prettyLog) {
	    prettyLog.start("PMGrowApiUtil.getEssUsageList", "ERROR");
	    String resultBody = null;
	    try {
	      StringBuffer url = new StringBuffer(host + "/v1/pcses/:pcsId/energy".replace(":pcsId", equipmentId));
//	      url.append("?equipmentId=").append(equipmentId);
	      url.append("?startDt=").append(startDt.getTime());
	      url.append("&endDt=").append(endDt.getTime());
	      url.append("&intervalType=").append(intervalType);
	      url.append("&interval=").append(interval);
	      prettyLog.append("URL", url);
	      resultBody = HttpUtil.get(url.toString(), getHeaders());
	      return JsonUtil.toObject(resultBody, new TypeReference<List<EssUsageModel>>() {
	      });
	    } catch (NullPointerException e) {
		  	  logger.error("error is : "+e.toString());
		  	  throw e;
	    } catch (Exception e) {
	      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
	      throw e;
	    } finally {
	      prettyLog.append("RESULT", resultBody);
	      prettyLog.stop();
	    }
	  }

  /**
   * PCS 운전상태 조회
   * 
   * @param equipmentId
   * @param startDt
   *          yyyyMMdd
   * @param endDt
   *          yyyyMMdd
   * @param intervalType
   * @param interval
   * @param prettyLog
   * @return
   */
  public static PcsEquipmentModel getPcsEquipmentList(String host, String equipmentId, PrettyLog prettyLog) {
	    prettyLog.start("PMGrowApiUtil.getPcsEquipmentList", "ERROR");
	    System.out.println("pcs 운전상태 조회");
	    String resultBody = null;
	    try {
	      StringBuffer url = new StringBuffer(host + "/v1/pcses/:pcsId/current".replace(":pcsId", equipmentId));
	      System.out.println("url =====> "+url);
	      prettyLog.append("URL", url);
	      resultBody = HttpUtil.get(url.toString(), getHeaders());
	      System.out.println("pcs resultBody =====> "+resultBody);
	      return JsonUtil.toObject(resultBody, PcsEquipmentModel.class);
	    } catch (NullPointerException e) {
		  	  logger.error("error is : "+e.toString());
		  	  throw e;
	    } catch (Exception e) {
	      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
	      throw e;
	    } finally {
	      prettyLog.append("RESULT", resultBody);
	      prettyLog.stop();
	    }
	  }

  /**
   * BMS 운전상태 조회
   * 
   * @param equipmentId
   * @param startDt
   *          yyyyMMdd
   * @param endDt
   *          yyyyMMdd
   * @param intervalType
   * @param interval
   * @param prettyLog
   * @return
   */
  public static List<BmsEquipmentModel> getBmsEquipmentList(String host, String equipmentId, PrettyLog prettyLog) {
	  prettyLog.start("PMGrowApiUtil.getBmsEquipmentList", "ERROR");
	  System.out.println("bms 운전상태 조회");
	  String resultBody = null;
	  try {
		  StringBuffer url = new StringBuffer(host + "/v1/bmses/:bmsId/current".replace(":bmsId", equipmentId));
		  System.out.println("url =====> "+url);
		  prettyLog.append("URL", url);
		  resultBody = HttpUtil.get(url.toString(), getHeaders());
		  System.out.println("bms resultBody =====> "+resultBody);
		  return JsonUtil.toObject(resultBody, new TypeReference<List<BmsEquipmentModel>>() {
		  });
	  } catch (NullPointerException e) {
	  	  logger.error("error is : "+e.toString());
	  	  throw e;
	  } catch (Exception e) {
		  prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
		  throw e;
	  } finally {
		  prettyLog.append("RESULT", resultBody);
		  prettyLog.stop();
	  }
  }

  /**
   * PV 운전상태 조회
   * 
   * @param equipmentId
   * @param startDt
   *          yyyyMMdd
   * @param endDt
   *          yyyyMMdd
   * @param intervalType
   * @param interval
   * @param prettyLog
   * @return
   */
  public static List<PvEquipmentModel> getPvEquipmentList(String host, String equipmentId, PrettyLog prettyLog) {
	  prettyLog.start("PMGrowApiUtil.getPvEquipmentList", "ERROR");
	  String resultBody = null;
	  try {
		  StringBuffer url = new StringBuffer(host + "/v1/ivtes/:ivtId/current".replace(":ivtId", equipmentId));
		  System.out.println("url =====> "+url);
		  prettyLog.append("URL", url);
		  resultBody = HttpUtil.get(url.toString(), getHeaders());
		  System.out.println("pv resultBody =====> "+resultBody);
		  return JsonUtil.toObject(resultBody, new TypeReference<List<PvEquipmentModel>>() {
		  });
	  } catch (NullPointerException e) {
		  logger.error("error is : "+e.toString());
		  throw e;
	  } catch (Exception e) {
		  prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
		  throw e;
	  } finally {
		  prettyLog.append("RESULT", resultBody);
		  prettyLog.stop();
	  }
  }
  
  
  public static SocModel getSoc(String host, String equipmentId, PrettyLog prettyLog) {
	  prettyLog.start("PMGrowApiUtil.getSoc", "ERROR");
	  String resultBody = null;
	  try {
		  StringBuffer url = new StringBuffer(host + "/openapi/soc");
		  url.append("?equipmentId=").append(equipmentId);
		  prettyLog.append("URL", url);
		  resultBody = HttpUtil.get(url.toString(), getHeaders());
		  return JsonUtil.toObject(resultBody, SocModel.class);
	  } catch (NullPointerException e) {
	  	  logger.error("error is : "+e.toString());
	  	  throw e;
	  } catch (Exception e) {
		  prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
		  throw e;
	  } finally {
		  prettyLog.append("RESULT", resultBody);
		  prettyLog.stop();
	  }
  }

  private static HttpHeaders getHeaders() {
    HttpHeaders headers = new HttpHeaders();
//    headers.set("authorization", "Bearer  " + API_ACCESS_TOKEN);
    headers.set("Authorization", "Basic  " + "bG9jYWwtZW1zOmxvY2FsLWVtcw==");
    headers.set("accept-version", API_VERSION);
    return headers;
  }
}
