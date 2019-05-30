package kr.co.ewp.ewpsp.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.Date;
import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class UsageModel {
    private Date start;// timestamp start timestamp (inclusive)
    private Date end;// timestamp end timestamp (exclusive)
    private String period;// string time interval for each usage item. Possible values are 15min, 30min, hour, day, and month.
    private Long usage;// number total usage amount (mWh) between start and end time
    private BillChargeModel bill;// object breakdown of charges as billCharge object
    private List<UsageItemModel> items;// list list of usageItem objects

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

    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
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

    public List<UsageItemModel> getItems() {
        return items;
    }

    public void setItems(List<UsageItemModel> items) {
        this.items = items;
    }
}
