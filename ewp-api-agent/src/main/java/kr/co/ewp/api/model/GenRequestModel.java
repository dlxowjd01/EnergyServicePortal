package kr.co.ewp.api.model;

import java.util.List;

import com.google.common.collect.Lists;

import kr.co.ewp.api.util.EncoredApiUtil.Period;

public class GenRequestModel {
  private Period period;//
  private Long meterDay;// 30, 검침일 (defaul 30)
  private Double smpRate;// won, 89.72, System Marginal Price
  private Double recRate;// won, 39.72, price of one REC
  private List<GenRequestSub> by;

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

  public Double getSmpRate() {
    return smpRate;
  }

  public void setSmpRate(Double smpRate) {
    this.smpRate = smpRate;
  }

  public List<GenRequestSub> getBy() {
    return by;
  }

  public void setBy(List<GenRequestSub> by) {
    this.by = by;
  }

  public Double getRecRate() {
    return recRate;
  }

  public void setRecRate(Double recRate) {
    this.recRate = recRate;
  }

  public static class GenRequestSub {
    private String label;// ‘gen_pv’, label of energy resource
    private Double recWeight;// 5.0, REC weight for generator
    private List<Energy> energy;
    private List<Long> timestamp;//
    private List<Double> produced;//
    private List<Double> consumed;

    public String getLabel() {
      return label;
    }

    public void setLabel(String label) {
      this.label = label;
    }

    public Double getRecWeight() {
      return recWeight;
    }

    public void setRecWeight(Double recWeight) {
      this.recWeight = recWeight;
    }

    public List<Energy> getEnergy() {
      return energy;
    }

    public void setEnergy(List<Energy> energy) {
      this.energy = energy;
    }

    public List<Long> getTimestamp() {
      return timestamp;
    }

    public void setTimestamp(List<Long> timestamp) {
      this.timestamp = timestamp;
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

    public void addTimestamp(Long timestamp) {
      if (this.timestamp == null) {
        this.timestamp = Lists.newArrayList();
      }
      this.timestamp.add(timestamp);
    }

    public void addProduced(Double produced) {
      if (this.produced == null) {
        this.produced = Lists.newArrayList();
      }
      this.produced.add(produced);
    }

    public void addConsumed(Double consumed) {
      if (this.consumed == null) {
        this.consumed = Lists.newArrayList();
      }
      this.consumed.add(consumed);
    }
  }

  public static class Energy {
    private Long timestamp;//
    private Double produced;//
    private Double consumed;

    public Long getTimestamp() {
      return timestamp;
    }

    public void setTimestamp(Long timestamp) {
      this.timestamp = timestamp;
    }

    public Double getProduced() {
      return produced;
    }

    public void setProduced(Double produced) {
      this.produced = produced;
    }

    public Double getConsumed() {
      return consumed;
    }

    public void setConsumed(Double consumed) {
      this.consumed = consumed;
    }
  }
}
