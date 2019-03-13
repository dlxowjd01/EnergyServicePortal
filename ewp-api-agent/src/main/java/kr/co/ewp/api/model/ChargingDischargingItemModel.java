package kr.co.ewp.api.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class ChargingDischargingItemModel { /*** 12.12 이우람 추가 ***/
  private Date timestamp;// timestamp start timestamp
  private Float chargeEnergy;// total charged energy (Wh)
  private Float dischargeEnergy;// total discharged energy (Wh)

  public Date getTimestamp() {
    return timestamp;
  }

  public void setTimestamp(Date timestamp) {
    this.timestamp = timestamp;
  }

  public Float getChargeEnergy() {
  	return chargeEnergy;
  }
  
  public void setChargeEnergy(Float chargeEnergy) {
  	this.chargeEnergy = chargeEnergy;
  }
  
  public Float getDischargeEnergy() {
  	return dischargeEnergy;
  }
  
  public void setDischargeEnergy(Float dischargeEnergy) {
  	this.dischargeEnergy = dischargeEnergy;
  }

}
