package kr.co.ewp.api.model;

public class PeakHistoryModel {
  private String month;
  private Float peak;

  public PeakHistoryModel(String month, Float peak) {
    this.month = month;
    this.peak = peak;
  }

  public String getMonth() {
    return month;
  }

  public void setMonth(String month) {
    this.month = month;
  }

  public Float getPeak() {
    return peak;
  }

  public void setPeak(Float peak) {
    this.peak = peak;
  }
}
