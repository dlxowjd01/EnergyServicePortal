package kr.co.ewp.ewpsp.common.util;

import com.fasterxml.jackson.core.type.TypeReference;
import kr.co.ewp.ewpsp.model.BmsEquipmentModelBefore;
import kr.co.ewp.ewpsp.model.PcsEquipmentModelBefore;
import kr.co.ewp.ewpsp.model.PvEquipmentModelBefore;
import kr.co.ewp.ewpsp.model.SocModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;

import java.util.List;

public class PMGrowApiUtilBefore_bak {
    private static final String API_VERSION = "2.0.0";
    private static final String API_ACCESS_TOKEN = "<access_token>";

    private static final Logger logger = LoggerFactory.getLogger(PMGrowApiUtil.class);


    /**
     * PCS 운전상태 조회
     *
     * @param equipmentId
     * @param startDt      yyyyMMdd
     * @param endDt        yyyyMMdd
     * @param intervalType
     * @param interval
     * @param prettyLog
     * @return
     */
    public static List<PcsEquipmentModelBefore> getPcsEquipmentList(String host, String equipmentId) {
        logger.debug("PMGrowApiUtil.getPcsEquipmentList");
        String resultBody = null;
        List<PcsEquipmentModelBefore> returnPCS = null;
        try {
            StringBuffer url = new StringBuffer(host + "/openapi/pcs-equipment-list");
            url.append("?equipmentId=").append(equipmentId);
            System.out.println("pcs device url =====> " + url);
            logger.debug("pmgrow api URL : " + url);
            resultBody = HttpUtil.get(url.toString(), getHeaders());
            System.out.println("pcs resultBody =====> " + resultBody);
            returnPCS = JsonUtil.toObject(resultBody, new TypeReference<List<PcsEquipmentModelBefore>>() {
            });
        } catch (NullPointerException e) {
            logger.error("error is : " + e.toString());
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
     * @param startDt      yyyyMMdd
     * @param endDt        yyyyMMdd
     * @param intervalType
     * @param interval
     * @param prettyLog
     * @return
     */
    public static List<BmsEquipmentModelBefore> getBmsEquipmentList(String host, String equipmentId) {
        logger.debug("PMGrowApiUtil.getBmsEquipmentList");
        String resultBody = null;
        List<BmsEquipmentModelBefore> returnBMS = null;
        try {
            StringBuffer url = new StringBuffer(host + "/openapi/bms-equipment-list");
            url.append("?equipmentId=").append(equipmentId);
            System.out.println("bms device url =====> " + url);
            logger.debug("pmgrow api URL : " + url);
            resultBody = HttpUtil.get(url.toString(), getHeaders());
            System.out.println("bms resultBody =====> " + resultBody);
            returnBMS = JsonUtil.toObject(resultBody, new TypeReference<List<BmsEquipmentModelBefore>>() {
            });
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
     * @param startDt      yyyyMMdd
     * @param endDt        yyyyMMdd
     * @param intervalType
     * @param interval
     * @param prettyLog
     * @return
     */
    public static List<PvEquipmentModelBefore> getPvEquipmentList(String host, String equipmentId) {
        logger.debug("PMGrowApiUtil.getPvEquipmentList");
        String resultBody = null;
        List<PvEquipmentModelBefore> returnPV = null;
        try {
            StringBuffer url = new StringBuffer(host + "/openapi/pv-equipment-list");
            url.append("?equipmentId=").append(equipmentId);
            System.out.println("pv device url =====> " + url);
            logger.debug("pmgrow api URL : " + url);
            resultBody = HttpUtil.get(url.toString(), getHeaders());
            System.out.println("pv device resultBody =====> " + resultBody);
            returnPV = JsonUtil.toObject(resultBody, new TypeReference<List<PvEquipmentModelBefore>>() {
            });
        } catch (NullPointerException e) {
            logger.error("error is : " + e.toString());
        } catch (Exception e) {
            logger.error("error is : " + e.toString());
        } finally {
            logger.debug("PMGrowApiUtil.getPvEquipmentList end");
            return returnPV;
        }
    }

    public static SocModel getSoc(String host, String equipmentId) {
        logger.debug("PMGrowApiUtil.getSoc");

        String resultBody = null;
        SocModel returnSoc = null;
        try {
            StringBuffer url = new StringBuffer(host + "/openapi/soc");
            url.append("?equipmentId=").append(equipmentId);
            logger.debug("pmgrow api URL : " + url);
            resultBody = HttpUtil.get(url.toString(), getHeaders());
            logger.debug("result " + resultBody);
            returnSoc = JsonUtil.toObject(resultBody, SocModel.class);
        } catch (NullPointerException e) {
            logger.error("error is : " + e.toString());
        } catch (Exception e) {
//		  e.printStackTrace();
            logger.error("error is : " + e.toString());
        } finally {
            logger.debug("PMGrowApiUtil.getSoc end");
            return returnSoc;
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
