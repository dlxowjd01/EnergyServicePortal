package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface DRResultService {

	List getDRResultList(HashMap param) throws Exception;
	
	Map getCbl(HashMap param) throws Exception;

}
