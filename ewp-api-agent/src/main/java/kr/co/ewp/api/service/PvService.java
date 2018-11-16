package kr.co.ewp.api.service;

import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ewp.api.dao.PvGenDao;
import kr.co.ewp.api.dao.PvUsageDao;
import kr.co.ewp.api.entity.PvGen;
import kr.co.ewp.api.entity.PvUsage;
import kr.co.ewp.api.util.PrettyLog;

@Service
@Transactional
public class PvService {
  private Logger logger = LoggerFactory.getLogger(PvService.class);
  @Autowired
  private PvGenDao pvGenDao;
  @Autowired
  private PvUsageDao pvUsageDao;

  public PvGen getLastPvGen(String siteId, String deviceId, PrettyLog prettyLog) {
    return pvGenDao.selectOneLast(siteId, deviceId, prettyLog);
  }

  public int addOrModPvGenList(List<PvGen> pvGenList, PrettyLog prettyLog) {
    int result = 0;
    for (PvGen pvGen : pvGenList) {
      // BATCH INSERT
      // pvGenDao.insert(pvGen, null);
      PvGen selectOneByUnique = pvGenDao.selectOneByUnique(pvGen.getSiteId(), pvGen.getDeviceId(), pvGen.getStdDate(), null);
      if (selectOneByUnique == null) {
        pvGenDao.insert(pvGen, null);
      } else {
        pvGen.setPvGenIdx(selectOneByUnique.getPvGenIdx());
        pvGenDao.update(pvGen, null);
      }
      result++;
      if (result % 100 == 0) {
        logger.info("addOrModPvGenList,{},{}", new Object[] { pvGen.getDeviceId(), result });
      }
    }
    return result;
  }

  public int addOrModPvUsageList(List<PvUsage> pvUsageList, PrettyLog prettyLog) {
    int result = 0;
    for (PvUsage pvUsage : pvUsageList) {
      PvUsage selectOneByUnique = pvUsageDao.selectOneByUnique(pvUsage.getSiteId(), pvUsage.getDeviceId(), pvUsage.getStdDate(), null);
      if (selectOneByUnique == null) {
        pvUsageDao.insert(pvUsage, null);
      } else {
        pvUsage.setPvUsgIdx(selectOneByUnique.getPvUsgIdx());
        pvUsageDao.update(pvUsage, null);
      }
      result++;
      if (result % 100 == 0) {
        logger.info("addOrModPvUsageList,{},{}", new Object[] { pvUsage.getDeviceId(), result });
      }
    }
    return result;
  }

  public PvUsage getLastPvUsage(String siteId, String deviceId, PrettyLog prettyLog) {
    return pvUsageDao.selectOneLast(siteId, deviceId, prettyLog);
  }

  public List<PvGen> getPvGenListBySiteId(String siteId, Date beginDate, Date endDate, PrettyLog prettyLog) {
    return pvGenDao.selectPvGenListBySiteId(siteId, beginDate, endDate, prettyLog);
  }

  public List<PvUsage> getPvUsageListBySiteId(String siteId, Date beginDate, Date endDate, PrettyLog prettyLog) {
    return pvUsageDao.selectPvUsageListBySiteId(siteId, beginDate, endDate, prettyLog);
  }

}
