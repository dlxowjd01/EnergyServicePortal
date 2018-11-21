package kr.co.ewp.api.model;

import kr.co.ewp.api.util.EncoredApiUtil;

public class PeakRequestModel {
  private EncoredApiUtil.Period period;
  private Long meterDay;// 검침일
  private EnergyModel energy;

  public EncoredApiUtil.Period getPeriod() {
    return period;
  }

  public void setPeriod(EncoredApiUtil.Period period) {
    this.period = period;
  }

  public Long getMeterDay() {
    return meterDay;
  }

  public void setMeterDay(Long meterDay) {
    this.meterDay = meterDay;
  }

  public EnergyModel getEnergy() {
    return energy;
  }

  public void setEnergy(EnergyModel energy) {
    this.energy = energy;
  }

}
