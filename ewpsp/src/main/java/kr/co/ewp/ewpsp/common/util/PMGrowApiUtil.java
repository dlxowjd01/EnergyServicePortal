package kr.co.ewp.ewpsp.common.util;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;

import com.fasterxml.jackson.core.type.TypeReference;

import kr.co.ewp.ewpsp.model.BmsEquipmentModel;
import kr.co.ewp.ewpsp.model.PcsEquipmentModel;
import kr.co.ewp.ewpsp.model.PvEquipmentModel;
import kr.co.ewp.ewpsp.model.SocModel;

public class PMGrowApiUtil {
  private static final String API_VERSION = "2.0.0";
  private static final String API_ACCESS_TOKEN = "<access_token>";
  
  private static final Logger logger = LoggerFactory.getLogger(PMGrowApiUtil.class);


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
  public static List<PcsEquipmentModel> getPcsEquipmentList(String host, String equipmentId) {
	  logger.debug("PMGrowApiUtil.getPcsEquipmentList");
    String resultBody = null;
    List<PcsEquipmentModel> returnPCS = null;
    try {
      StringBuffer url = new StringBuffer(host + "/pcses/:pcsId/current".replace(":pcsId", equipmentId));
      url.append("?equipmentId=").append(equipmentId);
      logger.debug("pmgrow api URL : "+ url);
      resultBody = HttpUtil.get(url.toString(), getHeaders());
      logger.debug("result "+resultBody);
      returnPCS = JsonUtil.toObject(resultBody, new TypeReference<List<PcsEquipmentModel>>() {
      });
    } catch (Exception e) {
//    	e.printStackTrace();
		logger.error("error is : "+e.toString());
    } finally {
    	logger.debug("PMGrowApiUtil.getPcsEquipmentList end");
		return returnPCS;
    }
  }
//  public static List<PcsEquipmentModel> getPcsEquipmentList(String host, String equipmentId) {
//	  logger.debug("PMGrowApiUtil.getPcsEquipmentList");
//	  String resultBody = null;
//	  List<PcsEquipmentModel> returnPCS = null;
//	  try {
//		  StringBuffer url = new StringBuffer(host + "/openapi/pcs-equipment-list");
//		  url.append("?equipmentId=").append(equipmentId);
//		  logger.debug("pmgrow api URL : "+ url);
//		  resultBody = HttpUtil.get(url.toString(), getHeaders());
//		  logger.debug("result "+resultBody);
//		  returnPCS = JsonUtil.toObject(resultBody, new TypeReference<List<PcsEquipmentModel>>() {
//		  });
//	  } catch (Exception e) {
////    	e.printStackTrace();
//		  logger.error("error is : "+e.toString());
//	  } finally {
//		  logger.debug("PMGrowApiUtil.getPcsEquipmentList end");
//		  return returnPCS;
//	  }
//  }

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
  public static List<BmsEquipmentModel> getBmsEquipmentList(String host, String equipmentId) {
	logger.debug("PMGrowApiUtil.getBmsEquipmentList");
    String resultBody = null;
    List<BmsEquipmentModel> returnBMS = null;
    try {
    	StringBuffer url = new StringBuffer(host + "/bmses/:bmsId/current".replace(":bmsId", equipmentId));
      url.append("?equipmentId=").append(equipmentId);
      logger.debug("pmgrow api URL : "+ url);
      resultBody = HttpUtil.get(url.toString(), getHeaders());
      logger.debug("result "+resultBody);
      returnBMS = JsonUtil.toObject(resultBody, new TypeReference<List<BmsEquipmentModel>>() {
      });
    } catch (Exception e) {
//    	e.printStackTrace();
		logger.error("error is : "+e.toString());
    } finally {
    	logger.debug("PMGrowApiUtil.getBmsEquipmentList end");
		return returnBMS;
    }
  }
//  public static List<BmsEquipmentModel> getBmsEquipmentList(String host, String equipmentId) {
//	  logger.debug("PMGrowApiUtil.getBmsEquipmentList");
//	  String resultBody = null;
//	  List<BmsEquipmentModel> returnBMS = null;
//	  try {
//		  StringBuffer url = new StringBuffer(host + "/openapi/bms-equipment-list");
//		  url.append("?equipmentId=").append(equipmentId);
//		  logger.debug("pmgrow api URL : "+ url);
//		  resultBody = HttpUtil.get(url.toString(), getHeaders());
//		  logger.debug("result "+resultBody);
//		  returnBMS = JsonUtil.toObject(resultBody, new TypeReference<List<BmsEquipmentModel>>() {
//		  });
//	  } catch (Exception e) {
////    	e.printStackTrace();
//		  logger.error("error is : "+e.toString());
//	  } finally {
//		  logger.debug("PMGrowApiUtil.getBmsEquipmentList end");
//		  return returnBMS;
//	  }
//  }

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
  public static List<PvEquipmentModel> getPvEquipmentList(String host, String equipmentId) {
    logger.debug("PMGrowApiUtil.getPvEquipmentList");
    String resultBody = null;
    List<PvEquipmentModel> returnPV = null;
    try {
    	StringBuffer url = new StringBuffer(host + "/pcses/:ivtId/current".replace(":ivtId", equipmentId));
      url.append("?equipmentId=").append(equipmentId);
      logger.debug("pmgrow api URL : "+ url);
      resultBody = HttpUtil.get(url.toString(), getHeaders());
      logger.debug("result "+resultBody);
      returnPV = JsonUtil.toObject(resultBody, new TypeReference<List<PvEquipmentModel>>() {
      });
    } catch (Exception e) {
    	e.printStackTrace();
		logger.error("error is : "+e.toString());
    } finally {
    	logger.debug("PMGrowApiUtil.getPvEquipmentList end");
		return returnPV;
    }
  }
//  public static List<PvEquipmentModel> getPvEquipmentList(String host, String equipmentId) {
//	  logger.debug("PMGrowApiUtil.getPvEquipmentList");
//	  String resultBody = null;
//	  List<PvEquipmentModel> returnPV = null;
//	  try {
//		  StringBuffer url = new StringBuffer(host + "/openapi/pv-equipment-list");
//		  url.append("?equipmentId=").append(equipmentId);
//		  logger.debug("pmgrow api URL : "+ url);
//		  resultBody = HttpUtil.get(url.toString(), getHeaders());
//		  logger.debug("result "+resultBody);
//		  returnPV = JsonUtil.toObject(resultBody, new TypeReference<List<PvEquipmentModel>>() {
//		  });
//	  } catch (Exception e) {
////		  e.printStackTrace();
//		logger.error("error is : "+e.toString());
//	  } finally {
//		  logger.debug("PMGrowApiUtil.getPvEquipmentList end");
//		  return returnPV;
//	  }
//  }
  
  public static SocModel getSoc(String host, String equipmentId) {
	  logger.debug("PMGrowApiUtil.getSoc");
	  
	  String resultBody = null;
	  SocModel returnSoc = null;
	  try {
		  StringBuffer url = new StringBuffer(host + "/openapi/soc");
		  url.append("?equipmentId=").append(equipmentId);
		  logger.debug("pmgrow api URL : "+ url);
		  resultBody = HttpUtil.get(url.toString(), getHeaders());
		  logger.debug("result "+resultBody);
		  returnSoc = JsonUtil.toObject(resultBody, SocModel.class);
	  } catch (Exception e) {
//		  e.printStackTrace();
		  logger.error("error is : "+e.toString());
	  } finally {
		  logger.debug("PMGrowApiUtil.getSoc end");
		  return returnSoc;
	  }
  }

  private static HttpHeaders getHeaders() {
    HttpHeaders headers = new HttpHeaders();
    headers.set("authorization", "Bearer  " + API_ACCESS_TOKEN);
    headers.set("accept-version", API_VERSION);
    return headers;
  }
  
  private static HttpHeaders getHeaders2() {
	  HttpHeaders headers = new HttpHeaders();
	  headers.set("Authorization", "Basic  " + "bG9jYWwtZW1zOmxvY2FsLWVtcw==");
	  headers.set("accept-version", API_VERSION);
	  return headers;
  }
}
