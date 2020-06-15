package kr.co.ewp.ewpsp.common.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;

import kr.co.ewp.ewpsp.model.AmiEquipmentModel;
import kr.co.ewp.ewpsp.model.BmsEquipmentModel;
import kr.co.ewp.ewpsp.model.PcsEquipmentModel;
import kr.co.ewp.ewpsp.model.PvEquipmentModel;
import kr.co.ewp.ewpsp.model.SocModel;

public class PMGrowApiUtil_omni {
  private static final String API_VERSION = "2.0.0";
  private static final String API_ACCESS_TOKEN = "<access_token>";
  private static final Logger logger = LoggerFactory.getLogger(PMGrowApiUtil_omni.class);


  /**
   * PCS 운전상태 조회
   * 
   * @param equipmentId
   * @param startDt
   *          yyyyMMdd
   * @param endDt
   *          yyyyMMddd
   * @param intervalType
   * @param interval
   * @param prettyLog
   * @return
   */
  public static PcsEquipmentModel getPcsEquipmentList(String host, String equipmentId) {
	  logger.debug("PMGrowApiUtil.getPcsEquipmentList");
	    String resultBody = null;
	    PcsEquipmentModel returnPCS = null;
	    try {
	      StringBuffer url = new StringBuffer(host + "/v1/pcses/:pcsId/current".replace(":pcsId", equipmentId));
	      System.out.println("url =====> "+url);
	      logger.debug("URL", url);
	      resultBody = HttpUtil.get(url.toString(), getHeaders());
	      System.out.println("pcs resultBody =====> "+resultBody);
	      returnPCS = JsonUtil.toObject(resultBody, PcsEquipmentModel.class);
	    } catch (NullPointerException e) {
		  	  logger.error("error is : "+e.toString());
	    } catch (Exception e) {
	    	logger.error("error is : " + e.toString());
	    } finally {
	    	logger.debug("PMGrowApiUtil.getPcsEquipmentList end");
            return returnPCS;
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
  public static BmsEquipmentModel getBmsEquipmentList(String host, String equipmentId) {
	  logger.debug("PMGrowApiUtil.getBmsEquipmentList");
	  String resultBody = null;
	  BmsEquipmentModel returnBMS = null;
	  try {
		  StringBuffer url = new StringBuffer(host + "/v1/bmses/:bmsId/current".replace(":bmsId", equipmentId));
		  System.out.println("url =====> "+url);
		  logger.debug("URL", url);
		  resultBody = HttpUtil.get(url.toString(), getHeaders());
		  System.out.println("bms resultBody =====> "+resultBody);
		  returnBMS = JsonUtil.toObject(resultBody, BmsEquipmentModel.class);
	  } catch (NullPointerException e) {
		  logger.error("error is : " + e.toString());
	  } catch (Exception e) {
		  logger.error("error is : " + e.toString());
	  } finally {
		  logger.debug("PMGrowApiUtil.getBmsEquipmentList end");
          return returnBMS;
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
  public static PvEquipmentModel getPvEquipmentList(String host, String equipmentId) {
	  logger.debug("PMGrowApiUtil.getPvEquipmentList");
      String resultBody = null;
      PvEquipmentModel returnPV = null;
	  try {
		  StringBuffer url = new StringBuffer(host + "/v1/ivtes/:ivtId/current".replace(":ivtId", equipmentId));
		  System.out.println("url =====> "+url);
		  logger.debug("URL", url);
		  resultBody = HttpUtil.get(url.toString(), getHeaders());
		  System.out.println(url+"   pv resultBody =====> "+resultBody);
		  returnPV = JsonUtil.toObject(resultBody, PvEquipmentModel.class);
	  } catch (NullPointerException e) {
		  logger.error("error is : " + e.toString());
	  } catch (Exception e) {
		  logger.error("error is : " + e.toString());
	  } finally {
		  logger.debug("PMGrowApiUtil.getPvEquipmentList end");
          return returnPV;
	  }
  }
  
  /**
   * ami 운전상태 조회
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
  public static AmiEquipmentModel getAmiEquipmentList(String host, String equipmentId) {
	  logger.debug("PMGrowApiUtil.getAmiEquipmentList");
      String resultBody = null;
      AmiEquipmentModel returnAMI = null;
	  try {
		  StringBuffer url = new StringBuffer(host + "/v1/amis/:amiId/current".replace(":amiId", equipmentId));
		  System.out.println("url =====> "+url);
		  logger.debug("URL", url);
		  resultBody = HttpUtil.get(url.toString(), getHeaders());
		  System.out.println("ami resultBody =====> "+resultBody);
		  returnAMI = JsonUtil.toObject(resultBody, AmiEquipmentModel.class);
	  } catch (Exception e) {
		  logger.error("error is : " + e.toString());
	  } finally {
		  logger.debug("PMGrowApiUtil.getPvEquipmentList end");
          return returnAMI;
	  }
  }
  
  
  public static SocModel getSoc(String host, String equipmentId) {
	  logger.debug("PMGrowApiUtil.getSoc");
      String resultBody = null;
      SocModel returnSoc = null;
	  try {
		  StringBuffer url = new StringBuffer(host + "/openapi/soc");
		  url.append("?equipmentId=").append(equipmentId);
		  logger.debug("URL", url);
		  resultBody = HttpUtil.get(url.toString(), getHeaders());
		  returnSoc = JsonUtil.toObject(resultBody, SocModel.class);
	  } catch (NullPointerException e) {
		  logger.error("error is : " + e.toString());
	  } catch (Exception e) {
		  logger.error("error is : " + e.toString());
	  } finally {
		  logger.debug("PMGrowApiUtil.getSoc end");
          return returnSoc;
	  }
  }

  private static HttpHeaders getHeaders() {
    HttpHeaders headers = new HttpHeaders();
//    headers.set("authorization", "Bearer  " + API_ACCESS_TOKEN);
    headers.set("Authorization", "Basic  " + "omni-conrning01");
//    headers.set("accept-version", API_VERSION);
    return headers;
  }
}
