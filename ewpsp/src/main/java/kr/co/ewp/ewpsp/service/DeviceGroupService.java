package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;

public interface DeviceGroupService {

    List getDeviceGroupList(HashMap param) throws Exception;

    List getDvInDeviceGroupList(HashMap param) throws Exception;

    List getDeviceGrpAlarmList(HashMap param) throws Exception;

    List getAllDvInSiteList(HashMap param) throws Exception;

    List getDeviceNotInGroupList(HashMap param) throws Exception;

    int deleteDeviceGroup(HashMap param) throws Exception;

    int insertDeviceGroup(HashMap param) throws Exception;

    int getDeviceChk(HashMap param) throws Exception;

    int insertDevice(HashMap param) throws Exception;

    int updateDevice(HashMap param) throws Exception;

    int deleteDevice(HashMap param) throws Exception;

}
