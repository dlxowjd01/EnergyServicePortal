package kr.co.ewp.ewpsp.common.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;

import com.fasterxml.jackson.core.type.TypeReference;

import kr.co.ewp.ewpsp.common.config.Constants;
//import kr.co.ewp.api.model.DeviceModel;
//import kr.co.ewp.api.model.DrPaymentModel;
//import kr.co.ewp.api.model.DrRequestTarget;
import kr.co.ewp.ewpsp.model.UsageModel;

public class EnertalkApiUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(EnertalkApiUtil.class);

  public enum Period {
    _15min, _30min, hour, day, month;
    @Override
    public String toString() {
      return super.toString().replace("_", "");
    }
  }

  public enum TimeType {
    past, future;
  }

  public enum UsageType {
    positiveEnergy, negativeEnergy, positiveEnergyReactive;
  }

  private static final String API_URL = Constants.ENERTALK_API_URL;

//  public static UsageModel getUsagePeriodicByDeviceId(String deviceId, Period period, Date start, Date end, TimeType timeType, UsageType usageType, PrettyLog prettyLog) {
//    prettyLog.start("EnertalkApiUtil.getUsageByDeviceId", "ERROR");
//    String resultBody = null;
//    try {
//      StringBuffer url = new StringBuffer(API_URL + "/devices/").append(deviceId).append("/usages/periodic");
//      url.append("?timeType=").append(timeType);
//      url.append("&usageType=").append(usageType);
//      url.append("&period=").append(period);
//      url.append("&start=").append(start.getTime());
//      url.append("&end=").append(end.getTime());
//      prettyLog.append("URL", url);
//      HttpHeaders headers = getHeaders();
//      resultBody = HttpUtil.get(url.toString(), headers);
//      return JsonUtil.toObject(resultBody, UsageModel.class);
//    } catch (Exception e) {
//      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
//      throw e;
//    } finally {
//      prettyLog.append("RESULT", resultBody);
//      prettyLog.stop();
//    }
//  }
  
  public static UsageModel getUsagePeriodicByDeviceId(String deviceId, Period period, Date start, Date end, TimeType timeType, UsageType usageType) {
	  logger.debug("EnertalkApiUtil.getUsageByDeviceId");
	  String resultBody = null;
	  UsageModel returnUsage = null;
	  try {
		  StringBuffer url = new StringBuffer(API_URL + "/devices/").append(deviceId).append("/usages/periodic");
		  url.append("?timeType=").append(timeType);
		  url.append("&usageType=").append(usageType);
		  url.append("&period=").append(period);
		  url.append("&start=").append(start.getTime());
		  url.append("&end=").append(end.getTime());
		  
		  URL reUrl = new URL(  url.toString()  );
		  logger.debug("enertalk api URL : "+ url);
			HttpURLConnection con = (HttpURLConnection) reUrl.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("authorization", "Basic " + Constants.ENERTALK_API_AUTH);
			con.setDoOutput(true);
			Map headerFields = con.getHeaderFields();
			System.out.println("header fields are : "+headerFields);
			
			int resCode = con.getResponseCode();
			BufferedReader br;
			if(resCode == 200) { // 정상 호출
				br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			} else { // 에러 발생
				br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
			}
			
			String inputLine;
			StringBuffer response = new StringBuffer();
			while ((inputLine = br.readLine()) != null) {
				response.append(inputLine);
			}
			br.close();
		  
			resultBody = response.toString();
		  
		  logger.debug("result "+resultBody);
		  returnUsage = JsonUtil.toObject(resultBody, UsageModel.class);
		  return returnUsage;
	  } catch (Exception e) {
//		  e.printStackTrace();
		  logger.error("error is : "+e.toString());
	  } finally {
		  logger.debug("EnertalkApiUtil.getUsageByDeviceId end");
		  return returnUsage;
	  }
  }
//  public static UsageModel getUsagePeriodicByDeviceId(String deviceId, Period period, Date start, Date end, TimeType timeType, UsageType usageType) {
//	  logger.debug("EnertalkApiUtil.getUsageByDeviceId");
//	  String resultBody = null;
//	  UsageModel returnUsage = null;
//	  try {
//		  StringBuffer url = new StringBuffer(API_URL + "/devices/").append(deviceId).append("/usages/periodic");
//		  url.append("?timeType=").append(timeType);
//		  url.append("&usageType=").append(usageType);
//		  url.append("&period=").append(period);
//		  url.append("&start=").append(start.getTime());
//		  url.append("&end=").append(end.getTime());
//		  
//		  logger.debug("enertalk api URL : "+ url);
//		  HttpHeaders headers = getHeaders();
//		  resultBody = HttpUtil.get(url.toString(), headers);
//		  logger.debug("result "+resultBody);
//		  return JsonUtil.toObject(resultBody, UsageModel.class);
//	  } catch (Exception e) {
////		  e.printStackTrace();
//		  logger.error("error is : "+e.toString());
//	  } finally {
//		  logger.debug("EnertalkApiUtil.getUsageByDeviceId end");
//		  return returnUsage;
//	  }
//  }

  public static void getDevice(String deviceId) {
	  logger.debug("EnertalkApiUtil.getDevice");
    String resultBody = null;
    try {
      String url = API_URL + "/devices/:deviceId".replace(":deviceId", deviceId);
      logger.debug("enertalk api URL : "+ url);
      HttpHeaders headers = getHeaders();
      resultBody = HttpUtil.get(url, headers);
      logger.debug("결과!!===> "+resultBody);
//      return JsonUtil.toObject(resultBody, DeviceModel.class);
    } catch (Exception e) {
    	e.printStackTrace();
		logger.error("error is : "+e.toString());
    } finally {
    	logger.debug("EnertalkApiUtil.getDevice end");
    }
  }

//  public static UsageModel getUsagePeriodicBySiteId(String siteId, Period period, Date start, Date end, TimeType timeType, UsageType usageType, PrettyLog prettyLog) {
//    prettyLog.start("EnertalkApiUtil.getUsagePeriodicBySiteId", "ERROR");
//    String resultBody = null;
//    try {
//      StringBuffer url = new StringBuffer(API_URL + "/sites/").append(siteId).append("/usages/periodic");
//      url.append("?timeType=").append(timeType);
//      url.append("&usageType=").append(usageType);
//      url.append("&period=").append(period);
//      url.append("&start=").append(start.getTime());
//      url.append("&end=").append(end.getTime());
//      prettyLog.append("URL", url);
//      HttpHeaders headers = getHeaders();
//      resultBody = HttpUtil.get(url.toString(), headers);
//      return JsonUtil.toObject(resultBody, UsageModel.class);
//    } catch (Exception e) {
//      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
//      prettyLog.append("RESULT", resultBody);
//      throw e;
//    } finally {
//      prettyLog.stop();
//    }
//  }
//
//  public static List<DeviceModel> getDevices(String siteId, PrettyLog prettyLog) {
//    String resultBody = null;
//    prettyLog.start("EnertalkApiUtil.getDevices", "ERROR");
//    try {
//      String url = API_URL + "/sites/:siteId/devices".replace(":siteId", siteId);
//      prettyLog.append("URL", url);
//      HttpHeaders headers = getHeaders();
//      resultBody = HttpUtil.get(url, headers);
//      return JsonUtil.toObject(resultBody, new TypeReference<List<DeviceModel>>() {
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
//  public static DeviceModel getDevice(String deviceId, PrettyLog prettyLog) {
//    prettyLog.start("EnertalkApiUtil.getDevice", "ERROR");
//    String resultBody = null;
//    try {
//      String url = API_URL + "/devices/:deviceId".replace(":deviceId", deviceId);
//      prettyLog.append("URL", url);
//      HttpHeaders headers = getHeaders();
//      resultBody = HttpUtil.get(url, headers);
//      return JsonUtil.toObject(resultBody, DeviceModel.class);
//    } catch (Exception e) {
//      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
//      prettyLog.append("RESULT", resultBody);
//      throw e;
//    } finally {
//      prettyLog.stop();
//    }
//  }
//
//  public static List<DrRequestTarget> getDrRequest(String siteId, int offset, int limit, PrettyLog prettyLog) {
//    prettyLog.start("EnertalkApiUtil.getDrRequest", "ERROR");
//    String resultBody = null;
//    try {
//      StringBuffer url = new StringBuffer(API_URL + "/dr/requests");
//      url.append("?siteId=").append(siteId);
//      url.append("&offset=").append(offset);
//      url.append("&limit=").append(limit);
//      prettyLog.append("URL", url);
//      HttpHeaders headers = getHeaders();
//      resultBody = HttpUtil.get(url.toString(), headers);
//      return JsonUtil.toObject(resultBody, new TypeReference<List<DrRequestTarget>>() {
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
//  public static List<DrPaymentModel> getDrPayments(String siteId, String beginMonth, String endMonth, PrettyLog prettyLog) {
//    prettyLog.start("EnertalkApiUtil.getDrPayments", "ERROR");
//    String resultBody = null;
//    try {
//      // FIXME : getDrPayments 이것만 host가 다른데 임시야?
//      // StringBuffer url = new StringBuffer(API_URL + "/dr/sites/:siteId/payments".replace(":siteId", siteId));
//      StringBuffer url = new StringBuffer("https://dr-hk-tmp.enertalk.com" + "/dr/sites/:siteId/payments".replace(":siteId", siteId));
//      url.append("?startMonth=").append(beginMonth);
//      url.append("&endMonth=").append(endMonth);
//      prettyLog.append("URL", url);
//      HttpHeaders headers = getHeaders();
//      resultBody = HttpUtil.get(url.toString(), headers);
//      return JsonUtil.toObject(resultBody, new TypeReference<List<DrPaymentModel>>() {
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
    headers.set("authorization", "Basic " + Constants.ENERTALK_API_AUTH);
    // headers.set("authorization", "Baerer " + Constants.ENERTALK_API_AUTH);
    return headers;
  }
}
