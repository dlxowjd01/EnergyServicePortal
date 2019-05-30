package kr.co.ewp.ewpsp.model;

import java.util.Date;

public class UsageRealtimeModel {
    private Date timestamp;
    private Long timestampDiff;
    private Long voltage; // voltage amount (mV)
    private Long current; // electricity current (mA)
    private Long activePower; // active power amount (mW)
    private Long billingActivePower;
    private Long apparentPower;
    private Long reactivePower;
    private Long powerFactor;
    private Long positiveEnergy; // cumulative positive energy (mWh)
    private Long negativeEnergy; // cumulative negative energy (mWh)
    private Long positiveEnergyReactive; // cumulative positive reactive energy (mVarh)
    private Long negativeEnergyReactive; // cumulative negative reactive energy (mVarh)

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public Long getTimestampDiff() {
        return timestampDiff;
    }

    public void setTimestampDiff(Long timestampDiff) {
        this.timestampDiff = timestampDiff;
    }

    public Long getVoltage() {
        return voltage;
    }

    public void setVoltage(Long voltage) {
        this.voltage = voltage;
    }

    public Long getCurrent() {
        return current;
    }

    public void setCurrent(Long current) {
        this.current = current;
    }

    public Long getActivePower() {
        return activePower;
    }

    public void setActivePower(Long activePower) {
        this.activePower = activePower;
    }

    public Long getBillingActivePower() {
        return billingActivePower;
    }

    public void setBillingActivePower(Long billingActivePower) {
        this.billingActivePower = billingActivePower;
    }

    public Long getApparentPower() {
        return apparentPower;
    }

    public void setApparentPower(Long apparentPower) {
        this.apparentPower = apparentPower;
    }

    public Long getReactivePower() {
        return reactivePower;
    }

    public void setReactivePower(Long reactivePower) {
        this.reactivePower = reactivePower;
    }

    public Long getPowerFactor() {
        return powerFactor;
    }

    public void setPowerFactor(Long powerFactor) {
        this.powerFactor = powerFactor;
    }

    public Long getPositiveEnergy() {
        return positiveEnergy;
    }

    public void setPositiveEnergy(Long positiveEnergy) {
        this.positiveEnergy = positiveEnergy;
    }

    public Long getNegativeEnergy() {
        return negativeEnergy;
    }

    public void setNegativeEnergy(Long negativeEnergy) {
        this.negativeEnergy = negativeEnergy;
    }

    public Long getPositiveEnergyReactive() {
        return positiveEnergyReactive;
    }

    public void setPositiveEnergyReactive(Long positiveEnergyReactive) {
        this.positiveEnergyReactive = positiveEnergyReactive;
    }

    public Long getNegativeEnergyReactive() {
        return negativeEnergyReactive;
    }

    public void setNegativeEnergyReactive(Long negativeEnergyReactive) {
        this.negativeEnergyReactive = negativeEnergyReactive;
    }


}
