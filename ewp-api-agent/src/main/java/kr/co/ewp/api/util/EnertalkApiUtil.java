package kr.co.ewp.api.util;

import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;

import com.fasterxml.jackson.core.type.TypeReference;

import kr.co.ewp.api.config.Constants;
import kr.co.ewp.api.model.CblResponseModel;
import kr.co.ewp.api.model.DeviceModel;
import kr.co.ewp.api.model.DrPaymentModel;
import kr.co.ewp.api.model.DrRequestTarget;
import kr.co.ewp.api.model.UsageModel;
import kr.co.ewp.api.model.UsageRealtimeModel;

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
    positiveEnergy, negativeEnergy, positiveEnergyReactive, negativeEnergyReactive;
  }

  private static final String API_URL = Constants.ENERTALK_API_URL;

  public static UsageModel getUsagePeriodicByDeviceId(String deviceId, Period period, Date start, Date end, TimeType timeType, UsageType usageType, PrettyLog prettyLog) {
    prettyLog.start("EnertalkApiUtil.getUsageByDeviceId", "ERROR");
    String resultBody = null;
    try {
      StringBuffer url = new StringBuffer(API_URL + "/devices/").append(deviceId).append("/usages/periodic");
      url.append("?timeType=").append(timeType);
      url.append("&usageType=").append(usageType);
      url.append("&period=").append(period);
      url.append("&start=").append(start.getTime());
      url.append("&end=").append(end.getTime());
      prettyLog.append("URL", url);
      HttpHeaders headers = getHeaders();
      resultBody = HttpUtil.get(url.toString(), headers);
      return JsonUtil.toObject(resultBody, UsageModel.class);
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

  public static UsageModel getUsagePeriodicBySiteId(String siteId, Period period, Date start, Date end, TimeType timeType, UsageType usageType, PrettyLog prettyLog) {
    prettyLog.start("EnertalkApiUtil.getUsagePeriodicBySiteId", "ERROR");
    String resultBody = null;
    try {
      StringBuffer url = new StringBuffer(API_URL + "/sites/").append(siteId).append("/usages/periodic");
      url.append("?timeType=").append(timeType);
      url.append("&usageType=").append(usageType);
      url.append("&period=").append(period);
      url.append("&start=").append(start.getTime());
      url.append("&end=").append(end.getTime());
      prettyLog.append("URL", url);
      HttpHeaders headers = getHeaders();
      resultBody = HttpUtil.get(url.toString(), headers);
      return JsonUtil.toObject(resultBody, UsageModel.class);
    } catch (NullPointerException e) {
	  	  logger.error("error is : "+e.toString());
	  	  throw e;
    } catch (Exception e) {
      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
      prettyLog.append("RESULT", resultBody);
      throw e;
    } finally {
      prettyLog.stop();
    }
  }

  public static List<DeviceModel> getDevices(String siteId, PrettyLog prettyLog) {
    String resultBody = null;
    prettyLog.start("EnertalkApiUtil.getDevices", "ERROR");
    try {
      String url = API_URL + "/sites/:siteId/devices".replace(":siteId", siteId);
      prettyLog.append("URL", url);
      HttpHeaders headers = getHeaders();
      resultBody = HttpUtil.get(url, headers);
      return JsonUtil.toObject(resultBody, new TypeReference<List<DeviceModel>>() {
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

  public static DeviceModel getDevice(String deviceId, PrettyLog prettyLog) {
    prettyLog.start("EnertalkApiUtil.getDevice", "ERROR");
    String resultBody = null;
    try {
      String url = API_URL + "/devices/:deviceId".replace(":deviceId", deviceId);
      prettyLog.append("URL", url);
      HttpHeaders headers = getHeaders();
      resultBody = HttpUtil.get(url, headers);
      return JsonUtil.toObject(resultBody, DeviceModel.class);
    } catch (NullPointerException e) {
	  	  logger.error("error is : "+e.toString());
	  	  throw e;
    } catch (Exception e) {
      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
      prettyLog.append("RESULT", resultBody);
      throw e;
    } finally {
      prettyLog.stop();
    }
  }
  
  public static UsageRealtimeModel getDeviceRealTime(String deviceId, PrettyLog prettyLog) {
	  prettyLog.start("EnertalkApiUtil.getDeviceRealTime", "ERROR");
	  String resultBody = null;
	  try {
		  String url = API_URL + "/devices/:deviceId/usages/realtime".replace(":deviceId", deviceId);
		  prettyLog.append("URL", url);
		  HttpHeaders headers = getHeaders();
		  resultBody = HttpUtil.get(url, headers);
		  return JsonUtil.toObject(resultBody, UsageRealtimeModel.class);
	  } catch (NullPointerException e) {
	  	  logger.error("error is : "+e.toString());
	  	  throw e;
	  } catch (Exception e) {
		  prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
		  prettyLog.append("RESULT", resultBody);
		  throw e;
	  } finally {
		  prettyLog.stop();
	  }
  }

  public static List<DrRequestTarget> getDrRequest(String siteId, int offset, int limit, PrettyLog prettyLog) {
    prettyLog.start("EnertalkApiUtil.getDrRequest", "ERROR");
    String resultBody = null;
    try {
      StringBuffer url = new StringBuffer(API_URL + "/dr/requests");
      url.append("?siteId=").append(siteId);
      url.append("&offset=").append(offset);
      url.append("&limit=").append(limit);
      prettyLog.append("URL", url);
      HttpHeaders headers = getHeaders();
      resultBody = HttpUtil.get(url.toString(), headers);
      return JsonUtil.toObject(resultBody, new TypeReference<List<DrRequestTarget>>() {
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
  
  public static List<DrRequestTarget> getDrRequestTerm(String siteId, Date start, Date end, int offset, int limit, PrettyLog prettyLog) {
	  prettyLog.start("EnertalkApiUtil.getDrRequestTest", "ERROR");
	  String resultBody = null;
	  try {
		  StringBuffer url = new StringBuffer(API_URL + "/dr/requests");
		  url.append("?siteId=").append(siteId);
		  url.append("&startAfter=").append(start.getTime());
	      url.append("&startBefore=").append(end.getTime());
		  url.append("&offset=").append(offset);
		  url.append("&limit=").append(limit);
		  prettyLog.append("URL", url);
		  HttpHeaders headers = getHeaders();
		  resultBody = HttpUtil.get(url.toString(), headers);
		  return JsonUtil.toObject(resultBody, new TypeReference<List<DrRequestTarget>>() {
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

  public static List<DrPaymentModel> getDrPayments(String siteId, String beginMonth, String endMonth, PrettyLog prettyLog) {
    prettyLog.start("EnertalkApiUtil.getDrPayments", "ERROR");
    String resultBody = null;
    try {
      // FIXME : getDrPayments 이것만 host가 다른데 임시야?
       StringBuffer url = new StringBuffer(API_URL + "/dr/sites/:siteId/payments".replace(":siteId", siteId));
//      StringBuffer url = new StringBuffer("https://dr-hk-tmp.enertalk.com" + "/dr/sites/:siteId/payments".replace(":siteId", siteId));
      url.append("?startMonth=").append(beginMonth);
      url.append("&endMonth=").append(endMonth);
      prettyLog.append("URL", url);
      HttpHeaders headers = getHeaders();
      resultBody = HttpUtil.get(url.toString(), headers);
      return JsonUtil.toObject(resultBody, new TypeReference<List<DrPaymentModel>>() {
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
  
  public static CblResponseModel getCBL(String siteId, Date start, Date end, PrettyLog prettyLog) {
	  prettyLog.start("EnertalkApiUtil.getCBL", "ERROR");
	  String resultBody = null;
	  try {
		  // FIXME : getDrPayments 이것만 host가 다른데 임시야?
		  StringBuffer url = new StringBuffer(API_URL + "/admin/dr/sites/:siteId/cbl".replace(":siteId", siteId));
		  url.append("?start=").append(start.getTime());
	      url.append("&end=").append(end.getTime());
		  url.append("&method=").append("max4of5");
		  prettyLog.append("URL", url);
		  HttpHeaders headers = getHeaders();
		  resultBody = HttpUtil.get(url.toString(), headers);
		  return JsonUtil.toObject(resultBody, CblResponseModel.class);
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
    headers.set("authorization", "Basic " + Constants.ENERTALK_API_AUTH);
    // headers.set("authorization", "Baerer " + Constants.ENERTALK_API_AUTH);
    return headers;
  }
}
