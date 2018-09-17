package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

public interface PeakService {

	List getPeakRealList(HashMap param) throws Exception;

	List getContractPowerList(HashMap param) throws Exception;
	
	List getChargePowerList(HashMap param) throws Exception;

}
