package kr.co.ewp.ewpsp.service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface PVGenService {

    Map getPVGenRealList(HashMap param, HttpServletRequest request) throws Exception;

    Map getPVGenFutureList(HashMap param, HttpServletRequest request) throws Exception;

    Integer getPVGenRealListForToday(HashMap param, HttpServletRequest request) throws Exception;

    Integer getPVGenRealListForLastMonth(HashMap param, HttpServletRequest request) throws Exception;

    Integer getPVGenRealListForThisMonth(HashMap param, HttpServletRequest request) throws Exception;

    List getPVGenRealListForThisMonthDaily(HashMap param, HttpServletRequest request) throws Exception;

    Integer getPVGenRealListForLastYear(HashMap param, HttpServletRequest request) throws Exception;

    Integer getPVGenRealListForThisYear(HashMap param, HttpServletRequest request) throws Exception;

    List getPVGenRealListForThisYearMonthly(HashMap param, HttpServletRequest request) throws Exception;

    List getPVGenRealLatestListOfDevices(HashMap param, HttpServletRequest request) throws Exception;

}
