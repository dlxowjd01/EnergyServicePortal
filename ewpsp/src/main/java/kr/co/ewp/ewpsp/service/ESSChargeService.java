package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

public interface ESSChargeService {

	List getESSChargeRealList(HashMap param) throws Exception;

	List getESSChargeFutureList(HashMap param) throws Exception;

}
