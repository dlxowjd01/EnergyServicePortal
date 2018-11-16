package kr.co.ewp.api.controller;

import java.text.ParseException;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import kr.co.ewp.api.entity.Bill;
import kr.co.ewp.api.entity.DrRevenue;
import kr.co.ewp.api.entity.EssCharge;
import kr.co.ewp.api.entity.EssUsage;
import kr.co.ewp.api.entity.GenRevenue;
import kr.co.ewp.api.entity.PvGen;
import kr.co.ewp.api.entity.PvUsage;
import kr.co.ewp.api.entity.Reactive;
import kr.co.ewp.api.entity.Site;
import kr.co.ewp.api.entity.SiteSet;
import kr.co.ewp.api.entity.Usage;
import kr.co.ewp.api.model.BillItemModel;
import kr.co.ewp.api.model.BillRequestModel;
import kr.co.ewp.api.model.BillResponseModel;
import kr.co.ewp.api.model.DrPaymentModel;
import kr.co.ewp.api.model.DrPaymentModel.ReductionPaymentModel;
import kr.co.ewp.api.model.EnergyModel;
import kr.co.ewp.api.model.EssModel;
import kr.co.ewp.api.model.GenRequestModel;
import kr.co.ewp.api.model.GenRequestModel.GenRequestSub;
import kr.co.ewp.api.model.GenResponseModel;
import kr.co.ewp.api.model.GenResponseModel.GenResponseSub;
import kr.co.ewp.api.model.PeakHistoryModel;
import kr.co.ewp.api.model.PeakRequestModel;
import kr.co.ewp.api.model.PeakResponseModel;
import kr.co.ewp.api.model.ReactiveModel;
import kr.co.ewp.api.service.BillService;
import kr.co.ewp.api.service.EssService;
import kr.co.ewp.api.service.PvService;
import kr.co.ewp.api.service.SiteService;
import kr.co.ewp.api.service.UsageService;
import kr.co.ewp.api.util.DateUtil;
import kr.co.ewp.api.util.EncoredApiUtil;
import kr.co.ewp.api.util.EncoredApiUtil.Period;
import kr.co.ewp.api.util.EnertalkApiUtil;
import kr.co.ewp.api.util.IfUtil;
import kr.co.ewp.api.util.PrettyLog;
import kr.co.ewp.api.util.ValidateUtil;

@Component
public class BillController {
  private Logger logger = LoggerFactory.getLogger(EnergyController.class);
  @Autowired
  private BillService billService;
  @Autowired
  private UsageService usageService;
  @Autowired
  private SiteService siteService;
  @Autowired
  private PvService pvService;
  @Autowired
  private EssService essService;

  /**
   * 요금/수익 > 한전요금조회 > 요금
   * 
   * @param siteId
   *          사이트아이디
   * @param begin
   *          시작일 yyyyMMdd
   * @param end
   *          종료일 yyyyMMdd
   * @param prettyLog
   * @throws ParseException
   */
  public void bill01(String siteId, Date begin, Date end, PrettyLog prettyLog) {
    prettyLog.title("요금/수익 > 한전요금조회 > 요금");
    List<Site> siteList = getSiteList(siteId, prettyLog);
    if (end == null) {
      end = new Date();
    }
    prettyLog.append("SITE_CNT", siteList.size());
    Period period = Period.billingMonth;
    int resultCnt = 0;
    for (Site site : siteList) {
      String _siteId = site.getSiteId();
      SiteSet siteSet = siteService.getSiteSet(_siteId, prettyLog);
      if (siteSet == null) {
        prettyLog.append("WARN", _siteId + " SiteSet is null");
        continue;
      }

      Long meterDay = siteSet.getMeterReadDay();

      Date _begin = null;
      Date _end = null;
      Integer lastDate = null;
      if (begin == null) {
        Calendar calendar = DateUtil.getCalendar();
        calendar.add(Calendar.MONTH, -2);
        calendar.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DATE));// 2달전 마지막날
        lastDate = Integer.parseInt(DateUtil.dateToString(calendar, "dd"));
        calendar.set(Calendar.DATE, Math.min(lastDate, meterDay.intValue()));
        calendar.add(Calendar.DATE, 1);
        DateUtil.truncateHms(calendar);
        _begin = calendar.getTime();// 오늘기준 2달전 검침일 다음날
      } else {
        Calendar calendar = DateUtil.getCalendar(begin);
        calendar.add(Calendar.MONTH, -1);
        calendar.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DATE));// 1달전 마지막날
        lastDate = Integer.parseInt(DateUtil.dateToString(calendar, "dd"));
        calendar.set(Calendar.DATE, Math.min(lastDate, meterDay.intValue()));
        calendar.add(Calendar.DATE, 1);
        DateUtil.truncateHms(calendar);
        _begin = calendar.getTime();// 시작일 기준 1달전 검침일 다음날
      }
      if (end == null) {
        Calendar calendar = DateUtil.getCalendar();
        calendar.add(Calendar.MONTH, 1);
        calendar.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DATE));
        lastDate = Integer.parseInt(DateUtil.dateToString(calendar, "dd"));
        calendar.set(Calendar.DATE, Math.min(lastDate, meterDay.intValue()));
        DateUtil.truncateHms(calendar);
        _end = calendar.getTime();// 다음달 검침일
      } else {
        Calendar calendar = DateUtil.getCalendar(end);
        calendar.add(Calendar.MONTH, 1);
        calendar.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DATE));// 1달전 마지막날
        lastDate = Integer.parseInt(DateUtil.dateToString(calendar, "dd"));
        calendar.set(Calendar.DATE, Math.min(lastDate, meterDay.intValue()));
        DateUtil.truncateHms(calendar);
        _end = calendar.getTime();// 종료일 기준 다음달 검침일
      }

      Date beginDate = null;
      Date endDate = null;
      List<Bill> billList = Lists.newArrayList();
      while (true) {
        if (beginDate == null) {
          beginDate = _begin;
        } else {
          Calendar calendar = DateUtil.getCalendar(beginDate);
          calendar.add(Calendar.MONTH, 1);
          calendar.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DATE));//
          lastDate = Integer.parseInt(DateUtil.dateToString(calendar, "dd"));
          calendar.set(Calendar.DATE, Math.min(lastDate, meterDay.intValue()));
          calendar.add(Calendar.DATE, 1);
          DateUtil.truncateHms(calendar);
          beginDate = calendar.getTime();// 다음달 검침일 다음날
        }
        {
          Calendar calendar = DateUtil.getCalendar(beginDate);
          calendar.add(Calendar.MONTH, 1);
          calendar.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DATE));//
          lastDate = Integer.parseInt(DateUtil.dateToString(calendar, "dd"));
          calendar.set(Calendar.DATE, Math.min(lastDate, meterDay.intValue()));
          DateUtil.truncateHms(calendar);
          endDate = calendar.getTime();// 다다음달 검침날

          if (_end.getTime() < endDate.getTime()) {
            break;
          }
        }

        BillRequestModel billRequest = new BillRequestModel();
        billRequest.setMeterDay(meterDay);
        billRequest.setContElec(siteSet.getContractPower());
        billRequest.setPeriod(period);
        billRequest.setPlanName(siteSet.getPlanType());
        {// peakHistory
          List<PeakHistoryModel> peakHistory = Lists.newArrayList();
          Calendar calendar = DateUtil.getCalendar(beginDate);
          calendar.add(Calendar.MONTH, -1);
          calendar.set(Calendar.DATE, 1);
          calendar.add(Calendar.YEAR, -11);
          DateUtil.truncateHms(calendar);
          Date __begin = calendar.getTime();
          Calendar eCal = DateUtil.getCalendar(endDate);
          eCal.add(Calendar.MONTH, -1);
          eCal.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DATE));
          DateUtil.fullHms(eCal);
          Date __end = eCal.getTime();
          String strBeginDate = DateUtil.dateToString(beginDate, "yyyyMMdd");
          String strEndDate = DateUtil.dateToString(endDate, "yyyyMMdd");
          prettyLog.append("BEGIN", strBeginDate);
          prettyLog.append("END", strEndDate);
          logger.info("bill01,{},{},{}", _siteId, strBeginDate, strEndDate);
          List<Usage> usageList = usageService.getUsageListBySiteId(_siteId, __begin, __end, prettyLog);
          if (usageList.size() > 0) {
            PeakRequestModel peakRequest = new PeakRequestModel();
            peakRequest.setMeterDay(meterDay);
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
              kWh.add(usage.getUsgVal() / 1000000f);
            }
            energy.setTimestamp(timestamp);
            energy.setkWh(kWh);
            peakRequest.setEnergy(energy);
            PeakResponseModel peak = EncoredApiUtil.getPeak(peakRequest, prettyLog);
            for (int i = 0; i < peak.getBasetime().size(); i++) {
              peakHistory.add(new PeakHistoryModel(DateUtil.dateToString(new Date(peak.getBasetime().get(i)), "yyyy-MM"), peak.getkW().get(i)));
            }
            peakHistory.sort(new Comparator<PeakHistoryModel>() {
              @Override
              public int compare(PeakHistoryModel o1, PeakHistoryModel o2) {
                return o1.getMonth().compareTo(o2.getMonth());
              }
            });
            billRequest.setPeakHistory(peakHistory);
          }
        }

        {// energy
          EnergyModel energy = new EnergyModel();
          List<Long> timestamp = Lists.newArrayList();
          List<Float> kWh = Lists.newArrayList();
          List<Usage> usageList = usageService.getUsageListBySiteId(_siteId, beginDate, endDate, prettyLog);
          for (Usage usage : usageList) {
            timestamp.add(usage.getStdTimestamp().getTime());
            kWh.add(usage.getUsgVal() / 1000000f);
          }
          energy.setTimestamp(timestamp);
          energy.setkWh(kWh);
          billRequest.setEnergy(energy);
        }
        {// reactive
          ReactiveModel posReactive = new ReactiveModel();
          ReactiveModel negReactive = new ReactiveModel();
          List<Long> timestamp = Lists.newArrayList();
          List<Float> poskWh = Lists.newArrayList();
          List<Float> negkWh = Lists.newArrayList();
          List<Reactive> reactiveList = usageService.getReactiveListBySiteId(_siteId, beginDate, endDate, prettyLog);
          for (Reactive re : reactiveList) {
            timestamp.add(re.getStdTimestamp().getTime());
            poskWh.add(re.getRctvVal() / 1000000f);
            negkWh.add(re.getNegRctvVal() / 1000000f);
          }
          posReactive.setkVarh(poskWh);
          posReactive.setTimestamp(timestamp);
          billRequest.setReactivePos(posReactive);
          negReactive.setkVarh(negkWh);
          negReactive.setTimestamp(timestamp);
          billRequest.setReactiveNeg(negReactive);
        }
        {// ess
          EssModel ess = new EssModel();
          List<Long> timestamp = Lists.newArrayList();
          List<Float> kWh = Lists.newArrayList();
          EssModel ess2 = new EssModel();
          List<Float> kWh2 = Lists.newArrayList();
          List<EssCharge> esschargeList = essService.getEssChargeListBySiteId(_siteId, beginDate, endDate, prettyLog);
          for (EssCharge essCharge : esschargeList) {
            timestamp.add(essCharge.getStdDate().getTime());
            kWh.add(new Float(essCharge.getChgVal()));
            kWh2.add(new Float(essCharge.getDischgVal()));
          }
          ess.setkWh(kWh);
          ess.setTimestamp(timestamp);
          billRequest.setEss(ess);
          ess2.setkWh(kWh2);
          ess2.setTimestamp(timestamp);
          billRequest.setEssDischarging(ess2);
        }
        if (billRequest.getEnergy().getTimestamp().size() == 0 && billRequest.getReactivePos().getTimestamp().size() == 0 && billRequest.getReactiveNeg().getTimestamp().size() == 0
            && billRequest.getEss().getTimestamp().size() == 0) {
          continue;
        }
        try {

          BillResponseModel response = EncoredApiUtil.getBill(billRequest, prettyLog);
          prettyLog.append("ITEM_SIZE", response.getItems().size());
          for (BillItemModel item : response.getItems()) {
            Bill bill = new Bill();
            bill.setBaseRate(item.getBaseRate().intValue());
            bill.setBillYearm(item.getBillOfTheMonth().replaceAll("-", ""));
            bill.setConsumeRate(item.getElectricityConsumptionRate().intValue());
            bill.setContractPower(siteSet.getContractPower().intValue());
            bill.setDemandChgReduct(item.getDemandChargeReduction().intValue());
            bill.setElecFund(item.getElectricityFund().intValue());
            bill.setEnergyChgReduct(item.getEnergyChargeReduction().intValue());
            bill.setEssChgIncen(item.getEssChargingIncentive().intValue());
            bill.setEssChgMaxPeak(item.getEssChargingingInMaxPeak().floatValue());
            bill.setEssChgMidPeak(item.getEssChargingingInMidPeak().floatValue());
            bill.setEssChgOffPeak(item.getEssChargingingInOffPeak().floatValue());
            bill.setEssDischgIncen(item.getEssDischargingIncentive().intValue());
            bill.setEssDischgMaxPeak(item.getEssDischargingInMaxPeak().floatValue());
            bill.setEssDischgMidPeak(item.getEssDischargingInMidPeak().floatValue());
            bill.setEssDischgOffPeak(item.getEssDischargingInOffPeak().floatValue());
            bill.setLagPwrFactor(item.getLaggingPowerFactor().intValue());
            bill.setLeadPwrFactor(item.getLeadingPowerFactor().intValue());
            bill.setMaxPeakRate(item.getOnPeakRate().intValue());
            bill.setMaxPeakUsg(item.getOnPeakEnergyUsage().floatValue());
            bill.setMeterReadDay(meterDay.intValue());
            bill.setMidPeakRate(item.getMidPeakRate().intValue());
            bill.setOffPeakRate(item.getOffPeakRate().intValue());
            bill.setOffPeakUsg(item.getOffPeakEnergyUsage().floatValue());
            bill.setPeakPwrDemand(item.getPeakPowerDemand().floatValue());
            bill.setPlanName(siteSet.getPlanName());
            bill.setPlanType(siteSet.getPlanType());
            bill.setPwrFactorRate(item.getPowerFactorRate().intValue());
            bill.setSiteId(_siteId);
            bill.setSvcEdate(DateUtil.longToString(item.getServicePeriodTo(), "yyyyMMdd"));
            bill.setSvcSdate(DateUtil.longToString(item.getServicePeriodFrom(), "yyyyMMdd"));
            bill.setTotAmtBill(item.getTotalAmountBilled().intValue());
            bill.setTotElecRate(item.getTotalElectricityRate().intValue());
            bill.setUsg(item.getEnergyUsage().floatValue());
            bill.setValAddTax(item.getValueAddedTax().intValue());
            billList.add(bill);
          }
        } catch (Exception e) {
          prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
          logger.error("bill01-ERROR", e);
        }
      }
      resultCnt += billService.addOrModBillList(billList, null);
    }
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  /**
   * @param siteId
   * @param beginMonth
   *          yyyyMM
   * @param endMonth
   *          yyyyMM
   * @param prettyLog
   */
  public void bill03(String siteId, String beginMonth, String endMonth, PrettyLog prettyLog) {
    prettyLog.title("요금/수익 > DR 수익 조회 > DR 수익");
    List<Site> siteList = getSiteList(siteId, prettyLog);
    prettyLog.append("SITE_CNT", siteList.size());
    int resultCnt = 0;
    for (Site site : siteList) {
      String _siteId = site.getSiteId();
      SiteSet siteSet = siteService.getSiteSet(_siteId, prettyLog);
      if (siteSet == null) {
        prettyLog.append("WARN", _siteId + " SiteSet is null");
        continue;
      }
      if (beginMonth == null) {
        DrRevenue bill = billService.getLastDrRevenue(_siteId, prettyLog);
        if (bill == null) {
          beginMonth = DateUtil.getAfterMonths(-1, "yyyyMM");
        } else {
          beginMonth = DateUtil.getAfterMonths(bill.getStdDate(), -1, "yyyyMM");
        }
      } else if (beginMonth.length() == 8) {
        beginMonth = beginMonth.substring(0, 6);
      }
      if (endMonth == null) {
        endMonth = DateUtil.getDateString("yyyyMM");
      } else if (endMonth.length() == 8) {
        endMonth = endMonth.substring(0, 6);
      }
      prettyLog.append("BEGIN", beginMonth);
      prettyLog.append("END", endMonth);
      logger.info("bill03,{},{},{}", _siteId, beginMonth, endMonth);
      try {
        List<DrPaymentModel> payments = EnertalkApiUtil.getDrPayments(_siteId, beginMonth, endMonth, prettyLog);
        List<DrRevenue> drRevenueList = Lists.newArrayList();
        for (DrPaymentModel payment : payments) {
          for (ReductionPaymentModel reduction : payment.getReductionPayments()) {
            DrRevenue drRevenue = new DrRevenue();
            drRevenue.setSiteId(_siteId);
            drRevenue.setStdYearm(payment.getMonth());
            drRevenue.setStdDate(DateUtil.stringToDate(payment.getMonth(), "yyyyMM"));
            drRevenue.setStdTimestamp(drRevenue.getStdDate());
            drRevenue.setBasicPay(payment.getBasicPayment().intValue());
            drRevenue.setBasicPrice(payment.getBasicPrice().intValue());
            drRevenue.setMaxReductRatio(payment.getMaxReductionRatio());
            drRevenue.setMinReductRatio(payment.getMinReductionRatio());
            drRevenue.setTotPay(payment.getTotalPayment().intValue());
            drRevenue.setReductCap(payment.getReductionCapacity().intValue());
            drRevenue.setActAmt(reduction.getActualAmount().intValue());
            drRevenue.setCblAmt(reduction.getCblAmount().intValue());
            drRevenue.setReductAmt(reduction.getReductionAmount().intValue());
            drRevenue.setReductEdate(reduction.getEnd());
            drRevenue.setReductEtimestamp(reduction.getEnd());
            drRevenue.setReductSdate(reduction.getStart());
            drRevenue.setReductStimestamp(reduction.getStart());
            drRevenue.setSmp(reduction.getSmp().intValue());
            drRevenueList.add(drRevenue);
          }
          resultCnt += billService.addOrModDrRevenueList(drRevenueList, null);
        }
      } catch (Exception e) {
        prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
        logger.error("bill03-ERROR", e);
      }
    }
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  public void bill04(String siteId, Date begin, Date end, PrettyLog prettyLog) {
    prettyLog.title("요금/수익 > PV 수익 조회 > 발전수익");
    List<Site> siteList = getSiteList(siteId, prettyLog);
    if (end == null) {
      end = new Date();
    }
    prettyLog.append("SITE_CNT", siteList.size());
    Period period = Period._15min;
    int resultCnt = 0;
    for (Site site : siteList) {
      String _siteId = site.getSiteId();
      SiteSet siteSet = siteService.getSiteSet(_siteId, prettyLog);
      if (siteSet == null) {
        prettyLog.append("WARN", _siteId + " SiteSet is null");
        continue;
      }
      Date _begin = null;
      if (begin == null) {
        GenRevenue bill = billService.getLastGenRevenue(_siteId, prettyLog);
        if (bill == null) {
          _begin = DateUtil.getAfterDays(-1);
        } else {
          _begin = new Date(bill.getStdTimestamp().getTime() + 1);
        }
      } else {
        _begin = begin;
      }
      Date beginDate = null;
      Date endDate = null;
      while (!end.equals(endDate)) {
        if (beginDate == null) {
          beginDate = _begin;
        } else {
          beginDate = DateUtil.getNextMonthFirstDate(beginDate);
        }
        Date lastDate = DateUtil.getMonthLastDate(beginDate);
        if (end.getTime() > lastDate.getTime()) {
          endDate = lastDate;
        } else {
          endDate = end;
        }
        String strBeginDate = DateUtil.dateToString(beginDate, "yyyyMMdd");
        String strEndDate = DateUtil.dateToString(endDate, "yyyyMMdd");
        prettyLog.append("BEGIN", strBeginDate);
        prettyLog.append("END", strEndDate);
        logger.info("bill04,{},{},{}", _siteId, strBeginDate, strEndDate);
        GenRequestModel genRequest = new GenRequestModel();
        genRequest.setPeriod(period);
        genRequest.setMeterDay(siteSet.getMeterReadDay());
        genRequest.setRecRate(siteSet.getRecRate());
        genRequest.setSmpRate(siteSet.getSmpRate());
        List<GenRequestSub> by = Lists.newArrayList();
        genRequest.setBy(by);
        List<PvGen> pvGenList = pvService.getPvGenListBySiteId(_siteId, beginDate, endDate, prettyLog);
        List<PvUsage> pvUsageList = Lists.newArrayList();// pvService.getPvUsageListBySiteId(site.getSiteId(), beginDate, endDate, prettyLog);
        List<EssCharge> essChargeList = essService.getEssChargeListBySiteId(_siteId, beginDate, endDate, prettyLog);
        List<EssUsage> essUsageList = essService.getEssUsageListBySiteId(_siteId, beginDate, endDate, prettyLog);
        Map<Long/* stdDate */, Integer /* pvGenVal */> pvGenMap = Maps.newHashMap();
        Map<Long/* stdDate */, Integer /* pvUsageVal */> pvUsgMap = Maps.newHashMap();
        Map<Long/* stdDate */, Integer /* essChargeVal */> essChargeMap = Maps.newHashMap();
        Map<Long/* stdDate */, Integer /* essUsageVal */> essUsgMap = Maps.newHashMap();
        for (PvGen item : pvGenList) {
          pvGenMap.put(item.getStdDate().getTime(), item.getGenVal());
        }
        for (PvUsage item : pvUsageList) {
          pvUsgMap.put(item.getStdDate().getTime(), item.getUsgVal());
        }
        for (EssCharge item : essChargeList) {
          essChargeMap.put(item.getStdDate().getTime(), item.getChgVal());
        }
        for (EssUsage item : essUsageList) {
          essUsgMap.put(item.getStdDate().getTime(), item.getUsgVal());
        }
        GenRequestSub genReqPv = new GenRequestSub();
        GenRequestSub genReqEss = new GenRequestSub();
        genReqPv.setLabel("gen_pv");
        genReqEss.setLabel("gen_ess");
        genReqPv.setRecWeight(siteSet.getRecWeight());
        genReqEss.setRecWeight(siteSet.getRecWeight());
        by.add(genReqPv);
        by.add(genReqEss);
        for (long stdDate = beginDate.getTime(); stdDate < endDate.getTime(); stdDate = DateUtil.getAfterMinute(new Date(stdDate), 15).getTime()) {
          genReqPv.addTimestamp(stdDate);
          genReqPv.addProduced(new Double(IfUtil.nvl(pvGenMap.get(stdDate), 0)));
          genReqPv.addConsumed(new Double(IfUtil.nvl(pvUsgMap.get(stdDate), 0)));
          genReqEss.addTimestamp(stdDate);
          genReqEss.addProduced(new Double(IfUtil.nvl(essChargeMap.get(stdDate), 0)));
          genReqEss.addConsumed(new Double(IfUtil.nvl(essUsgMap.get(stdDate), 0)));
        }
        if (genReqPv.getTimestamp() == null || genReqPv.getTimestamp().size() == 0) {
          continue;
        }
        GenResponseModel response = EncoredApiUtil.getGen(genRequest, prettyLog);
        List<GenRevenue> genRevenueList = Lists.newArrayList();
        try {
          GenResponseSub genEss = response.getGenEss();
          GenResponseSub genPv = response.getGenPv();
          int essSize = genEss.getBasetime().size();
          int pvSize = genPv.getBasetime().size();
          prettyLog.append("ITEM_SIZE", essSize);
          for (int i = 0; i < essSize; i++) {
            GenRevenue genRevenue = new GenRevenue();
            genRevenue.setSiteId(_siteId);
            genRevenue.setStdDate(new Date(genEss.getBasetime().get(i)));
            genRevenue.setStdTimestamp(genRevenue.getStdDate());
            genRevenue.setMeterReadDay(siteSet.getMeterReadDay().intValue());
            genRevenue.setGenType("2");
            genRevenue.setConsumeVal(genEss.getConsumed().get(i));
            genRevenue.setNetGenVal(genEss.getNetGeneration().get(i));
            genRevenue.setProduceVal(genEss.getProduced().get(i));
            genRevenue.setRecPrice(genEss.getRecPrice().get(i));
            genRevenue.setSmpPrice(genEss.getSmpPrice().get(i));
            genRevenue.setTotPrice(genEss.getRevenues().get(i));
            genRevenue.setRecWeight(siteSet.getRecRate());
            genRevenue.setSmpRate(siteSet.getSmpRate());
            genRevenueList.add(genRevenue);
          }
          for (int i = 0; i < pvSize; i++) {
            GenRevenue genRevenue = new GenRevenue();
            genRevenue.setSiteId(_siteId);
            genRevenue.setStdDate(new Date(genPv.getBasetime().get(i)));
            genRevenue.setStdTimestamp(genRevenue.getStdDate());
            genRevenue.setMeterReadDay(siteSet.getMeterReadDay().intValue());
            genRevenue.setGenType("1");
            genRevenue.setConsumeVal(genPv.getConsumed().get(i));
            genRevenue.setNetGenVal(genPv.getNetGeneration().get(i));
            genRevenue.setProduceVal(genPv.getProduced().get(i));
            genRevenue.setRecPrice(genPv.getRecPrice().get(i));
            genRevenue.setSmpPrice(genPv.getSmpPrice().get(i));
            genRevenue.setTotPrice(genPv.getRevenues().get(i));
            genRevenue.setRecWeight(siteSet.getRecRate());
            genRevenue.setSmpRate(siteSet.getSmpRate());
            genRevenueList.add(genRevenue);
          }
        } catch (Exception e) {
          prettyLog.append("ERROR", e == null ? "Null" : e.getMessage());
          logger.error("energy01-ERROR", e);
        }
        resultCnt += billService.addOrModGenRevenueList(genRevenueList, null);
      }
    }
    prettyLog.append("RESULT_CNT", resultCnt);
  }

  private List<Site> getSiteList(String siteId, PrettyLog prettyLog) {
    List<Site> siteList = null;
    if (siteId != null) {
      siteList = Lists.newArrayList();
      siteList.add(siteService.getSite(siteId, prettyLog));
    } else {
      siteList = siteService.getSiteList(prettyLog);
      ValidateUtil.notEmpty(siteList, "사이트 목록을 찾을 수 없습니다");
    }
    return siteList;
  }
}
