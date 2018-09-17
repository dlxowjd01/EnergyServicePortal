package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface KepcoMngSetService {

	Map getSiteSetDetail(HashMap param) throws Exception;
	
	int updateSiteSet(HashMap param) throws Exception;

}
