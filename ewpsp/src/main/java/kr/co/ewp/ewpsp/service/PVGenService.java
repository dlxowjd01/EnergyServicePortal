package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface PVGenService {

	Map getPVGenRealList(HashMap param) throws Exception;

	Map getPVGenFutureList(HashMap param) throws Exception;

}
