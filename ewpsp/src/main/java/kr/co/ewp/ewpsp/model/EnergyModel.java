package kr.co.ewp.ewpsp.model;

import java.util.List;

public class EnergyModel {
    private List<Long> timestamp;
    private List<Float> kWh;

    public List<Long> getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(List<Long> timestamp) {
        this.timestamp = timestamp;
    }

    public List<Float> getkWh() {
        return kWh;
    }

    public void setkWh(List<Float> kWh) {
        this.kWh = kWh;
    }
}