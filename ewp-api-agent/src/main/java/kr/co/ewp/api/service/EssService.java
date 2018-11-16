package kr.co.ewp.api.service;

import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ewp.api.dao.EssChargeDao;
import kr.co.ewp.api.dao.EssChargePlanDao;
import kr.co.ewp.api.dao.EssUsageDao;
import kr.co.ewp.api.entity.EssCharge;
import kr.co.ewp.api.entity.EssChargePlan;
import kr.co.ewp.api.entity.EssUsage;
import kr.co.ewp.api.util.PrettyLog;

@Service
@Transactional
public class EssService {
  private Logger logger = LoggerFactory.getLogger(EssService.class);
  @Autowired
  private EssChargeDao essChargeDao;
  @Autowired
  private EssChargePlanDao essChargePlanDao;
  @Autowired
  private EssUsageDao essUsageDao;

  public EssCharge getLastEssCharge(String siteId, String deviceId, PrettyLog prettyLog) {
    return essChargeDao.selectOneLast(siteId, deviceId, prettyLog);
  }

  public int addOrModEssChargeList(List<EssCharge> essChargeList, PrettyLog prettyLog) {
    int result = 0;
    for (EssCharge essCharge : essChargeList) {
      // BATCH INSERT
      // essChargeDao.insert(essCharge, null);
      EssCharge selectOneByUnique = essChargeDao.selectOneByUnique(essCharge.getSiteId(), essCharge.getDeviceId(), essCharge.getStdTimestamp(), null);
      if (selectOneByUnique == null) {
        essChargeDao.insert(essCharge, null);
      } else {
        essCharge.setEssChgIdx(selectOneByUnique.getEssChgIdx());
        essChargeDao.update(essCharge, null);
      }
      result++;
      if (result % 100 == 0) {
        logger.info("addOrModEssChargeList,{},{}", new Object[] { essCharge.getDeviceId(), result });
      }
    }
    return result;
  }

  public EssChargePlan getLastEssChargePlan(String siteId, String deviceId, PrettyLog prettyLog) {
    return essChargePlanDao.selectOneLast(siteId, deviceId, prettyLog);
  }

  public int addOrModEssChargePlanList(List<EssChargePlan> essChargePlanList, PrettyLog prettyLog) {
    int result = 0;
    for (EssChargePlan essChargePlan : essChargePlanList) {
      // BATCH INSERT
      // essChargePlanDao.insert(essChargePlan, null);
      EssChargePlan selectOneByUnique = essChargePlanDao.selectOneByUnique(essChargePlan.getSiteId(), essChargePlan.getDeviceId(), essChargePlan.getStdTimestamp(), null);
      if (selectOneByUnique == null) {
        essChargePlanDao.insert(essChargePlan, null);
      } else {
        essChargePlan.setEssChgPlanIdx(selectOneByUnique.getEssChgPlanIdx());
        essChargePlanDao.update(essChargePlan, null);
      }
      result++;
      if (result % 100 == 0) {
        logger.info("addOrModEssChargePlanList,{},{}", new Object[] { essChargePlan.getDeviceId(), result });
      }
    }
    return result;
  }

  public EssUsage getLastEssUsage(String siteId, String deviceId, PrettyLog prettyLog) {
    return essUsageDao.selectOneLast(siteId, deviceId, prettyLog);
  }

  public int addOrModEssUsageList(List<EssUsage> essUsageList, PrettyLog prettyLog) {
    int result = 0;
    for (EssUsage essUsage : essUsageList) {
      // BATCH INSERT
      // essUsageDao.insert(essUsage, null);
      EssUsage selectOneByUnique = essUsageDao.selectOneByUnique(essUsage.getSiteId(), essUsage.getDeviceId(), essUsage.getStdDate(), null);
      if (selectOneByUnique == null) {
        essUsageDao.insert(essUsage, null);
      } else {
        essUsage.setEssUsgIdx(selectOneByUnique.getEssUsgIdx());
        essUsageDao.update(essUsage, null);
      }
      result++;
      if (result % 100 == 0) {
        logger.info("addOrModEssUsageList,{},{}", new Object[] { essUsage.getDeviceId(), result });
      }
    }
    return result;
  }

  public List<EssCharge> getEssChargeListBySiteId(String siteId, Date beginDate, Date endDate, PrettyLog prettyLog) {
    return essChargeDao.selectEssChargeListBySiteId(siteId, beginDate, endDate, prettyLog);
  }

  public List<EssUsage> getEssUsageListBySiteId(String siteId, Date beginDate, Date endDate, PrettyLog prettyLog) {
    return essUsageDao.selectEssUsageListBySiteId(siteId, beginDate, endDate, prettyLog);
  }
}
