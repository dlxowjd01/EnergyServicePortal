package kr.co.ewp.api.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class AmiUsageItemModel {
  private Date timestamp; // ttimestamp in millisecond
  private Float activeEnergy; // sum of active power; (Wh)
  private Float reactiveEnergyLagging; // sum of all reactive power (lagging); (Varh)
  private Float reactiveEnergyLeading; // sum of all reactive power (leading); (Varh)

  public Date getTimestamp() {
    return timestamp;
  }

  public void setTimestamp(Date timestamp) {
    this.timestamp = timestamp;
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

  @Override
  public String toString() {
    return "AmiUsageItemModel{" +
            "timestamp=" + timestamp +
            ", activeEnergy=" + activeEnergy +
            ", reactiveEnergyLagging=" + reactiveEnergyLagging +
            ", reactiveEnergyLeading=" + reactiveEnergyLeading +
            '}';
  }
}
