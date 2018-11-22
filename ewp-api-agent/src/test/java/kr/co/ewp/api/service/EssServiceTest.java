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

import kr.co.ewp.api.entity.EssCharge;
import kr.co.ewp.api.entity.EssChargePlan;
import kr.co.ewp.api.entity.EssUsage;
import kr.co.ewp.api.util.DateUtil;
import kr.co.ewp.api.util.PrettyLog;

@RunWith(SpringRunner.class)
@SpringBootTest
public class EssServiceTest {
  @Autowired
  private EssService essService;

  @Test
  @Rollback(false)
  public void addEssChargeListTest() {
    PrettyLog prettyLog = new PrettyLog("addEssListTest");
    try {
      String siteId = "17094385";// 구례1_전기실
      String deviceId = "a8324a51";// 전기실 테스트
      Date start = DateUtil.stringToDate("20170801", "yyyyMMdd");
      Date end = DateUtil.stringToDate("20180831235959", "yyyyMMddHHmmss");
      List<EssCharge> essChargeList = Lists.newArrayList();
      for (long stdDate = start.getTime(); stdDate < end.getTime(); stdDate = DateUtil.getAfterMinute(new Date(stdDate), 15).getTime()) {
        System.out.println("STD_DATE : " + new Date(stdDate));
        EssCharge essCharge = new EssCharge();
        essCharge.setDeviceId(deviceId);
        essCharge.setSiteId(siteId);
        essCharge.setStdDate(new Date(stdDate));
        essCharge.setStdTimestamp(new Date(stdDate));
        essCharge.setChgVal(Integer.parseInt(RandomStringUtils.randomNumeric(2)));
        essCharge.setDischgVal(Integer.parseInt(RandomStringUtils.randomNumeric(2)));

        essChargeList.add(essCharge);
      }
      essService.addOrModEssChargeList(essChargeList, prettyLog);
    } catch (Exception e) {
      prettyLog.append("ERROR", e.getMessage());
      e.printStackTrace();
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }

  @Test
  @Rollback(false)
  public void addEssChargePlanListTest() {
    PrettyLog prettyLog = new PrettyLog("addEssChargePlanListTest");
    try {
      String siteId = "17094385";// 구례1_전기실
      String deviceId = "a8324a51";// 전기실 테스트
      Date start = DateUtil.stringToDate("20170801", "yyyyMMdd");
      Date end = DateUtil.stringToDate("20180831235959", "yyyyMMddHHmmss");
      List<EssChargePlan> essChargeList = Lists.newArrayList();
      for (long stdDate = start.getTime(); stdDate < end.getTime(); stdDate = DateUtil.getAfterMinute(new Date(stdDate), 15).getTime()) {
        System.out.println("STD_DATE : " + new Date(stdDate));
        EssChargePlan essChargePlan = new EssChargePlan();
        essChargePlan.setDeviceId(deviceId);
        essChargePlan.setSiteId(siteId);
        essChargePlan.setStdDate(new Date(stdDate));
        essChargePlan.setStdTimestamp(new Date(stdDate));
        essChargePlan.setChgVal(Integer.parseInt(RandomStringUtils.randomNumeric(2)));
        essChargePlan.setDischgVal(Integer.parseInt(RandomStringUtils.randomNumeric(2)));

        essChargeList.add(essChargePlan);
      }
      essService.addOrModEssChargePlanList(essChargeList, prettyLog);
    } catch (Exception e) {
      prettyLog.append("ERROR", e.getMessage());
      e.printStackTrace();
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }

  @Test
  @Rollback(false)
  public void addEssUsageListTest() {
    PrettyLog prettyLog = new PrettyLog("addEssUsageListTest");
    try {
      String siteId = "17094385";// 구례1_전기실
      String deviceId = "a8324a51";// 전기실 테스트
      Date start = DateUtil.stringToDate("20170801", "yyyyMMdd");
      Date end = DateUtil.stringToDate("20180831235959", "yyyyMMddHHmmss");
      List<EssUsage> essChargeList = Lists.newArrayList();
      for (long stdDate = start.getTime(); stdDate < end.getTime(); stdDate = DateUtil.getAfterMinute(new Date(stdDate), 15).getTime()) {
        System.out.println("STD_DATE : " + new Date(stdDate));
        EssUsage essUsage = new EssUsage();
        essUsage.setDeviceId(deviceId);
        essUsage.setSiteId(siteId);

        essUsage.setUsgVal(Integer.parseInt(RandomStringUtils.randomNumeric(2)));

        essChargeList.add(essUsage);
      }
      essService.addOrModEssUsageList(essChargeList, prettyLog);
    } catch (Exception e) {
      prettyLog.append("ERROR", e.getMessage());
      e.printStackTrace();
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }

}
