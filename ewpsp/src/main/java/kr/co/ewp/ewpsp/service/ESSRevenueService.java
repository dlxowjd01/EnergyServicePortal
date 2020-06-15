package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ESSRevenueService {

    Map getESSRevenueList(HashMap param) throws Exception;

    Map getESSRevenueTexList(HashMap param) throws Exception;

    List getESSRevenueDayList(HashMap param) throws Exception;


}
