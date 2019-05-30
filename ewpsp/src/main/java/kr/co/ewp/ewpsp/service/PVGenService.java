package kr.co.ewp.ewpsp.service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

public interface PVGenService {

    Map getPVGenRealList(HashMap param, HttpServletRequest request) throws Exception;

    Map getPVGenFutureList(HashMap param, HttpServletRequest request) throws Exception;

}
