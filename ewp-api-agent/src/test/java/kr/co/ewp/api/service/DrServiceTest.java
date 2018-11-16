package kr.co.ewp.api.service;

import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.RandomStringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.junit4.SpringRunner;

import com.google.common.collect.Lists;

import kr.co.ewp.api.entity.DrResult;
import kr.co.ewp.api.util.DateUtil;
import kr.co.ewp.api.util.PrettyLog;

@RunWith(SpringRunner.class)
@SpringBootTest
public class DrServiceTest {
  @Autowired
  private DrService drService;

  @Test
  @Rollback(false)
  public void addOrModDrReusltListTest() {
    PrettyLog prettyLog = new PrettyLog("addDrGenListTest");
    try {
      String siteId = "17094385";// 구례1_전기실
      Date start = DateUtil.stringToDate("20170801", "yyyyMMdd");
      Date end = DateUtil.stringToDate("20180831235959", "yyyyMMddHHmmss");
      List<DrResult> drResultList = Lists.newArrayList();
      for (long stdDate = start.getTime(); stdDate < end.getTime(); stdDate = DateUtil.getAfterMinute(new Date(stdDate), 10000).getTime()) {
        DrResult drResult = new DrResult();
        drResult.setActAmt(Long.parseLong(RandomStringUtils.randomNumeric(4)));
        drResult.setCblAmt(Long.parseLong(RandomStringUtils.randomNumeric(4)));
        drResult.setContractPower(Long.parseLong(RandomStringUtils.randomNumeric(2)));
        drResult.setGoalPower(Long.parseLong(RandomStringUtils.randomNumeric(2)));
        drResult.setEndDate(new Date(stdDate));
        drResult.setEndTimestamp(new Date(stdDate));
        drResult.setRewardAmt(Long.parseLong(RandomStringUtils.randomNumeric(4)));
        drResult.setSiteId(siteId);
        drResult.setStartDate(new Date(stdDate));
        drResult.setStartTimestamp(new Date(stdDate));
        drResultList.add(drResult);
      }
      drService.addOrModDrReusltList(drResultList, null);
    } catch (Exception e) {
      prettyLog.append("ERROR", e.getMessage());
      e.printStackTrace();
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }

}
