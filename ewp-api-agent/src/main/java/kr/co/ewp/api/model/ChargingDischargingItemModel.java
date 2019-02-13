package kr.co.ewp.api.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class ChargingDischargingItemModel { /*** 12.12 이우람 추가 ***/
  private Date timestamp;// timestamp start timestamp
  private Integer chargeEnergy;// total charged energy (Wh)
  private Integer dischargeEnergy;// total discharged energy (Wh)

  public Date getTimestamp() {
    return timestamp;
  }

  public void setTimestamp(Date timestamp) {
    this.timestamp = timestamp;
  }

  public Integer getChargeEnergy() {
  	return chargeEnergy;
  }
  
  public void setChargeEnergy(Integer chargeEnergy) {
  	this.chargeEnergy = chargeEnergy;
  }
  
  public Integer getDischargeEnergy() {
  	return dischargeEnergy;
  }
  
  public void setDischargeEnergy(Integer dischargeEnergy) {
  	this.dischargeEnergy = dischargeEnergy;
  }

}
