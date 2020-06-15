package kr.co.esp.api.model;

import java.util.List;

public class ReactiveModel {
	private List<Long> timestamp;
	private List<Float> kVarh;

	public List<Long> getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(List<Long> timestamp) {
		this.timestamp = timestamp;
	}

	public List<Float> getkVarh() {
		return kVarh;
	}

	public void setkVarh(List<Float> kVarh) {
		this.kVarh = kVarh;
	}

}