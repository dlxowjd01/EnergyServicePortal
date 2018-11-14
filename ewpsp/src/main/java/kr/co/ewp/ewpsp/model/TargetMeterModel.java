package kr.co.ewp.ewpsp.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class TargetMeterModel {
  private Integer voltage;
  private Integer pulse;
  private Integer ctRatio;
  private Integer ptRatio;

  public Integer getVoltage() {
    return voltage;
  }

  public void setVoltage(Integer voltage) {
    this.voltage = voltage;
  }

  public Integer getPulse() {
    return pulse;
  }

  public void setPulse(Integer pulse) {
    this.pulse = pulse;
  }

  public Integer getCtRatio() {
    return ctRatio;
  }

  public void setCtRatio(Integer ctRatio) {
    this.ctRatio = ctRatio;
  }

  public Integer getPtRatio() {
    return ptRatio;
  }

  public void setPtRatio(Integer ptRatio) {
    this.ptRatio = ptRatio;
  }

}
