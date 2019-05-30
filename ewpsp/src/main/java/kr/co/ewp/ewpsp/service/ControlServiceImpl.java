package kr.co.ewp.ewpsp.service;

import kr.co.ewp.ewpsp.dao.ControlDao;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("controlService")
public class ControlServiceImpl implements ControlService {

    @Resource(name = "controlDao")
    private ControlDao controlDao;

    public Map getDeviceAlarmCnt(HashMap param) throws Exception {
        return controlDao.getDeviceAlarmCnt(param);
    }

    public Map getSiteMainAlarmCnt(HashMap param) throws Exception {
        return controlDao.getSiteMainAlarmCnt(param);
    }

    public Map getGMainDeviceAlarmCnt(HashMap param) throws Exception {
        return controlDao.getGMainDeviceAlarmCnt(param);
    }

    public Map getGMainAlarmCnt(HashMap param) throws Exception {
        return controlDao.getGMainAlarmCnt(param);
    }

    public List getAlarmList(HashMap param) throws Exception {
        return controlDao.getAlarmList(param);
    }

    public int getAlarmListCnt(HashMap param) throws Exception {
        return controlDao.getAlarmListCnt(param);
    }

    @Transactional
    public int updateAlarm(HashMap param) throws Exception {
        return controlDao.updateAlarm(param);
    }

    public List getSmsUserList(HashMap param) throws Exception {
        return controlDao.getSmsUserList(param);
    }

    public List getSmsAddresseeList(HashMap param) throws Exception {
        return controlDao.getSmsAddresseeList(param);
    }

    public List getInsertAddresseeNameList(HashMap param) throws Exception {
        return controlDao.getInsertAddresseeNameList(param);
    }

    @Transactional
    public int insertAddressee(HashMap param) throws Exception {
        return controlDao.insertAddressee(param);
    }

    @Transactional
    public int deleteAddressee(HashMap param) throws Exception {
        return controlDao.deleteAddressee(param);
    }

}
