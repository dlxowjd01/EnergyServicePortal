package kr.co.ewp.ewpsp.common.util;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;

import com.fasterxml.jackson.core.type.TypeReference;

import kr.co.ewp.ewpsp.model.SocModel;

public class PMGrowApiUtil {
  private static final String API_VERSION = "2.0.0";
  private static final String API_ACCESS_TOKEN = "<access_token>";
  
  private static final Logger logger = LoggerFactory.getLogger(PMGrowApiUtil.class);

  public static SocModel getSoc(String host, String equipmentId) {
	  logger.debug("PMGrowApiUtil.getSoc");
	  
	  String resultBody = null;
	  SocModel returnSoc = null;
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
}
