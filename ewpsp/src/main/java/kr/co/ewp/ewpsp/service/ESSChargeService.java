package kr.co.ewp.ewpsp.service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

public interface ESSChargeService {

    Map getESSChargeRealList(HashMap param, HttpServletRequest request) throws Exception;

    Map getESSChargeFutureList(HashMap param, HttpServletRequest request) throws Exception;

    Map getESSChargeSum(HashMap param) throws Exception;

}
