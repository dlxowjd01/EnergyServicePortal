package kr.co.ewp.api.model;

import java.util.List;

import kr.co.ewp.api.util.EncoredApiUtil.Period;

public class GenResponseModel {
  private Long start;
  private Long end;
  private Period period;
  private GenResponseSub genPv;
  private GenResponseSub genEss;

  public Long getStart() {
    return start;
  }

  public void setStart(Long start) {
    this.start = start;
  }

  public Long getEnd() {
    return end;
  }

  public void setEnd(Long end) {
    this.end = end;
  }

  public Period getPeriod() {
    return period;
  }

  public void setPeriod(Period period) {
    this.period = period;
  }

  public GenResponseSub getGenPv() {
    return genPv;
  }

  public void setGenPv(GenResponseSub genPv) {
    this.genPv = genPv;
  }

  public GenResponseSub getGenEss() {
    return genEss;
  }

  public void setGenEss(GenResponseSub genEss) {
    this.genEss = genEss;
  }

  public static class GenResponseSub {
    private List<Long> basetime;
    private List<Double> produced;
    private List<Double> consumed;
    private List<Double> netGeneration;
    private List<Double> smpPrice;
    private List<Double> recPrice;
    private List<Double> revenues;

    public List<Long> getBasetime() {
      return basetime;
    }

    public void setBasetime(List<Long> basetime) {
      this.basetime = basetime;
    }

    public List<Double> getProduced() {
      return produced;
    }

    public void setProduced(List<Double> produced) {
      this.produced = produced;
    }

    public List<Double> getConsumed() {
      return consumed;
    }

    public void setConsumed(List<Double> consumed) {
      this.consumed = consumed;
    }

    public List<Double> getNetGeneration() {
      return netGeneration;
    }

    public void setNetGeneration(List<Double> netGeneration) {
      this.netGeneration = netGeneration;
    }

    public List<Double> getSmpPrice() {
      return smpPrice;
    }

    public void setSmpPrice(List<Double> smpPrice) {
      this.smpPrice = smpPrice;
    }

    public List<Double> getRecPrice() {
      return recPrice;
    }

    public void setRecPrice(List<Double> recPrice) {
      this.recPrice = recPrice;
    }

    public List<Double> getRevenues() {
      return revenues;
    }

    public void setRevenues(List<Double> revenues) {
      this.revenues = revenues;
    }
  }
}
