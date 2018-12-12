package kr.co.ewp.api.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class ChargingDischargingScheduleItemModel { /*** 12.12 이우람 추가 ***/
  private Date timestamp;// timestamp start timestamp
  private Integer scheduledCEnergy;// number usage amount (Wh)
  private Integer scheduledDEnergy;// number usage amount (Wh)

  public Date getTimestamp() {
    return timestamp;
  }

  public void setTimestamp(Date timestamp) {
    this.timestamp = timestamp;
  }

  public Integer getScheduledCEnergy() {
  	return scheduledCEnergy;
  }
  
  public void setScheduledCEnergy(Integer scheduledCEnergy) {
  	this.scheduledCEnergy = scheduledCEnergy;
  }
  
  public Integer getScheduledDEnergy() {
  	return scheduledDEnergy;
  }
  
  public void setScheduledDEnergy(Integer scheduledDEnergy) {
  	this.scheduledDEnergy = scheduledDEnergy;
  }

  
}
