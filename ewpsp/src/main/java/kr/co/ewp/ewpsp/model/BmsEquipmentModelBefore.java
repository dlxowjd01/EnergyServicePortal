package kr.co.ewp.ewpsp.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.Date;

@JsonIgnoreProperties(ignoreUnknown = true)
public class BmsEquipmentModelBefore {
    //	private Integer resultCnt;//
    private String bmsId;//
    private String bmsName;//
    private Date timestamp;// YYYYMMDDhhmmss
    private Integer sysMode;//
    //	private String socMax;//
//	private String socMin;//
    private Float sysSoc;// (%)
    private Float currSoc;// (kWh)
    private Float sysSoh;// (%)
    private Float sysVoltage;// (V)
    private Float sysCurrent;// (kWh)
    private String dod;// (%)

    public String getBmsId() {
        return bmsId;
    }

    public void setBmsId(String bmsId) {
        this.bmsId = bmsId;
    }

    public String getBmsName() {
        return bmsName;
    }

    public void setBmsName(String bmsName) {
        this.bmsName = bmsName;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public Integer getSysMode() {
        return sysMode;
    }

    public void setSysMode(Integer sysMode) {
        this.sysMode = sysMode;
    }

    public Float getSysSoc() {
        return sysSoc;
    }

    public void setSysSoc(Float sysSoc) {
        this.sysSoc = sysSoc;
    }

    public Float getCurrSoc() {
        return currSoc;
    }

    public void setCurrSoc(Float currSoc) {
        this.currSoc = currSoc;
    }

    public Float getSysSoh() {
        return sysSoh;
    }

    public void setSysSoh(Float sysSoh) {
        this.sysSoh = sysSoh;
    }

    public Float getSysVoltage() {
        return sysVoltage;
    }

    public void setSysVoltage(Float sysVoltage) {
        this.sysVoltage = sysVoltage;
    }

    public Float getSysCurrent() {
        return sysCurrent;
    }

    public void setSysCurrent(Float sysCurrent) {
        this.sysCurrent = sysCurrent;
    }

    public String getDod() {
        return dod;
    }

    public void setDod(String dod) {
        this.dod = dod;
    }

    @Override
    public String toString() {
        return "BmsEquipmentModelBefore [bmsId=" + bmsId + ", bmsName=" + bmsName + ", timestamp=" + timestamp
                + ", sysMode=" + sysMode + ", sysSoc=" + sysSoc + ", currSoc=" + currSoc + ", sysSoh=" + sysSoh
                + ", sysVoltage=" + sysVoltage + ", sysCurrent=" + sysCurrent + ", dod=" + dod + "]";
    }

}
