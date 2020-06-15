package kr.co.ewp.api.service;

import java.util.List;

import kr.co.ewp.api.entity.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ewp.api.dao.DeviceAmiDao;
import kr.co.ewp.api.dao.DeviceBmsDao;
import kr.co.ewp.api.dao.DeviceDao;
import kr.co.ewp.api.dao.DeviceIoeDao;
import kr.co.ewp.api.dao.DevicePcsDao;
import kr.co.ewp.api.dao.DevicePvDao;
import kr.co.ewp.api.util.PrettyLog;

@Service
@Transactional
public class DeviceService {
  private Logger logger = LoggerFactory.getLogger(DeviceService.class);

  @Autowired
  private DeviceDao deviceDao;
  @Autowired
  private DeviceIoeDao deviceIoeDao;
  @Autowired
  private DevicePcsDao devicePcsDao;
  @Autowired
  private DeviceBmsDao deviceBmsDao;
  @Autowired
  private DevicePvDao devicePvDao;
  @Autowired
  private DeviceAmiDao deviceAmiDao;

  @Transactional(readOnly = true)
  public List<Device> getDeviceList(String siteId, PrettyLog prettyLog) {
    return deviceDao.selectListBySiteId(siteId, prettyLog);
  }

  @Transactional(readOnly = true)
  public List<Device> getDeviceList(PrettyLog prettyLog) {
    return deviceDao.selectList(prettyLog);
  }

  @Transactional(readOnly = true)
  public Device getDevice(String deviceId, PrettyLog prettyLog) {
    return deviceDao.selectOne(deviceId, prettyLog);
  }

  public int addDeivceIoeList(List<DeviceIoe> deviceIoeList, PrettyLog prettyLog) {
    int result = 0;
    for (DeviceIoe deviceIoe : deviceIoeList) {
      deviceIoeDao.insert(deviceIoe, prettyLog);
      result++;
      if (result % 100 == 0) {
        logger.info("addDeivceIoeList,{},{}", new Object[] { deviceIoe.getDeviceId(), result });
      }
    }
    return result;
  }

  public int addDeivcePcsList(List<DevicePcs> deivcePcsList, PrettyLog prettyLog) {
    int result = 0;
    for (DevicePcs devicePcs : deivcePcsList) {
      devicePcsDao.insert(devicePcs, prettyLog);
      result++;
      if (result % 100 == 0) {
        logger.info("addDeivcePcsList,{},{}", new Object[] { devicePcs.getDeviceId(), result });
      }
    }
    return result;
  }

  public int addDeivceBmsList(List<DeviceBms> deivceBmsList, PrettyLog prettyLog) {
    int result = 0;
    for (DeviceBms deviceBms : deivceBmsList) {
      deviceBmsDao.insert(deviceBms, prettyLog);
      result++;
      if (result % 100 == 0) {
        logger.info("addDeivceBmsList,{},{}", new Object[] { deviceBms.getDeviceId(), result });
      }
    }
    return result;
  }

  public int addDeivcePvList(List<DevicePv> deivcePvList, PrettyLog prettyLog) {
    int result = 0;
    for (DevicePv devicePv : deivcePvList) {
      devicePvDao.insert(devicePv, prettyLog);
      result++;
      if (result % 100 == 0) {
        logger.info("addDeivcePvList,{},{}", new Object[] { devicePv.getDeviceId(), result });
      }
    }
    return result;
  }

  public int addDeivceAmiList(List<DeviceAmi> deivceAmiList, PrettyLog prettyLog) {
    int result = 0;
    for (DeviceAmi deivceAmi : deivceAmiList) {
    	deviceAmiDao.insert(deivceAmi, prettyLog);
      result++;
      if (result % 100 == 0) {
        logger.info("addDeivceAmiList,{},{}", new Object[] { deivceAmi.getDeviceId(), result });
      }
    }
    return result;
  }
}
