package kr.co.ewp.api.model;

import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class AmiUsageModel {
  private String amiId;
  private Float activeEnergy; // sum of active power; (Wh)
  private Float reactiveEnergyLagging; // sum of all reactive power (lagging); (Varh)
  private Float reactiveEnergyLeading; // sum of all reactive power (leading); (Varh)
  private Date startDt; // timestamp in millisecond
  private Date endDt; // timestamp in millisecond
  private String intervalType;
  private Integer Interval;
  private Integer numItems; // number of AMI energy objects
  private List<AmiUsageItemModel> items; // list of AMI energy objects

  public String getAmiId() {
    return amiId;
  }

  public void setAmiId(String amiId) {
    this.amiId = amiId;
  }

  public Float getActiveEnergy() {
    return activeEnergy;
  }

  public void setActiveEnergy(Float activeEnergy) {
    this.activeEnergy = activeEnergy;
  }

  public Float getReactiveEnergyLagging() {
    return reactiveEnergyLagging;
  }

  public void setReactiveEnergyLagging(Float reactiveEnergyLagging) {
    this.reactiveEnergyLagging = reactiveEnergyLagging;
  }

  public Float getReactiveEnergyLeading() {
    return reactiveEnergyLeading;
  }

  public void setReactiveEnergyLeading(Float reactiveEnergyLeading) {
    this.reactiveEnergyLeading = reactiveEnergyLeading;
  }

  public Date getStartDt() {
    return startDt;
  }

  public void setStartDt(Date startDt) {
    this.startDt = startDt;
  }

  public Date getEndDt() {
    return endDt;
  }

  public void setEndDt(Date endDt) {
    this.endDt = endDt;
  }

  public String getIntervalType() {
    return intervalType;
  }

  public void setIntervalType(String intervalType) {
    this.intervalType = intervalType;
  }

  public Integer getInterval() {
    return Interval;
  }

  public void setInterval(Integer interval) {
    Interval = interval;
  }

  public Integer getNumItems() {
    return numItems;
  }

  public void setNumItems(Integer numItems) {
    this.numItems = numItems;
  }

  public List<AmiUsageItemModel> getItems() {
    return items;
  }

  public void setItems(List<AmiUsageItemModel> items) {
    this.items = items;
  }

  @Override
  public String toString() {
    return "AmiUsageModel{" +
            "amiId='" + amiId + '\'' +
            ", activeEnergy=" + activeEnergy +
            ", reactiveEnergyLagging=" + reactiveEnergyLagging +
            ", reactiveEnergyLeading=" + reactiveEnergyLeading +
            ", startDt=" + startDt +
            ", endDt=" + endDt +
            ", intervalType='" + intervalType + '\'' +
            ", Interval=" + Interval +
            ", numItems=" + numItems +
            ", items=" + items +
            '}';
  }
}
