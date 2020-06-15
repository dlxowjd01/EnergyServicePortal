package kr.co.esp.api.model;

import java.util.Date;

public class DrRequestTarget {
	private String siteId;//
	private Long cblAmount;// customer baseline amount i.e, average usage (mWh)
	private Long goalAmount;// goal amount during event period (mWh)
	private Long actualAmount;// actual amount used during event (mWh)
	private Long rewardAmount;// reward amount
	private Long expAmount;// experience amount
	private String rsvp;// user rsvp null:no response, yes:accepted,no:rejected
	private DrRequest request;// request information

	public String getSiteId() {
		return siteId;
	}

	public void setSiteId(String siteId) {
		this.siteId = siteId;
	}

	public Long getCblAmount() {
		return cblAmount;
	}

	public void setCblAmount(Long cblAmount) {
		this.cblAmount = cblAmount;
	}

	public Long getGoalAmount() {
		return goalAmount;
	}

	public void setGoalAmount(Long goalAmount) {
		this.goalAmount = goalAmount;
	}

	public Long getActualAmount() {
		return actualAmount;
	}

	public void setActualAmount(Long actualAmount) {
		this.actualAmount = actualAmount;
	}

	public Long getRewardAmount() {
		return rewardAmount;
	}

	public void setRewardAmount(Long rewardAmount) {
		this.rewardAmount = rewardAmount;
	}

	public Long getExpAmount() {
		return expAmount;
	}

	public void setExpAmount(Long expAmount) {
		this.expAmount = expAmount;
	}

	public String getRsvp() {
		return rsvp;
	}

	public void setRsvp(String rsvp) {
		this.rsvp = rsvp;
	}

	public DrRequest getRequest() {
		return request;
	}

	public void setRequest(DrRequest request) {
		this.request = request;
	}

	public static class DrRequest {
		private String id;// request id
		private String name;// request name
		private Date start;// request start time
		private Date end;// request end time
		private Long yesCount;// number of sites participating
		private Long successCount;// number of sites succeeded
		private String status;// ready , started , or ended
		private String type;// residential for real request, or practice for practice
		private String userAction;// user action type automated or behavioral

		public String getId() {
			return id;
		}

		public void setId(String id) {
			this.id = id;
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public Date getStart() {
			return start;
		}

		public void setStart(Date start) {
			this.start = start;
		}

		public Date getEnd() {
			return end;
		}

		public void setEnd(Date end) {
			this.end = end;
		}

		public Long getYesCount() {
			return yesCount;
		}

		public void setYesCount(Long yesCount) {
			this.yesCount = yesCount;
		}

		public Long getSuccessCount() {
			return successCount;
		}

		public void setSuccessCount(Long successCount) {
			this.successCount = successCount;
		}

		public String getStatus() {
			return status;
		}

		public void setStatus(String status) {
			this.status = status;
		}

		public String getType() {
			return type;
		}

		public void setType(String type) {
			this.type = type;
		}

		public String getUserAction() {
			return userAction;
		}

		public void setUserAction(String userAction) {
			this.userAction = userAction;
		}

	}
}
