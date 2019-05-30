package kr.co.ewp.ewpsp.common.util;

import com.fasterxml.jackson.annotation.JsonValue;
import kr.co.ewp.ewpsp.common.config.Constants;
import kr.co.ewp.ewpsp.model.BillRequestModel;
import kr.co.ewp.ewpsp.model.BillResponseModel;
import kr.co.ewp.ewpsp.model.PeakRequestModel;
import kr.co.ewp.ewpsp.model.PeakResponseModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;

public class EncoredApiUtil {
    private static final String API_URL = Constants.ENCORED_API_URL + "/calculator";
    private static Logger logger = LoggerFactory.getLogger(EncoredApiUtil.class);

    public static PeakResponseModel getPeak(PeakRequestModel peakRequest) {
        logger.debug("EncoredApiUtil.getPeak");
        String resultBody = null;
        PeakResponseModel returnModel = null;
        try {
            String url = API_URL + "/peak";
            HttpHeaders headers = new HttpHeaders();
            logger.debug("encored api URL : " + url);
            headers.set("content-type", "application/json");
            resultBody = HttpUtil.post(url, headers, JsonUtil.toJson(peakRequest));
            returnModel = JsonUtil.toObject(resultBody, PeakResponseModel.class);
        } catch (NullPointerException e) {
            logger.error("error is : " + e.toString());
        } catch (Exception e) {
            logger.error("error is : " + e.toString());
        } finally {
            logger.debug("EncoredApiUtil.getPeak RESULT   " + resultBody);
            return returnModel;
        }
    }

//  public static GenResponseModel getGen(GenRequestModel genRequest, PrettyLog prettyLog) {
//    prettyLog.start("EncoredApiUtil.getGen", "ERROR");
//    String resultBody = null;
//    prettyLog.append("PARAM", JsonUtil.toJson(genRequest));
//    try {
//      String url = API_URL + "/gen";
//      HttpHeaders headers = new HttpHeaders();
//      prettyLog.append("URL", url);
//      headers.set("content-type", "application/json");
//      resultBody = HttpUtil.post(url, headers, JsonUtil.toJson(genRequest));
//      return JsonUtil.toObject(resultBody, GenResponseModel.class, PropertyNamingStrategy.SNAKE_CASE);
//    } catch (Exception e) {
//      prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
//      logger.error("EncoredApiUtil.getGen:{}", JsonUtil.toJson(genRequest));
//      throw e;
//    } finally {
//      prettyLog.append("RESULT", resultBody);
//      prettyLog.stop();
//    }
//  }

    public static BillResponseModel getBill(BillRequestModel billRequest) {
        logger.debug("EncoredApiUtil.getBill");// EncoredApiUtil.getBill
        String resultBody = null;
        BillResponseModel returnModel = null;
        try {
            String url = API_URL + "/bill";
            HttpHeaders headers = new HttpHeaders();
            logger.debug("encored api URL : " + url);
            headers.set("content-type", "application/json");
            resultBody = HttpUtil.post(url, headers, JsonUtil.toJson(billRequest));
            returnModel = JsonUtil.toObject(resultBody, BillResponseModel.class);
        } catch (NullPointerException e) {
            logger.error("error is : " + e.toString());
        } catch (Exception e) {
            logger.error("error is : " + e.toString());
        } finally {
            logger.debug("RESULT  " + resultBody);
            return returnModel;
        }
    }

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
//  public static BillResponseModel getBill(BillRequestModel billRequest, PrettyLog prettyLog) {
//	  prettyLog.start("EncoredApiUtil.getBill", "ERROR");// EncoredApiUtil.getBill
//	  prettyLog.append("PARAM", JsonUtil.toJson(billRequest));
//	  String resultBody = null;
//	  try {
//		  String url = API_URL + "/bill";
//		  HttpHeaders headers = new HttpHeaders();
//		  prettyLog.append("URL", url);
//		  headers.set("content-type", "application/json");
//		  resultBody = HttpUtil.post(url, headers, JsonUtil.toJson(billRequest));
//		  return JsonUtil.toObject(resultBody, BillResponseModel.class);
//	  } catch (Exception e) {
//		  prettyLog.append("ERROR", e == null ? "NULL" : e.getMessage());
//		  logger.error("EncoredApiUtil.getBill:{}", JsonUtil.toJson(billRequest));
//		  throw e;
//	  } finally {
//		  prettyLog.append("RESULT", resultBody);
//		  prettyLog.stop();
//	  }
//  }
}
