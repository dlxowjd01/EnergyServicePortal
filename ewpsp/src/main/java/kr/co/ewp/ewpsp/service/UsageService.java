package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

public interface UsageService {

	List getUsageRealList(HashMap param) throws Exception;

	List getUsageFutureList(HashMap param) throws Exception;

}
