package kr.co.ewp.api.service;

import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ewp.api.dao.PeakDao;
import kr.co.ewp.api.dao.PredictPeakDao;
import kr.co.ewp.api.dao.PredictUsageDao;
import kr.co.ewp.api.dao.ReactiveDao;
import kr.co.ewp.api.dao.UsageDao;
import kr.co.ewp.api.entity.Peak;
import kr.co.ewp.api.entity.PredictPeak;
import kr.co.ewp.api.entity.PredictUsage;
import kr.co.ewp.api.entity.Reactive;
import kr.co.ewp.api.entity.Usage;
import kr.co.ewp.api.util.PrettyLog;

@Service
@Transactional
public class UsageService {
  private Logger logger = LoggerFactory.getLogger(UsageService.class);
  @Autowired
  private UsageDao usageDao;
  @Autowired
  private PredictUsageDao predictUsageDao;
  @Autowired
  private ReactiveDao reactiveDao;
  @Autowired
  private PeakDao peakDao;
  @Autowired
  private PredictPeakDao predictPeakDao;

  public int addOrModUsageList(List<Usage> usageList, PrettyLog prettyLog) {
    int result = 0;
    for (Usage usage : usageList) {
      // BATCH INSERT
      // usageDao.insert(usage, prettyLog);
      Usage selectOneByUnique = usageDao.selectOneByUnique(usage.getSiteId(), usage.getDeviceId(), usage.getStdTimestamp(), null);
      if (selectOneByUnique == null) {
        usageDao.insert(usage, null);
      } else {
        usage.setUsgIdx(selectOneByUnique.getUsgIdx());
        usageDao.update(usage, null);
      }
      result++;
      if (result % 100 == 0) {
        logger.info("addOrModUsageList,{},{}", new Object[] { usage.getDeviceId(), result });
      }
    }
    return result;
  }

  public int addOrModPredictUsageList(List<PredictUsage> usageList, PrettyLog prettyLog) {
    int result = 0;
    for (PredictUsage predictUsage : usageList) {
      // BATCH INSERT
      // predictUsageDao.insert(predictUsage, prettyLog);
      PredictUsage selectOneByUnique = predictUsageDao.selectOneByUnique(predictUsage.getSiteId(), predictUsage.getDeviceId(), predictUsage.getStdTimestamp(), null);
      if (selectOneByUnique == null) {
        predictUsageDao.insert(predictUsage, null);
      } else {
        predictUsage.setPreUsgIdx(selectOneByUnique.getPreUsgIdx());
        predictUsageDao.update(predictUsage, null);
      }
      result++;
      if (result % 100 == 0) {
        logger.info("addOrModPredictUsageList,{},{}", new Object[] { predictUsage.getDeviceId(), result });
      }
    }
    return result;
  }

  public int addOrModReactiveList(List<Reactive> reactiveList, PrettyLog prettyLog) {
    int result = 0;
    for (Reactive reactive : reactiveList) {
      // BATCH INSERT
      // reactiveDao.insert(reactive, prettyLog);
      Reactive selectOneByUnique = reactiveDao.selectOneByUnique(reactive.getSiteId(), reactive.getDeviceId(), reactive.getStdTimestamp(), null);
      if (selectOneByUnique == null) {
        reactiveDao.insert(reactive, null);
      } else {
        reactive.setRctvIdx(selectOneByUnique.getRctvIdx());
        reactiveDao.update(reactive, null);
      }
      result++;
      if (result % 100 == 0) {
        logger.info("addOrModReactiveList,{},{}", new Object[] { reactive.getDeviceId(), result });
      }
    }
    return result;
  }

  @Transactional(readOnly = true)
  public Usage getLastUage(String siteId, String deviceId, PrettyLog prettyLog) {
    return usageDao.selectOneLastUage(siteId, deviceId, prettyLog);
  }

  @Transactional(readOnly = true)
  public PredictUsage getLastPredictUage(String siteId, String deviceId, PrettyLog prettyLog) {
    return predictUsageDao.selectOneLastPredictUage(siteId, deviceId, prettyLog);
  }

  @Transactional(readOnly = true)
  public Reactive getLastReactive(String siteId, String deviceId, PrettyLog prettyLog) {
    return reactiveDao.selectOneLastReactive(siteId, deviceId, prettyLog);
  }

  @Transactional(readOnly = true)
  public List<Reactive> getReactiveListBySiteId(String siteId, Date begin, Date end, PrettyLog prettyLog) {
    return reactiveDao.selectReactiveListBySiteId(siteId, begin, end, prettyLog);
  }

  @Transactional(readOnly = true)
  public Peak getLastPeak(String siteId, PrettyLog prettyLog) {
    return peakDao.selectOneLastPeak(siteId, prettyLog);
  }

  @Transactional(readOnly = true)
  public PredictPeak getLastPredictPeak(String siteId, PrettyLog prettyLog) {
    return predictPeakDao.selectOneLastPredictPeak(siteId, prettyLog);
  }

  @Transactional(readOnly = true)
  public List<Usage> getUsageList(String deviceId, Date begin, Date end, PrettyLog prettyLog) {
    return usageDao.selectListByDeviceId(deviceId, begin, end, prettyLog);
  }

  @Transactional(readOnly = true)
  public List<Usage> getUsageListBySiteId(String siteId, Date begin, Date end, PrettyLog prettyLog) {
    return usageDao.selectListBySiteId(siteId, begin, end, prettyLog);
  }

  @Transactional(readOnly = true)
  public List<PredictUsage> getPredictUsageList(String deviceId, Date begin, Date end, PrettyLog prettyLog) {
    return predictUsageDao.selectListByDeviceId(deviceId, begin, end, prettyLog);
  }

  public int addOrModPeakList(List<Peak> peakList, PrettyLog prettyLog) {
    int result = 0;
    for (Peak peak : peakList) {
      Peak selectOneByUnique = peakDao.selectOneByUnique(peak.getSiteId(), peak.getStdTimestamp(), null);
      if (selectOneByUnique == null) {
        peakDao.insert(peak, null);
      } else {
        peak.setPeakIdx(selectOneByUnique.getPeakIdx());
        peakDao.update(peak, null);
      }
      result++;
      if (result % 100 == 0) {
        logger.info("addOrModPeakList,{},{}", new Object[] { peak.getSiteId(), result });
      }
    }
    return result;
  }

  public int addOrModPredictPeakList(List<PredictPeak> peakList, PrettyLog prettyLog) {
    int result = 0;
    for (PredictPeak predictPeak : peakList) {
      // INSERT BATCH
      // predictPeakDao.insert(predictPeak, prettyLog);
      PredictPeak selectOneByUnique = predictPeakDao.selectOneByUnique(predictPeak.getSiteId(), predictPeak.getStdTimestamp(), null);
      if (selectOneByUnique == null) {
        predictPeakDao.insert(predictPeak, null);
      } else {
        predictPeak.setPrePeakIdx(selectOneByUnique.getPrePeakIdx());
        predictPeakDao.update(predictPeak, null);
      }
      result++;
      if (result % 100 == 0) {
        logger.info("addOrModPredictPeakList,{},{}", new Object[] { predictPeak.getSiteId(), result });
      }
    }
    return result;
  }

}
