package kr.co.ewp.api.util;

import java.util.Date;
import java.util.List;

import org.springframework.http.HttpHeaders;

import com.fasterxml.jackson.core.type.TypeReference;

import kr.co.ewp.api.model.BmsEquipmentModel;
import kr.co.ewp.api.model.BmsEquipmentModelBefore;
import kr.co.ewp.api.model.ChargingDischargingBefore;
import kr.co.ewp.api.model.ChargingDischargingScheduleBefore;
import kr.co.ewp.api.model.EssUsageModel;
import kr.co.ewp.api.model.PcsEquipmentModel;
import kr.co.ewp.api.model.PcsEquipmentModelBefore;
import kr.co.ewp.api.model.PvEquipmentModel;
import kr.co.ewp.api.model.PvEquipmentModelBefore;
import kr.co.ewp.api.model.PvPowerGenModelBefore;
import kr.co.ewp.api.model.SocModel;

public class PMGrowApiUtilBefore {
  private static final String API_VERSION = "2.0.0";
  private static final String API_ACCESS_TOKEN = "<access_token>";

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
  public static ChargingDischargingBefore getEssCharge(String host, String equipmentId, Date startDt, Date endDt, String intervalType, String interval, PrettyLog prettyLog) {
    prettyLog.start("PMGrowApiUtilBefore.getEssCharge", "ERROR");
    String resultBody = null;
    try {
      StringBuffer url = new StringBuffer(host + "/openapi/equipment-charging-discharging-list");
      url.append("?pcsId=").append(equipmentId);
      url.append("&startDt=").append(startDt.getTime());
      url.append("&endDt=").append(endDt.getTime());
      url.append("&intervalType=").append(intervalType);
      url.append("&interval=").append(interval);

      System.out.println(equipmentId+" ESS충방전량 조회 url  ==>  "+url);
      prettyLog.append("URL", url);
      resultBody = HttpUtil.get(url.toString(), getHeaders());
      System.out.println(equipmentId+" ESS충방전량 조회 resultBody  ==>  "+resultBody);
      return JsonUtil.toObject(resultBody, ChargingDischargingBefore.class);
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
  public static ChargingDischargingScheduleBefore getEssChargePlan(String host, String equipmentId, Date startDt, Date endDt, String intervalType, String interval, PrettyLog prettyLog) {
    prettyLog.start("PMGrowApiUtilBefore.getEssChargePlan", "ERROR");
    String resultBody = null;
    try {
      StringBuffer url = new StringBuffer(host + "/openapi/charging-discharging-schedule-list");
      url.append("?pcsId=").append(equipmentId);
      url.append("&startDt=").append(startDt.getTime());
      url.append("&endDt=").append(endDt.getTime());
      url.append("&intervalType=").append(intervalType);
      url.append("&interval=").append(interval);

      System.out.println(equipmentId+" ESS충방전계획량 조회 url  ==>  "+url);
      prettyLog.append("URL", url);
      resultBody = HttpUtil.get(url.toString(), getHeaders());
      System.out.println(equipmentId+" ESS충방전계획량 조회 resultBody  ==>  "+resultBody);
      return JsonUtil.toObject(resultBody, ChargingDischargingScheduleBefore.class);
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
  public static PvPowerGenModelBefore getPvPowerGenList(String host, String equipmentId, Date startDt, Date endDt, String intervalType, String interval, PrettyLog prettyLog) {
    prettyLog.start("PMGrowApiUtilBefore.getPvPowerGenList", "ERROR");
    String resultBody = null;
    try {
      StringBuffer url = new StringBuffer(host + "/openapi/pv-power-gen-list");
      url.append("?ivtId=").append(equipmentId);
      url.append("&startDt=").append(startDt.getTime());
      url.append("&endDt=").append(endDt.getTime());
      url.append("&intervalType=").append(intervalType);
      url.append("&interval=").append(interval);

      System.out.println("        "+equipmentId+" PV 발전량 조회 url  ==>  "+url);
      prettyLog.append("URL", url);
      resultBody = HttpUtil.get(url.toString(), getHeaders());
      System.out.println("     PV 발전량 조회 resultBody  ==>  "+resultBody);
      return JsonUtil.toObject(resultBody, PvPowerGenModelBefore.class);
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
  public static List<EssUsageModel> getEssUsageList(String host, String equipmentId, String startDt, String endDt, String intervalType, String interval, PrettyLog prettyLog) {
    prettyLog.start("PMGrowApiUtilBefore.getEssUsageList", "ERROR");
    String resultBody = null;
    try {
      StringBuffer url = new StringBuffer(host + "/openapi/ess-usage-list");
      url.append("?equipmentId=").append(equipmentId);
      url.append("&startDt=").append(startDt);
      url.append("&endDt=").append(endDt);
      url.append("&intervalType=").append(intervalType);
      url.append("&interval=").append(interval);
      prettyLog.append("URL", url);
      resultBody = HttpUtil.get(url.toString(), getHeaders());
      return JsonUtil.toObject(resultBody, new TypeReference<List<EssUsageModel>>() {
      });
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
  public static List<PcsEquipmentModelBefore> getPcsEquipmentList(String host, String equipmentId, PrettyLog prettyLog) {
    prettyLog.start("PMGrowApiUtilBefore.getPcsEquipmentList", "ERROR");
    String resultBody = null;
    try {
      StringBuffer url = new StringBuffer(host + "/openapi/pcs-equipment-list");
      url.append("?pcsId=").append(equipmentId);
      System.out.println("url =====> "+url);
      prettyLog.append("URL", url);
      resultBody = HttpUtil.get(url.toString(), getHeaders());
      System.out.println("pcs resultBody =====> "+resultBody);
      return JsonUtil.toObject(resultBody, new TypeReference<List<PcsEquipmentModelBefore>>() {
      });
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
  public static List<BmsEquipmentModelBefore> getBmsEquipmentList(String host, String equipmentId, PrettyLog prettyLog) {
    prettyLog.start("PMGrowApiUtilBefore.getBmsEquipmentList", "ERROR");
    String resultBody = null;
    try {
      StringBuffer url = new StringBuffer(host + "/openapi/bms-equipment-list");
      url.append("?bmsId=").append(equipmentId);
      System.out.println("url =====> "+url);
      prettyLog.append("URL", url);
      resultBody = HttpUtil.get(url.toString(), getHeaders());
      System.out.println("bms resultBody =====> "+resultBody);
      return JsonUtil.toObject(resultBody, new TypeReference<List<BmsEquipmentModelBefore>>() {
      });
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
  public static PvEquipmentModelBefore getPvEquipmentList(String host, String equipmentId, PrettyLog prettyLog) {
    prettyLog.start("PMGrowApiUtilBefore.getPvEquipmentList", "ERROR");
    String resultBody = null;
    try {
      StringBuffer url = new StringBuffer(host + "/openapi/pv-equipment-list");
      url.append("?ivtId=").append(equipmentId);
      System.out.println("url =====> "+url);
      prettyLog.append("URL", url);
      resultBody = HttpUtil.get(url.toString(), getHeaders());
      System.out.println("pcs resultBody =====> "+resultBody);
      return JsonUtil.toObject(resultBody, PvEquipmentModelBefore.class);
    } catch (Exception e) {
      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
      throw e;
    } finally {
      prettyLog.append("RESULT", resultBody);
      prettyLog.stop();
    }
  }
  
  
  public static SocModel getSoc(String host, String equipmentId, PrettyLog prettyLog) {
	  prettyLog.start("PMGrowApiUtilBefore.getSoc", "ERROR");
	  String resultBody = null;
	  try {
		  StringBuffer url = new StringBuffer(host + "/openapi/soc");
		  url.append("?equipmentId=").append(equipmentId);
		  prettyLog.append("URL", url);
		  resultBody = HttpUtil.get(url.toString(), getHeaders());
		  return JsonUtil.toObject(resultBody, SocModel.class);
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
