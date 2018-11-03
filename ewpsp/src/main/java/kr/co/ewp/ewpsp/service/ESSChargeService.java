package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface ESSChargeService {

	Map getESSChargeRealList(HashMap param, HttpServletRequest request) throws Exception;

	Map getESSChargeFutureList(HashMap param, HttpServletRequest request) throws Exception;
	
	Map getESSChargeSum(HashMap param) throws Exception;

}
