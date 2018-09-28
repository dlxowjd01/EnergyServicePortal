package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.Map;

public interface ESSChargeService {

	Map getESSChargeRealList(HashMap param) throws Exception;

	Map getESSChargeFutureList(HashMap param) throws Exception;
	
	Map getESSChargeSum(HashMap param) throws Exception;

}
