package kr.co.ewp.api.model;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class BillResponseModel {
  private Double baseRate;//
  private Double electricityConsumptionRate;//
  private Double powerFactorRate;//
  private Double totalElectricityRate;//
  private Double electricityFund;//
  private Double valueAddedTax;//
  private Double totalAmountBilled;//
  private Double midPeakRate;//
  private Double offPeakRate;//
  private Double onPeakRate;//
  private Double peakPowerDemand;//
  private Double energyUsage;//
  private Double leadingPowerFactor;//
  private Double laggingPowerFactor;//
  private Double midPeakEnergyUsage;//
  private Double offPeakEnergyUsage;//
  private Double onPeakEnergyUsage;//
  private Double essChargingIncentive;//
  private Double essDischargingIncentive;//
  private Double essChargingInOffPeak;//
  private Double essChargingInMidPeak;//
  private Double essChargingInOnPeak;//
  private Double essDischargingInOffPeak;//
  private Double essDischargingInMidPeak;//
  private Double essDischargingInOnPeak;//
  private Double demandChargeReduction;//
  private Double energyChargeReduction;//
  private List<BillItemModel> items;

  public Double getBaseRate() {
    return baseRate;
  }

  public void setBaseRate(Double baseRate) {
    this.baseRate = baseRate;
  }

  public Double getElectricityConsumptionRate() {
    return electricityConsumptionRate;
  }

  public void setElectricityConsumptionRate(Double electricityConsumptionRate) {
    this.electricityConsumptionRate = electricityConsumptionRate;
  }

  public Double getPowerFactorRate() {
    return powerFactorRate;
  }

  public void setPowerFactorRate(Double powerFactorRate) {
    this.powerFactorRate = powerFactorRate;
  }

  public Double getTotalElectricityRate() {
    return totalElectricityRate;
  }

  public void setTotalElectricityRate(Double totalElectricityRate) {
    this.totalElectricityRate = totalElectricityRate;
  }

  public Double getElectricityFund() {
    return electricityFund;
  }

  public void setElectricityFund(Double electricityFund) {
    this.electricityFund = electricityFund;
  }

  public Double getValueAddedTax() {
    return valueAddedTax;
  }

  public void setValueAddedTax(Double valueAddedTax) {
    this.valueAddedTax = valueAddedTax;
  }

  public Double getTotalAmountBilled() {
    return totalAmountBilled;
  }

  public void setTotalAmountBilled(Double totalAmountBilled) {
    this.totalAmountBilled = totalAmountBilled;
  }

  public Double getMidPeakRate() {
    return midPeakRate;
  }

  public void setMidPeakRate(Double midPeakRate) {
    this.midPeakRate = midPeakRate;
  }

  public Double getOffPeakRate() {
    return offPeakRate;
  }

  public void setOffPeakRate(Double offPeakRate) {
    this.offPeakRate = offPeakRate;
  }

  public Double getOnPeakRate() {
    return onPeakRate;
  }

  public void setOnPeakRate(Double onPeakRate) {
    this.onPeakRate = onPeakRate;
  }

  public Double getPeakPowerDemand() {
    return peakPowerDemand;
  }

  public void setPeakPowerDemand(Double peakPowerDemand) {
    this.peakPowerDemand = peakPowerDemand;
  }

  public Double getEnergyUsage() {
    return energyUsage;
  }

  public void setEnergyUsage(Double energyUsage) {
    this.energyUsage = energyUsage;
  }

  public Double getLeadingPowerFactor() {
    return leadingPowerFactor;
  }

  public void setLeadingPowerFactor(Double leadingPowerFactor) {
    this.leadingPowerFactor = leadingPowerFactor;
  }

  public Double getLaggingPowerFactor() {
    return laggingPowerFactor;
  }

  public void setLaggingPowerFactor(Double laggingPowerFactor) {
    this.laggingPowerFactor = laggingPowerFactor;
  }

  public Double getMidPeakEnergyUsage() {
    return midPeakEnergyUsage;
  }

  public void setMidPeakEnergyUsage(Double midPeakEnergyUsage) {
    this.midPeakEnergyUsage = midPeakEnergyUsage;
  }

  public Double getOffPeakEnergyUsage() {
    return offPeakEnergyUsage;
  }

  public void setOffPeakEnergyUsage(Double offPeakEnergyUsage) {
    this.offPeakEnergyUsage = offPeakEnergyUsage;
  }

  public Double getOnPeakEnergyUsage() {
    return onPeakEnergyUsage;
  }

  public void setOnPeakEnergyUsage(Double onPeakEnergyUsage) {
    this.onPeakEnergyUsage = onPeakEnergyUsage;
  }

  public Double getEssChargingIncentive() {
    return essChargingIncentive;
  }

  public void setEssChargingIncentive(Double essChargingIncentive) {
    this.essChargingIncentive = essChargingIncentive;
  }

  public Double getEssDischargingIncentive() {
    return essDischargingIncentive;
  }

  public void setEssDischargingIncentive(Double essDischargingIncentive) {
    this.essDischargingIncentive = essDischargingIncentive;
  }

  public Double getEssChargingInOffPeak() {
    return essChargingInOffPeak;
  }

  public void setEssChargingInOffPeak(Double essChargingingInOffPeak) {
    this.essChargingInOffPeak = essChargingingInOffPeak;
  }

  public Double getEssChargingInMidPeak() {
    return essChargingInMidPeak;
  }

  public void setEssChargingInMidPeak(Double essChargingingInMidPeak) {
    this.essChargingInMidPeak = essChargingingInMidPeak;
  }

  public Double getEssChargingInOnPeak() {
    return essChargingInOnPeak;
  }

  public void setEssChargingInOnPeak(Double essChargingingInOnPeak) {
    this.essChargingInOnPeak = essChargingingInOnPeak;
  }

  public Double getEssDischargingInOffPeak() {
    return essDischargingInOffPeak;
  }

  public void setEssDischargingInOffPeak(Double essDischargingInOffPeak) {
    this.essDischargingInOffPeak = essDischargingInOffPeak;
  }

  public Double getEssDischargingInMidPeak() {
    return essDischargingInMidPeak;
  }

  public void setEssDischargingInMidPeak(Double essDischargingInMidPeak) {
    this.essDischargingInMidPeak = essDischargingInMidPeak;
  }

  public Double getEssDischargingInOnPeak() {
    return essDischargingInOnPeak;
  }

  public void setEssDischargingInOnPeak(Double essDischargingInOnPeak) {
    this.essDischargingInOnPeak = essDischargingInOnPeak;
  }

  public Double getDemandChargeReduction() {
    return demandChargeReduction;
  }

  public void setDemandChargeReduction(Double demandChargeReduction) {
    this.demandChargeReduction = demandChargeReduction;
  }

  public Double getEnergyChargeReduction() {
    return energyChargeReduction;
  }

  public void setEnergyChargeReduction(Double energyChargeReduction) {
    this.energyChargeReduction = energyChargeReduction;
  }

  public List<BillItemModel> getItems() {
    return items;
  }

  public void setItems(List<BillItemModel> items) {
    this.items = items;
  }

}
