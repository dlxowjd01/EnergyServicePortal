package kr.co.ewp.api.model;

import java.util.List;

public class PeakResponseModel {
  private List<Long> basetime;
  private List<Float> kW;
  private List<Long> occured;

  public List<Long> getBasetime() {
    return basetime;
  }

  public void setBasetime(List<Long> basetime) {
    this.basetime = basetime;
  }

  public List<Float> getkW() {
    return kW;
  }

  public void setkW(List<Float> kW) {
    this.kW = kW;
  }

  public List<Long> getOccured() {
    return occured;
  }

  public void setOccured(List<Long> occured) {
    this.occured = occured;
  }
}
