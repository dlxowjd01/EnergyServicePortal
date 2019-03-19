package kr.co.ewp.api.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class ChargingDischargingScheduleItemModel { /*** 12.12 이우람 추가 ***/
  private Date timestamp;// timestamp start timestamp
  private Float scheduledCEnergy;// target for charging (Wh)
  private Float scheduledDEnergy;// target for discharging (Wh)

  public Date getTimestamp() {
    return timestamp;
  }

  public void setTimestamp(Date timestamp) {
    this.timestamp = timestamp;
  }

  public Float getScheduledCEnergy() {
  	return scheduledCEnergy;
  }
  
  public void setScheduledCEnergy(Float scheduledCEnergy) {
  	this.scheduledCEnergy = scheduledCEnergy;
  }
  
  public Float getScheduledDEnergy() {
  	return scheduledDEnergy;
  }
  
  public void setScheduledDEnergy(Float scheduledDEnergy) {
  	this.scheduledDEnergy = scheduledDEnergy;
  }

  
}
