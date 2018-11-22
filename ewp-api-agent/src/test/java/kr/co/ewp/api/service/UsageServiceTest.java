package kr.co.ewp.api.service;

import java.util.Date;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.junit4.SpringRunner;

import com.google.common.collect.Lists;

import kr.co.ewp.api.entity.Usage;
import kr.co.ewp.api.model.UsageItemModel;
import kr.co.ewp.api.model.UsageModel;
import kr.co.ewp.api.util.DateUtil;
import kr.co.ewp.api.util.EnertalkApiUtil;
import kr.co.ewp.api.util.EnertalkApiUtil.Period;
import kr.co.ewp.api.util.EnertalkApiUtil.TimeType;
import kr.co.ewp.api.util.EnertalkApiUtil.UsageType;
import kr.co.ewp.api.util.PrettyLog;

@RunWith(SpringRunner.class)
@SpringBootTest
public class UsageServiceTest {
  @Autowired
  private UsageService usageService;

  @Test
  @Rollback(false)
  public void addUsageListTest() {
    PrettyLog prettyLog = new PrettyLog("addUsageListTest");
    try {
      String siteId = "17094385";// 구례1_전기실
      String deviceId = "a8324a51";// 전기실 테스트
      Date start = DateUtil.stringToDate("20170930", "yyyyMMdd");
      Date end = DateUtil.stringToDate("20171001", "yyyyMMdd");
      Period period = Period._15min;
      UsageModel usageModel = EnertalkApiUtil.getUsagePeriodicByDeviceId(deviceId, period, start, end, TimeType.past, UsageType.positiveEnergy, prettyLog);
      List<Usage> usageList = Lists.newArrayList();
      for (UsageItemModel item : usageModel.getItems()) {
        Usage usage = new Usage();
        usage.setDeviceId(deviceId);
        usage.setSiteId(siteId);
        usage.setStdDate(item.getTimestamp());
        usage.setStdTimestamp(item.getTimestamp());
        usage.setUsgVal(item.getUsage().intValue());
        usageList.add(usage);
      }
      usageService.addOrModUsageList(usageList, prettyLog);
    } catch (Exception e) {
      prettyLog.append("ERROR", e.getMessage());
      e.printStackTrace();
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }

}
