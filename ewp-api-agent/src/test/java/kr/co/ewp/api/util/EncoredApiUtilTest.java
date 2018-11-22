package kr.co.ewp.api.util;

import java.util.Calendar;
import java.util.List;

import com.google.common.collect.Lists;

import kr.co.ewp.api.model.BillRequestModel;
import kr.co.ewp.api.model.BillResponseModel;
import kr.co.ewp.api.model.EnergyModel;
import kr.co.ewp.api.model.EssModel;
import kr.co.ewp.api.model.GenRequestModel;
import kr.co.ewp.api.model.GenRequestModel.GenRequestSub;
import kr.co.ewp.api.util.EncoredApiUtil.Period;
import kr.co.ewp.api.model.GenResponseModel;
import kr.co.ewp.api.model.PeakHistoryModel;
import kr.co.ewp.api.model.PeakRequestModel;
import kr.co.ewp.api.model.PeakResponseModel;
import kr.co.ewp.api.model.ReactiveModel;

public class EncoredApiUtilTest {
  public static void main(String[] args) {
//    EncoredApiUtilTest.getPeakTest();
    getBillTest();
  }

  public static void getGenTest() {
    PrettyLog prettyLog = new PrettyLog("getGenTest");
    try {
      EncoredApiUtil.Period period = EncoredApiUtil.Period.hour;
      GenRequestModel genRequest = new GenRequestModel();
      genRequest.setSmpRate(89.72);
      genRequest.setRecRate(39.72);
      genRequest.setPeriod(period);

      List<GenRequestSub> by = Lists.newArrayList();

      genRequest.setBy(by);
      GenRequestSub sub1 = new GenRequestSub();
      GenRequestSub sub2 = new GenRequestSub();
      by.add(sub1);
      by.add(sub2);

      sub1.setLabel("gen_pv");
      sub1.setRecWeight(1d);
      sub1.addTimestamp(1529366400000L);
      sub1.addTimestamp(1529367300000L);
      sub1.addTimestamp(1529368200000L);
      sub1.addTimestamp(1529369100000L);
      sub1.addTimestamp(1529370000000L);
      sub1.addTimestamp(1529370900000L);
      sub1.addTimestamp(1529371800000L);
      sub1.addTimestamp(1529372700000L);
      sub1.addTimestamp(1529373600000L);
      sub1.addProduced(119.0432090997);
      sub1.addProduced(119.0432090997);
      sub1.addProduced(119.0432090997);
      sub1.addProduced(119.0432090997);
      sub1.addProduced(119.0432090997);
      sub1.addProduced(119.0432090997);
      sub1.addProduced(119.0432090997);
      sub1.addProduced(119.0432090997);
      sub1.addProduced(119.0432090997);
      sub1.addConsumed(19.0432090997);
      sub1.addConsumed(19.0432090997);
      sub1.addConsumed(19.0432090997);
      sub1.addConsumed(19.0432090997);
      sub1.addConsumed(19.0432090997);
      sub1.addConsumed(19.0432090997);
      sub1.addConsumed(19.0432090997);
      sub1.addConsumed(19.0432090997);
      sub1.addConsumed(19.0432090997);

      sub2.setLabel("gen_ess");
      sub2.setRecWeight(5d);
      sub2.addTimestamp(1529366400000L);
      sub2.addTimestamp(1529367300000L);
      sub2.addTimestamp(1529368200000L);
      sub2.addTimestamp(1529369100000L);
      sub2.addTimestamp(1529370000000L);
      sub2.addTimestamp(1529370900000L);
      sub2.addTimestamp(1529371800000L);
      sub2.addTimestamp(1529372700000L);
      sub2.addTimestamp(1529373600000L);

      sub2.addProduced(119.0432090997);
      sub2.addProduced(119.0432090997);
      sub2.addProduced(119.0432090997);
      sub2.addProduced(119.0432090997);
      sub2.addProduced(119.0432090997);
      sub2.addProduced(119.0432090997);
      sub2.addProduced(119.0432090997);
      sub2.addProduced(119.0432090997);
      sub2.addProduced(119.0432090997);
      sub2.addConsumed(19.0432090997);
      sub2.addConsumed(19.0432090997);
      sub2.addConsumed(19.0432090997);
      sub2.addConsumed(19.0432090997);
      sub2.addConsumed(19.0432090997);
      sub2.addConsumed(19.0432090997);
      sub2.addConsumed(19.0432090997);
      sub2.addConsumed(19.0432090997);
      sub2.addConsumed(19.0432090997);
      GenResponseModel genResponse = EncoredApiUtil.getGen(genRequest, prettyLog);
      prettyLog.append("RESULT", JsonUtil.toJson(genResponse));
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }

  public static void getBillTest() {
    PrettyLog prettyLog = new PrettyLog("getBillTest");
    Period period = Period.day;
    try {
      // EncoredApiUtil.Period period = EncoredApiUtil.Period.hour;
      BillRequestModel billRequest = new BillRequestModel();
      billRequest.setMeterDay(19L);
      billRequest.setContElec(970L);
       billRequest.setPeriod(period);
      billRequest.setPlanName("industrial_B_high_voltage_A_option2");
      List<PeakHistoryModel> peakHistory = Lists.newArrayList();
      peakHistory.add(new PeakHistoryModel("2016-01", 748.36f));
      peakHistory.add(new PeakHistoryModel("2016-02", 724.88f));
      peakHistory.add(new PeakHistoryModel("2016-03", 619.92f));
      peakHistory.add(new PeakHistoryModel("2016-04", 620.64f));
      peakHistory.add(new PeakHistoryModel("2016-05", 590.84f));
      peakHistory.add(new PeakHistoryModel("2016-06", 621.64f));
      peakHistory.add(new PeakHistoryModel("2016-07", 660.08f));
      peakHistory.add(new PeakHistoryModel("2016-08", 735.40f));
      peakHistory.add(new PeakHistoryModel("2016-09", 703.88f));
      peakHistory.add(new PeakHistoryModel("2016-10", 635.20f));
      peakHistory.add(new PeakHistoryModel("2016-11", 608.24f));
      peakHistory.add(new PeakHistoryModel("2016-12", 693.52f));
      billRequest.setPeakHistory(peakHistory);
      
      EnergyModel energy = new EnergyModel();
      List<Long> timestamp = Lists.newArrayList();
      List<Float> kWh = Lists.newArrayList();
      Calendar cal1 = Calendar.getInstance();
      cal1.set(2018, 10-1, 1, 0, 0, 0);
      Calendar cal2 = Calendar.getInstance();
      cal2.set(2018, 10-1, 31, 23, 59, 59);
//      Long a = 0L;
      while(cal1.getTime().getTime()<=cal2.getTime().getTime()) {
    	  timestamp.add(cal1.getTime().getTime());
    	  kWh.add(6.66f);
    	  cal1.add(Calendar.MINUTE, 15);
      }
      
//      timestamp.add(1483228800000L);
//      timestamp.add(1483229700000L);
//      timestamp.add(1483230600000L);
//      timestamp.add(1483231500000L);
//      timestamp.add(1483232400000L);
//      timestamp.add(1483233300000L);
//      timestamp.add(1483234200000L);
//      timestamp.add(1483235100000L);
//      kWh.add(6.66f);
//      kWh.add(6.26f);
//      kWh.add(5.76f);
//      kWh.add(5.98f);
//      kWh.add(5.76f);
//      kWh.add(6.19f);
//      kWh.add(6.73f);
//      kWh.add(7.09f);
      energy.setTimestamp(timestamp);
      energy.setkWh(kWh);
      billRequest.setEnergy(energy);
      ReactiveModel reactive = new ReactiveModel();
      reactive.setkVarh(kWh);
      reactive.setTimestamp(timestamp);
      billRequest.setReactivePos(reactive);
      
      EnergyModel energy2 = new EnergyModel();
      List<Long> timestamp2 = Lists.newArrayList();
      List<Float> kWh2 = Lists.newArrayList();
      while(cal1.getTime().getTime()<=cal2.getTime().getTime()) {
//    	  timestamp.add(cal1.getTime().getTime());
    	  kWh.add(7.09f);
    	  kWh2.add(5.66f);
    	  cal1.add(Calendar.MINUTE, 15);
      }
//      timestamp2.add(1483228800000L);
//      timestamp2.add(1484229700000L);
//      timestamp2.add(1483230600000L);
//      timestamp2.add(1483221500000L);
//      timestamp2.add(1483232400000L);
//      timestamp2.add(1483233300000L);
//      timestamp2.add(1483231200000L);
//      timestamp2.add(1483535100000L);
//      kWh2.add(5.66f);
//      kWh2.add(6.26f);
//      kWh2.add(5.76f);
//      kWh2.add(7.98f);
//      kWh2.add(5.76f);
//      kWh2.add(6.19f);
//      kWh2.add(6.73f);
//      kWh2.add(7.09f);
//      energy2.setTimestamp(timestamp);
//      energy2.setkWh(kWh);
//      billRequest.setEnergy(energy2);
      ReactiveModel reactive2 = new ReactiveModel();
      reactive2.setkVarh(kWh);
      reactive2.setTimestamp(timestamp);
      billRequest.setReactiveNeg(reactive2);
      
      EssModel ess = new EssModel();
      ess.setkWh(kWh);
      ess.setTimestamp(timestamp);
      billRequest.setEssCharging(ess);
      EssModel ess2 = new EssModel();
      ess2.setkWh(kWh2);
      ess2.setTimestamp(timestamp);
      billRequest.setEssDischarging(ess2);
      BillResponseModel billResponse = EncoredApiUtil.getBill(billRequest, prettyLog);
      prettyLog.append("RESULTzzzzzz", JsonUtil.toJson(billResponse));
      System.out.println(JsonUtil.toJson(billResponse));
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }

  public static void getPeakTest() {
    PrettyLog prettyLog = new PrettyLog("getPeakTest");
    try {
      EncoredApiUtil.Period period = EncoredApiUtil.Period._15min;
      PeakRequestModel peakRequest = new PeakRequestModel();
      peakRequest.setMeterDay(2L);
      peakRequest.setPeriod(period);
      EnergyModel energy = new EnergyModel();
      List<Long> timestamp = Lists.newArrayList();
      List<Float> kWh = Lists.newArrayList();
      timestamp.add(1483228800000L);
      timestamp.add(1483229700000L);
      timestamp.add(1483230600000L);
      timestamp.add(1483231500000L);
      timestamp.add(1483232400000L);
      timestamp.add(1483233300000L);
      timestamp.add(1483234200000L);
      timestamp.add(1483235100000L);
      kWh.add(6.66f);
      kWh.add(6.26f);
      kWh.add(5.76f);
      kWh.add(5.98f);
      kWh.add(5.76f);
      kWh.add(6.19f);
      kWh.add(6.73f);
      kWh.add(7.09f);
      energy.setTimestamp(timestamp);
      energy.setkWh(kWh);
      peakRequest.setEnergy(energy);
      PeakResponseModel peakResponse = EncoredApiUtil.getPeak(peakRequest, prettyLog);
      prettyLog.append("RESULT", JsonUtil.toJson(peakResponse));
    } finally {
      prettyLog.stop();
      System.out.println(prettyLog.prettyPrint());
    }
  }
}
