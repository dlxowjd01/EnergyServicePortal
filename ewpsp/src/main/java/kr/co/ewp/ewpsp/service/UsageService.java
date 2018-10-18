package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface UsageService {

	Map getUsageRealList(HashMap param) throws Exception;

	Map getUsageFutureList(HashMap param) throws Exception;

}
