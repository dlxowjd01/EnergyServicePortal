package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.Map;

public interface KepcoBillService {

    Map getKepcoBillList(HashMap param) throws Exception;

    Map getKepcoTexBillList(HashMap param) throws Exception;

    Map getKepcoResentBillList(HashMap param) throws Exception;

}
