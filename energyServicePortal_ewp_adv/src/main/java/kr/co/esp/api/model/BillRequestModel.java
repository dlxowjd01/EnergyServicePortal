package kr.co.esp.api.model;

import java.util.Date;
import java.util.List;

import kr.co.esp.common.util.EncoredApiUtil.Period;

public class BillRequestModel {
	private Period period;//
	private Long meterDay;// 30 검침일 (defaul 30)
	private String planName;// "industrial_B_high_voltage_A_option2" 요금제
	private Long contElec;// 970 계약전력
	private Date timestamp;// ‘ms’ 1483228800000 unix timestamp
	private Float kWh;// kWh 100 전력량
	private List<PeakHistoryModel> peakHistory;// 과거 1년 월별최대 수요
	private EnergyModel energy; // power List of timestamp and kWh 전력
	private ReactiveModel reactivePos;// List of timestamp and kVarh 무효 전력(positive 방향)
	private ReactiveModel reactiveNeg;// List of timestamp and kVarh 무효 전력(negative 방향)
	private EssModel essCharging;// List of timestamp and kWh output power of ess
	private EssModel essDischarging;// List of timestamp and kWh output power of ess

	public Period getPeriod() {
		return period;
	}

	public void setPeriod(Period period) {
		this.period = period;
	}

	public Long getMeterDay() {
		return meterDay;
	}

	public void setMeterDay(Long meterDay) {
		this.meterDay = meterDay;
	}

	public String getPlanName() {
		return planName;
	}

	public void setPlanName(String planName) {
		this.planName = planName;
	}

	public Long getContElec() {
		return contElec;
	}

	public void setContElec(Long contElec) {
		this.contElec = contElec;
	}

	public Date getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(Date timestamp) {
		this.timestamp = timestamp;
	}

	public Float getkWh() {
		return kWh;
	}

	public void setkWh(Float kWh) {
		this.kWh = kWh;
	}

	public List<PeakHistoryModel> getPeakHistory() {
		return peakHistory;
	}

	public void setPeakHistory(List<PeakHistoryModel> peakHistory) {
		this.peakHistory = peakHistory;
	}

	public EnergyModel getEnergy() {
		return energy;
	}

	public void setEnergy(EnergyModel energy) {
		this.energy = energy;
	}

	public ReactiveModel getReactivePos() {
		return reactivePos;
	}

	public void setReactivePos(ReactiveModel reactivePos) {
		this.reactivePos = reactivePos;
	}

	public ReactiveModel getReactiveNeg() {
		return reactiveNeg;
	}

	public void setReactiveNeg(ReactiveModel reactiveNeg) {
		this.reactiveNeg = reactiveNeg;
	}

	public EssModel getEssCharging() {
		return essCharging;
	}

	public void setEssCharging(EssModel essCharging) {
		this.essCharging = essCharging;
	}

	public EssModel getEssDischarging() {
		return essDischarging;
	}

	public void setEssDischarging(EssModel essDischarging) {
		this.essDischarging = essDischarging;
	}


}
