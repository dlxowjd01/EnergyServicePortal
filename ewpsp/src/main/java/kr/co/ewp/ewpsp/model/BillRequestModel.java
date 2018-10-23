package kr.co.ewp.ewpsp.model;

import java.util.Date;
import java.util.List;

import kr.co.ewp.ewpsp.common.util.EncoredApiUtil.Period;

public class BillRequestModel {
  private Period period;//
  private Long meterDay;// 30 검침일 (defaul 30)
  private String planName;// "industrial_B_high_voltage_A_option2" 요금제
  private Long contElec;// 970 계약전력
  private Date timestamp;// ‘ms’ 1483228800000 unix timestamp
  private Float kWh;// kWh 100 전력량
  private List<PeakHistoryModel> peakHistory;// 과거 1년 월별최대 수요
  private EnergyModel energy; // power List of timestamp and kWh 전력
  private ReactiveModel reactive;// List of timestamp and kVarh 무효 전력
  private EssModel ess;// List of timestamp and kWh output power of ess

  public Period getPeriod() {
    return period;
  }

  public void setPeriod(Period period) {
    this.period = period;
  }

  public Long getMeterDay() {
    return meterDay;
  }

  public void setMeterDay(Long meterDay) {
    this.meterDay = meterDay;
  }

  public String getPlanName() {
    return planName;
  }

  public void setPlanName(String planName) {
    this.planName = planName;
  }

  public Long getContElec() {
    return contElec;
  }

  public void setContElec(Long contElec) {
    this.contElec = contElec;
  }

  public Date getTimestamp() {
    return timestamp;
  }

  public void setTimestamp(Date timestamp) {
    this.timestamp = timestamp;
  }

  public Float getkWh() {
    return kWh;
  }

  public void setkWh(Float kWh) {
    this.kWh = kWh;
  }

  public List<PeakHistoryModel> getPeakHistory() {
    return peakHistory;
  }

  public void setPeakHistory(List<PeakHistoryModel> peakHistory) {
    this.peakHistory = peakHistory;
  }

  public EnergyModel getEnergy() {
    return energy;
  }

  public void setEnergy(EnergyModel energy) {
    this.energy = energy;
  }

  public ReactiveModel getReactive() {
    return reactive;
  }

  public void setReactive(ReactiveModel reactive) {
    this.reactive = reactive;
  }

  public EssModel getEss() {
    return ess;
  }

  public void setEss(EssModel ess) {
    this.ess = ess;
  }

@Override
public String toString() {
	return "BillRequestModel [period=" + period + ", meterDay=" + meterDay + ", planName=" + planName + ", contElec="
			+ contElec + ", timestamp=" + timestamp + ", kWh=" + kWh + ", peakHistory=" + peakHistory + ", energy="
			+ energy + ", reactive=" + reactive + ", ess=" + ess + "]";
}

}
