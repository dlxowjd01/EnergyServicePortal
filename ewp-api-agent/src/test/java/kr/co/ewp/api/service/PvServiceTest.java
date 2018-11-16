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

import kr.co.ewp.api.entity.PvGen;
import kr.co.ewp.api.util.DateUtil;
import kr.co.ewp.api.util.PrettyLog;

@RunWith(SpringRunner.class)
@SpringBootTest
public class PvServiceTest {
  @Autowired
  private PvService pvService;

  @Test
  @Rollback(false)
  public void addPvGenListTest() {
    PrettyLog prettyLog = new PrettyLog("addPvGenListTest");
    try {
      String siteId = "17094385";// 구례1_전기실
      String deviceId = "a8324a51";// 전기실 테스트
      Date start = DateUtil.stringToDate("20170801", "yyyyMMdd");
      Date end = DateUtil.stringToDate("20180831235959", "yyyyMMddHHmmss");
      List<PvGen> pvGenList = Lists.newArrayList();
      for (long stdDate = start.getTime(); stdDate < end.getTime(); stdDate = DateUtil.getAfterMinute(new Date(stdDate), 15).getTime()) {
        System.out.println("STD_DATE : " + new Date(stdDate));

        PvGen pvGen = new PvGen();
        pvGen.setSiteId(siteId);
        pvGen.setDeviceId(deviceId);
        pvGen.setStdDate(new Date(stdDate));
        pvGen.setGenVal(Integer.parseInt(RandomStringUtils.randomNumeric(2)));
        pvGen.setTemp(Integer.parseInt(RandomStringUtils.randomNumeric(2)));

        pvGenList.add(pvGen);
      }
      pvService.addOrModPvGenList(pvGenList, prettyLog);
    } catch (Exception e) {
      prettyLog.append("ERROR", e.getMessage());
      e.printStackTrace();
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }

}
