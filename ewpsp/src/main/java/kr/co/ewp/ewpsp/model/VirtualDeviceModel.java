package kr.co.ewp.ewpsp.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class VirtualDeviceModel {
  private String virtualDeviceId;
  private String virtualDeviceGroupId;
  private String ownerId;
  private String action;
  private String status;
  private ErrorModel error;
  private Date updatedAt;

  public String getVirtualDeviceId() {
    return virtualDeviceId;
  }

  public void setVirtualDeviceId(String virtualDeviceId) {
    this.virtualDeviceId = virtualDeviceId;
  }

  public String getVirtualDeviceGroupId() {
    return virtualDeviceGroupId;
  }

  public void setVirtualDeviceGroupId(String virtualDeviceGroupId) {
    this.virtualDeviceGroupId = virtualDeviceGroupId;
  }

  public String getOwnerId() {
    return ownerId;
  }

  public void setOwnerId(String ownerId) {
    this.ownerId = ownerId;
  }

  public String getAction() {
    return action;
  }

  public void setAction(String action) {
    this.action = action;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public ErrorModel getError() {
    return error;
  }

  public void setError(ErrorModel error) {
    this.error = error;
  }

  public Date getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(Date updatedAt) {
    this.updatedAt = updatedAt;
  }

}
