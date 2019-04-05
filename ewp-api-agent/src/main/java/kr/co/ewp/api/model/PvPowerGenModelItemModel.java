package kr.co.ewp.api.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class PvPowerGenModelItemModel { /*** 12.12 이우람 추가 ***/
  private Date timestamp;// timestamp in millisecond
  private Long genEnergy;// total generated energy (Wh)
  private Integer temperature;// temperature (℃)

  public Date getTimestamp() {
    return timestamp;
  }

  public void setTimestamp(Date timestamp) {
    this.timestamp = timestamp;
  }

  public Long getGenEnergy() {
  	return genEnergy;
  }
  
  public void setGenEnergy(Long genEnergy) {
  	this.genEnergy = genEnergy;
  }
  
  public Integer getTemperature() {
  	return temperature;
  }
  
  public void setTemperature(Integer temperature) {
  	this.temperature = temperature;
  }

@Override
public String toString() {
	return "PvPowerGenModelItemModel [timestamp=" + timestamp + ", genEnergy=" + genEnergy + ", temperature="
			+ temperature + "]";
}


}
