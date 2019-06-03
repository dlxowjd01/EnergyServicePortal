package kr.co.ewp.ewpsp.service;

import java.util.List;
import java.util.Map;

public interface DeviceMonitoringService {

    List getDeviceIOEList(Map<String, Object> param) throws Exception;

    int getDeviceIOEListCnt(Map<String, Object> param) throws Exception;

    Map getDeviceIOEDetail(Map<String, Object> param) throws Exception;

    List getDevicePCSList(Map<String, Object> param) throws Exception;

    int getDevicePCSListCnt(Map<String, Object> param) throws Exception;

    Map getDevicePCSDetail(Map<String, Object> param) throws Exception;

    List getDeviceBMSList(Map<String, Object> param) throws Exception;

    int getDeviceBMSListCnt(Map<String, Object> param) throws Exception;

    Map getDeviceBMSDetail(Map<String, Object> param) throws Exception;

    List getDevicePVList(Map<String, Object> param) throws Exception;

    int getDevicePVListCnt(Map<String, Object> param) throws Exception;

    Map getDevicePVDetail(Map<String, Object> param) throws Exception;

    List getDeviceList(Map<String, Object> param) throws Exception;

    int getDeviceListCnt(Map<String, Object> param) throws Exception;

    Map<String, String> getDevice(Map<String, Object> dvMap) throws Exception;
}
