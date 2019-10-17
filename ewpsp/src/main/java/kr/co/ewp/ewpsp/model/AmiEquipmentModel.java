package kr.co.ewp.ewpsp.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class AmiEquipmentModel {
	private String amiId;
	private String amiName; // alias of AMI
	private Date timestamp; // timestamp in millisecond
	private Integer status; // 0: Stop, 1: Run, 2: Fault, 3: Warning
	private String alarmMsg; // Last alarm message
	private Float voltageR; // (V); 현재 R상의 전압
	private Float voltageS; // (V)
	private Float voltageT; // (V)
	private Float currentR; // (A); 현재 R상의 전류
	private Float currentS; // (A)
	private Float currentT; // (A)
	private Float frequency; // (Hz)
	private Float activePowerR; // 순시 유효전력량 R (W)
	private Float activePowerS; // 순시 유효전력량 S (W)
	private Float activePowerT; // 순시 유효전력량 T (W)
	private Float reactivePowerLaggingR; // 순시 무효전력량 지상 R (Var)
	private Float reactivePowerLaggingS; // 순시 무효전력량 지상 S (Var)
	private Float reactivePowerLaggingT; // 순시 무효전력량 지상 T (Var)
	private Float reactivePowerLeadingR; // 순시 무효전력량 진상 R (Var)
	private Float reactivePowerLeadingS; // 순시 무효전력량 진상 S (Var)
	private Float reactivePowerLeadingT; // 순시 무효전력량 진상 T (Var)
	private Float accumActivePowerR; // 총 누적 유효전력량 R상 (Wh)
	private Float accumActivePowerS; // (Wh)
	private Float accumActivePowerT; // (Wh)
	private Float accumReactivePowerLaggingR; // 총 누적 무효전력량 지상 R상 (Varh)
	private Float accumReactivePowerLaggingS; //  (Varh)
	private Float accumReactivePowerLaggingT; //  (Varh)
	private Float accumReactivePowerLeadingR; // 총 누적 무효전력량 진상 R상 (Varh)
	private Float accumReactivePowerLeadingS; // (Varh)
	private Float accumReactivePowerLeadingT; // (Varh)

	public String getAmiId() {
		return amiId;
	}

	public void setAmiId(String amiId) {
		this.amiId = amiId;
	}

	public String getAmiName() {
		return amiName;
	}

	public void setAmiName(String amiName) {
		this.amiName = amiName;
	}

	public Date getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(Date timestamp) {
		this.timestamp = timestamp;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public String getAlarmMsg() {
		return alarmMsg;
	}

	public void setAlarmMsg(String alarmMsg) {
		this.alarmMsg = alarmMsg;
	}

	public Float getVoltageR() {
		return voltageR;
	}

	public void setVoltageR(Float voltageR) {
		this.voltageR = voltageR;
	}

	public Float getVoltageS() {
		return voltageS;
	}

	public void setVoltageS(Float voltageS) {
		this.voltageS = voltageS;
	}

	public Float getVoltageT() {
		return voltageT;
	}

	public void setVoltageT(Float voltageT) {
		this.voltageT = voltageT;
	}

	public Float getCurrentR() {
		return currentR;
	}

	public void setCurrentR(Float currentR) {
		this.currentR = currentR;
	}

	public Float getCurrentS() {
		return currentS;
	}

	public void setCurrentS(Float currentS) {
		this.currentS = currentS;
	}

	public Float getCurrentT() {
		return currentT;
	}

	public void setCurrentT(Float currentT) {
		this.currentT = currentT;
	}

	public Float getFrequency() {
		return frequency;
	}

	public void setFrequency(Float frequency) {
		this.frequency = frequency;
	}

	public Float getActivePowerR() {
		return activePowerR;
	}

	public void setActivePowerR(Float activePowerR) {
		this.activePowerR = activePowerR;
	}

	public Float getActivePowerS() {
		return activePowerS;
	}

	public void setActivePowerS(Float activePowerS) {
		this.activePowerS = activePowerS;
	}

	public Float getActivePowerT() {
		return activePowerT;
	}

	public void setActivePowerT(Float activePowerT) {
		this.activePowerT = activePowerT;
	}

	public Float getReactivePowerLaggingR() {
		return reactivePowerLaggingR;
	}

	public void setReactivePowerLaggingR(Float reactivePowerLaggingR) {
		this.reactivePowerLaggingR = reactivePowerLaggingR;
	}

	public Float getReactivePowerLaggingS() {
		return reactivePowerLaggingS;
	}

	public void setReactivePowerLaggingS(Float reactivePowerLaggingS) {
		this.reactivePowerLaggingS = reactivePowerLaggingS;
	}

	public Float getReactivePowerLaggingT() {
		return reactivePowerLaggingT;
	}

	public void setReactivePowerLaggingT(Float reactivePowerLaggingT) {
		this.reactivePowerLaggingT = reactivePowerLaggingT;
	}

	public Float getReactivePowerLeadingR() {
		return reactivePowerLeadingR;
	}

	public void setReactivePowerLeadingR(Float reactivePowerLeadingR) {
		this.reactivePowerLeadingR = reactivePowerLeadingR;
	}

	public Float getReactivePowerLeadingS() {
		return reactivePowerLeadingS;
	}

	public void setReactivePowerLeadingS(Float reactivePowerLeadingS) {
		this.reactivePowerLeadingS = reactivePowerLeadingS;
	}

	public Float getReactivePowerLeadingT() {
		return reactivePowerLeadingT;
	}

	public void setReactivePowerLeadingT(Float reactivePowerLeadingT) {
		this.reactivePowerLeadingT = reactivePowerLeadingT;
	}

	public Float getAccumActivePowerR() {
		return accumActivePowerR;
	}

	public void setAccumActivePowerR(Float accumActivePowerR) {
		this.accumActivePowerR = accumActivePowerR;
	}

	public Float getAccumActivePowerS() {
		return accumActivePowerS;
	}

	public void setAccumActivePowerS(Float accumActivePowerS) {
		this.accumActivePowerS = accumActivePowerS;
	}

	public Float getAccumActivePowerT() {
		return accumActivePowerT;
	}

	public void setAccumActivePowerT(Float accumActivePowerT) {
		this.accumActivePowerT = accumActivePowerT;
	}

	public Float getAccumReactivePowerLaggingR() {
		return accumReactivePowerLaggingR;
	}

	public void setAccumReactivePowerLaggingR(Float accumReactivePowerLaggingR) {
		this.accumReactivePowerLaggingR = accumReactivePowerLaggingR;
	}

	public Float getAccumReactivePowerLaggingS() {
		return accumReactivePowerLaggingS;
	}

	public void setAccumReactivePowerLaggingS(Float accumReactivePowerLaggingS) {
		this.accumReactivePowerLaggingS = accumReactivePowerLaggingS;
	}

	public Float getAccumReactivePowerLaggingT() {
		return accumReactivePowerLaggingT;
	}

	public void setAccumReactivePowerLaggingT(Float accumReactivePowerLaggingT) {
		this.accumReactivePowerLaggingT = accumReactivePowerLaggingT;
	}

	public Float getAccumReactivePowerLeadingR() {
		return accumReactivePowerLeadingR;
	}

	public void setAccumReactivePowerLeadingR(Float accumReactivePowerLeadingR) {
		this.accumReactivePowerLeadingR = accumReactivePowerLeadingR;
	}

	public Float getAccumReactivePowerLeadingS() {
		return accumReactivePowerLeadingS;
	}

	public void setAccumReactivePowerLeadingS(Float accumReactivePowerLeadingS) {
		this.accumReactivePowerLeadingS = accumReactivePowerLeadingS;
	}

	public Float getAccumReactivePowerLeadingT() {
		return accumReactivePowerLeadingT;
	}

	public void setAccumReactivePowerLeadingT(Float accumReactivePowerLeadingT) {
		this.accumReactivePowerLeadingT = accumReactivePowerLeadingT;
	}

	@Override
	public String toString() {
		return "AmiEquipmentModel{" +
				"amiId='" + amiId + '\'' +
				", amiName='" + amiName + '\'' +
				", timestamp=" + timestamp +
				", status=" + status +
				", alarmMsg='" + alarmMsg + '\'' +
				", voltageR=" + voltageR +
				", voltageS=" + voltageS +
				", voltageT=" + voltageT +
				", currentR=" + currentR +
				", currentS=" + currentS +
				", currentT=" + currentT +
				", frequency=" + frequency +
				", accumActivePowerR=" + accumActivePowerR +
				", accumActivePowerS=" + accumActivePowerS +
				", accumActivePowerT=" + accumActivePowerT +
				", accumReactivePowerLaggingR=" + accumReactivePowerLaggingR +
				", accumReactivePowerLaggingS=" + accumReactivePowerLaggingS +
				", accumReactivePowerLaggingT=" + accumReactivePowerLaggingT +
				", accumReactivePowerLeadingR=" + accumReactivePowerLeadingR +
				", accumReactivePowerLeadingS=" + accumReactivePowerLeadingS +
				", accumReactivePowerLeadingT=" + accumReactivePowerLeadingT +
				'}';
	}
}
