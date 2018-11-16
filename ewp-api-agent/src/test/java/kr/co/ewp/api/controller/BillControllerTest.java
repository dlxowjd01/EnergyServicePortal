package kr.co.ewp.api.controller;

import java.util.Date;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.google.common.collect.Lists;

import kr.co.ewp.api.entity.Usage;
import kr.co.ewp.api.model.EnergyModel;
import kr.co.ewp.api.model.PeakRequestModel;
import kr.co.ewp.api.model.PeakResponseModel;
import kr.co.ewp.api.service.UsageService;
import kr.co.ewp.api.util.DateUtil;
import kr.co.ewp.api.util.EncoredApiUtil;
import kr.co.ewp.api.util.EncoredApiUtil.Period;
import kr.co.ewp.api.util.JsonUtil;
import kr.co.ewp.api.util.PrettyLog;

@RunWith(SpringRunner.class)
@SpringBootTest
public class BillControllerTest {
  @Autowired
  private UsageService usageService;

  @Test
  public void getPeakHistory() {
    PrettyLog prettyLog = new PrettyLog("getPeakHistory");
    try {
      String siteId = "17094385";
      List<Usage> usageList = usageService.getUsageListBySiteId(siteId, DateUtil.stringToDate("20171001", "yyyyMMdd"), DateUtil.stringToDate("20171201", "yyyyMMdd"), prettyLog);
      PeakRequestModel peakRequest = new PeakRequestModel();
      peakRequest.setMeterDay(30L);
      peakRequest.setPeriod(Period.month);
      EnergyModel energy = new EnergyModel();
      List<Long> timestamp = Lists.newArrayList();
      List<Float> kWh = Lists.newArrayList();
      long preTime = 0;
      for (Usage usage : usageList) {
        long time = usage.getStdTimestamp().getTime();
        timestamp.add(time);
        if (preTime != 0 && time - preTime != 900000) {
          prettyLog.append("TIME-ERROR", preTime + "," + time);
        }
        preTime = time;
        kWh.add(usage.getUsgVal() / 1000000f);
      }
      prettyLog.append("LAST-TIME", preTime);
      energy.setTimestamp(timestamp);
      energy.setkWh(kWh);
      peakRequest.setEnergy(energy);
      PeakResponseModel peak = EncoredApiUtil.getPeak(peakRequest, prettyLog);
      for(Long basetime:peak.getBasetime()){
        System.out.println(DateUtil.dateToString(new Date(basetime), "yyyy-MM-dd HH:mm:ss"));
      }
      System.out.println(JsonUtil.toJson(peak));
    } catch (Exception e) {
      prettyLog.append("ERROR", e.getMessage());
      e.printStackTrace();
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }
}
