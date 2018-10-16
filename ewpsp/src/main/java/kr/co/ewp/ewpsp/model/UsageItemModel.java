package kr.co.ewp.ewpsp.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class UsageItemModel {
  private Date timestamp;// timestamp start timestamp
  private Long usage;// number usage amount (mWh)
  private BillChargeModel bill;// object breakdown of charges as billCharge object

  public Date getTimestamp() {
    return timestamp;
  }

  public void setTimestamp(Date timestamp) {
    this.timestamp = timestamp;
  }

  public Long getUsage() {
    return usage;
  }

  public void setUsage(Long usage) {
    this.usage = usage;
  }

  public BillChargeModel getBill() {
    return bill;
  }

  public void setBill(BillChargeModel bill) {
    this.bill = bill;
  }
}
