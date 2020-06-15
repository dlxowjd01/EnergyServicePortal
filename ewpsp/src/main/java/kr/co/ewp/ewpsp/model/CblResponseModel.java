package kr.co.ewp.ewpsp.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.Date;

@JsonIgnoreProperties(ignoreUnknown = true)
public class CblResponseModel {
    private Date start;// request start time
    private Date end;// request end time
    private String method;
    private Long cbl;
    private Long cml;

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

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public Long getCbl() {
        return cbl;
    }

    public void setCbl(Long cbl) {
        this.cbl = cbl;
    }

    public Long getCml() {
        return cml;
    }

    public void setCml(Long cml) {
        this.cml = cml;
    }

}
