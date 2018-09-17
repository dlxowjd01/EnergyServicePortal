package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

public interface PVGenService {

	List getPVGenRealList(HashMap param) throws Exception;

	List getPVGenFutureList(HashMap param) throws Exception;

}
