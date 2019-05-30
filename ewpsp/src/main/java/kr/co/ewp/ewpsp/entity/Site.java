package kr.co.ewp.ewpsp.entity;

import java.util.Date;

/**
 * 사이트  Class
 */
public class Site {
    private String siteId;//사이트id
    private Integer userIdx;//사용자식별자
    private String siteName;//사이트명
    private Integer siteGrpIdx;//사이트그룹식별자
    private String areaType;//지역구분(01:서울,02:부산,03:대구,04:인천,05:광주,06:대전,07:울산,08:세종,09:경기,10:강원,11:충북,12:충남,13:전북,14:전남,15:경북,16:경남,17:제주)
    private String timeZone;//타임zone(예:gmt+8)
    private String localEmsAddr;//local ems 주소
    private String localEmsKey;//local ems 암호키
    private String delYn;//삭제여부(y:예,n:아니오)
    private String regUid;//등록자id
    private Date regDate;//등록일시
    private String modUid;//최종수정자id
    private Date modDate;//최종수정일시

    /**
     * 사이트id 조회
     *
     * @return siteId
     */
    public String getSiteId() {
        return this.siteId;
    }

    /**
     * 사이트id 설정
     *
     * @return siteId
     */
    public void setSiteId(String siteId) {
        this.siteId = siteId;
    }

    /**
     * 사용자식별자 조회
     *
     * @return userIdx
     */
    public Integer getUserIdx() {
        return this.userIdx;
    }

    /**
     * 사용자식별자 설정
     *
     * @return userIdx
     */
    public void setUserIdx(Integer userIdx) {
        this.userIdx = userIdx;
    }

    /**
     * 사이트명 조회
     *
     * @return siteName
     */
    public String getSiteName() {
        return this.siteName;
    }

    /**
     * 사이트명 설정
     *
     * @return siteName
     */
    public void setSiteName(String siteName) {
        this.siteName = siteName;
    }

    /**
     * 사이트그룹식별자 조회
     *
     * @return siteGrpIdx
     */
    public Integer getSiteGrpIdx() {
        return this.siteGrpIdx;
    }

    /**
     * 사이트그룹식별자 설정
     *
     * @return siteGrpIdx
     */
    public void setSiteGrpIdx(Integer siteGrpIdx) {
        this.siteGrpIdx = siteGrpIdx;
    }

    /**
     * 지역구분(01:서울,02:부산,03:대구,04:인천,05:광주,06:대전,07:울산,08:세종,09:경기,10:강원,11:충북,12:충남,13:전북,14:전남,15:경북,16:경남,17:제주) 조회
     *
     * @return areaType
     */
    public String getAreaType() {
        return this.areaType;
    }

    /**
     * 지역구분(01:서울,02:부산,03:대구,04:인천,05:광주,06:대전,07:울산,08:세종,09:경기,10:강원,11:충북,12:충남,13:전북,14:전남,15:경북,16:경남,17:제주) 설정
     *
     * @return areaType
     */
    public void setAreaType(String areaType) {
        this.areaType = areaType;
    }

    /**
     * 타임zone(예:gmt+8) 조회
     *
     * @return timeZone
     */
    public String getTimeZone() {
        return this.timeZone;
    }

    /**
     * 타임zone(예:gmt+8) 설정
     *
     * @return timeZone
     */
    public void setTimeZone(String timeZone) {
        this.timeZone = timeZone;
    }

    /**
     * local ems 주소 조회
     *
     * @return localEmsAddr
     */
    public String getLocalEmsAddr() {
        return this.localEmsAddr;
    }

    /**
     * local ems 주소 설정
     *
     * @return localEmsAddr
     */
    public void setLocalEmsAddr(String localEmsAddr) {
        this.localEmsAddr = localEmsAddr;
    }

    /**
     * local ems 암호키 조회
     *
     * @return localEmsKey
     */
    public String getLocalEmsKey() {
        return this.localEmsKey;
    }

    /**
     * local ems 암호키 설정
     *
     * @return localEmsKey
     */
    public void setLocalEmsKey(String localEmsKey) {
        this.localEmsKey = localEmsKey;
    }

    /**
     * 삭제여부(y:예,n:아니오) 조회
     *
     * @return delYn
     */
    public String getDelYn() {
        return this.delYn;
    }

    /**
     * 삭제여부(y:예,n:아니오) 설정
     *
     * @return delYn
     */
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    /**
     * 등록자id 조회
     *
     * @return regUid
     */
    public String getRegUid() {
        return this.regUid;
    }

    /**
     * 등록자id 설정
     *
     * @return regUid
     */
    public void setRegUid(String regUid) {
        this.regUid = regUid;
    }

    /**
     * 등록일시 조회
     *
     * @return regDate
     */
    public Date getRegDate() {
        return this.regDate;
    }

    /**
     * 등록일시 설정
     *
     * @return regDate
     */
    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }

    /**
     * 최종수정자id 조회
     *
     * @return modUid
     */
    public String getModUid() {
        return this.modUid;
    }

    /**
     * 최종수정자id 설정
     *
     * @return modUid
     */
    public void setModUid(String modUid) {
        this.modUid = modUid;
    }

    /**
     * 최종수정일시 조회
     *
     * @return modDate
     */
    public Date getModDate() {
        return this.modDate;
    }

    /**
     * 최종수정일시 설정
     *
     * @return modDate
     */
    public void setModDate(Date modDate) {
        this.modDate = modDate;
    }
}