package kr.co.ewp.api.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;

import com.fasterxml.jackson.annotation.JsonValue;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import kr.co.ewp.api.config.Constants;
import kr.co.ewp.api.model.BillRequestModel;
import kr.co.ewp.api.model.BillResponseModel;
import kr.co.ewp.api.model.GenRequestModel;
import kr.co.ewp.api.model.GenResponseModel;
import kr.co.ewp.api.model.PeakRequestModel;
import kr.co.ewp.api.model.PeakResponseModel;

public class EncoredApiUtil {
  private static Logger logger = LoggerFactory.getLogger(EncoredApiUtil.class);

  public enum Period {
    _15min, _30min, hour, day, month, billingMonth;
    @Override
    public String toString() {
      return super.toString().replace("_", "");
    }

    @JsonValue
    public String toValue() {
      return super.toString().replace("_", "");
    }
  }

  private static final String API_URL = Constants.ENCORED_API_URL + "/calculator";

  public static GenResponseModel getGen(GenRequestModel genRequest, PrettyLog prettyLog) {
    prettyLog.start("EncoredApiUtil.getGen", "ERROR");
    String resultBody = null;
    prettyLog.append("PARAM", JsonUtil.toJson(genRequest));
    try {
      String url = API_URL + "/gen";
      HttpHeaders headers = new HttpHeaders();
      prettyLog.append("URL", url);
      headers.set("content-type", "application/json");
      resultBody = HttpUtil.post(url, headers, JsonUtil.toJson(genRequest));
      return JsonUtil.toObject(resultBody, GenResponseModel.class, PropertyNamingStrategy.SNAKE_CASE);
    } catch (NullPointerException e) {
    	logger.error("error is : "+e.toString());
    	throw e;
    } catch (Exception e) {
      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
      logger.error("EncoredApiUtil.getGen:{}", JsonUtil.toJson(genRequest));
      throw e;
    } finally {
      prettyLog.append("RESULT", resultBody);
      prettyLog.stop();
    }
  }

  public static PeakResponseModel getPeak(PeakRequestModel peakRequest, PrettyLog prettyLog) {
    prettyLog.start("EncoredApiUtil.getPeak", "ERROR");
    prettyLog.append("PARAM", JsonUtil.toJson(peakRequest));
    String resultBody = null;
    try {
      String url = API_URL + "/peak";
      HttpHeaders headers = new HttpHeaders();
      prettyLog.append("URL", url);
      headers.set("content-type", "application/json");
      resultBody = HttpUtil.post(url, headers, JsonUtil.toJson(peakRequest));
      return JsonUtil.toObject(resultBody, PeakResponseModel.class);
    } catch (NullPointerException e) {
    	logger.error("error is : "+e.toString());
    	throw e;
    } catch (Exception e) {
      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
      logger.error("EncoredApiUtil.getPeak:{}", JsonUtil.toJson(peakRequest));
      throw e;
    } finally {
      prettyLog.append("RESULT", resultBody);
      prettyLog.stop();
    }
  }

  public static BillResponseModel getBill(BillRequestModel billRequest, PrettyLog prettyLog) {
    prettyLog.start("EncoredApiUtil.getBill", "ERROR");// EncoredApiUtil.getBill
    prettyLog.append("PARAM", JsonUtil.toJson(billRequest));
//    System.out.println("                                  billRequest    "+billRequest.toString());
    String resultBody = null;
    try {
      String url = API_URL + "/bill";
      HttpHeaders headers = new HttpHeaders();
      prettyLog.append("URL", url);
      headers.set("content-type", "application/json");
      resultBody = HttpUtil.post(url, headers, JsonUtil.toJson(billRequest));
//      System.out.println("         resultBody는      "+resultBody);
      return JsonUtil.toObject(resultBody, BillResponseModel.class);
    } catch (NullPointerException e) {
    	logger.error("error is : "+e.toString());
    	throw e;
    } catch (Exception e) {
      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
      logger.error("EncoredApiUtil.getBill:{}", JsonUtil.toJson(billRequest));
      throw e;
    } finally {
      prettyLog.append("RESULT", resultBody);
      prettyLog.stop();
    }
  }
}
