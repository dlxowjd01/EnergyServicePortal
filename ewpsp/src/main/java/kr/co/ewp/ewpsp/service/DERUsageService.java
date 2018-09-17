package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

public interface DERUsageService {

	List getESSUsageList(HashMap param) throws Exception;

	List getPVUsageList(HashMap param) throws Exception;

}
