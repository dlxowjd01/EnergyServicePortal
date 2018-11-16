package kr.co.ewp.api.model;

import java.util.Date;
import java.util.List;

public class DrPaymentModel {
  private String month;// target month. format: YYYYMM
  private Long reductionCapacity;// obligation reduction capacity (kWh)
  private Long basicPrice;// basic price for basic payment (won/kWh)
  private Float maxReductionRatio;// upper limit ratio of reduction amount (0-1)
  private Float minReductionRatio;// lower limit ratio of reduction amount (0-1)
  private Float profitRatio;// customer profit ratio based on total amount (0-1)
  private Long totalPayment;// total payment
  private Long basicPayment;// basic payment
  private List<ReductionPaymentModel> reductionPayments;// list of reduction payment objects

  public Long getBasicPrice() {
    return basicPrice;
  }

  public void setBasicPrice(Long basicPrice) {
    this.basicPrice = basicPrice;
  }

  public Float getMaxReductionRatio() {
    return maxReductionRatio;
  }

  public void setMaxReductionRatio(Float maxReductionRatio) {
    this.maxReductionRatio = maxReductionRatio;
  }

  public Float getMinReductionRatio() {
    return minReductionRatio;
  }

  public void setMinReductionRatio(Float minReductionRatio) {
    this.minReductionRatio = minReductionRatio;
  }

  public Float getProfitRatio() {
    return profitRatio;
  }

  public void setProfitRatio(Float profitRatio) {
    this.profitRatio = profitRatio;
  }

  public Long getTotalPayment() {
    return totalPayment;
  }

  public void setTotalPayment(Long totalPayment) {
    this.totalPayment = totalPayment;
  }

  public Long getBasicPayment() {
    return basicPayment;
  }

  public void setBasicPayment(Long basicPayment) {
    this.basicPayment = basicPayment;
  }

  public List<ReductionPaymentModel> getReductionPayments() {
    return reductionPayments;
  }

  public void setReductionPayments(List<ReductionPaymentModel> reductionPayments) {
    this.reductionPayments = reductionPayments;
  }

  public String getMonth() {
    return month;
  }

  public void setMonth(String month) {
    this.month = month;
  }

  public Long getReductionCapacity() {
    return reductionCapacity;
  }

  public void setReductionCapacity(Long reductionCapacity) {
    this.reductionCapacity = reductionCapacity;
  }

  public static class ReductionPaymentModel {
    private Date start;// start time of dispatched event active period
    private Date end;// end time of dispatched event active peiod
    private Double cblAmount;// customer baseline amount i.e, average usage (kWh)
    private Double actualAmount;// actual amount used during event (kWh)
    private Double reductionAmount;// accepted reduction amount (kWh) - min(( cblAmount - actualAmount ), capacity *maxReductionRatio )
    private Long smp;// system marginal price (won)

    public Date getStart() {
      return start;
    }

    public void setStart(Date start) {
      this.start = start;
    }

    public Date getEnd() {
      return end;
    }

    public void setEnd(Date end) {
      this.end = end;
    }

    public Double getCblAmount() {
      return cblAmount;
    }

    public void setCblAmount(Double cblAmount) {
      this.cblAmount = cblAmount;
    }

    public Double getActualAmount() {
      return actualAmount;
    }

    public void setActualAmount(Double actualAmount) {
      this.actualAmount = actualAmount;
    }

    public Double getReductionAmount() {
      return reductionAmount;
    }

    public void setReductionAmount(Double reductionAmount) {
      this.reductionAmount = reductionAmount;
    }

    public Long getSmp() {
      return smp;
    }

    public void setSmp(Long smp) {
      this.smp = smp;
    }
  }
}
