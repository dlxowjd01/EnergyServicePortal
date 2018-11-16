package kr.co.ewp.api.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class NetworkConfigModel {
  private String ipMode;
  private String subnet;
  private String gateway;
  private String ipAddress;
  private String dns;

  public String getIpMode() {
    return ipMode;
  }

  public void setIpMode(String ipMode) {
    this.ipMode = ipMode;
  }

  public String getSubnet() {
    return subnet;
  }

  public void setSubnet(String subnet) {
    this.subnet = subnet;
  }

  public String getGateway() {
    return gateway;
  }

  public void setGateway(String gateway) {
    this.gateway = gateway;
  }

  public String getIpAddress() {
    return ipAddress;
  }

  public void setIpAddress(String ipAddress) {
    this.ipAddress = ipAddress;
  }

  public String getDns() {
    return dns;
  }

  public void setDns(String dns) {
    this.dns = dns;
  }

}
