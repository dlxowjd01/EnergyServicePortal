package kr.co.ewp.api.entity;
import java.util.Date;
/**
 * 사이트그룹  Class
 */
public class SiteGroup {
    private Integer siteGrpIdx;//사이트그룹식별자
    private Integer userIdx;//사용자식별자
    private String siteGrpName;//사이트그룹명
    private String delYn;//삭제여부(y:예,n:아니오)
    private String regUid;//등록자id
    private Date regDate;//등록일시
    private String modUid;//최종수정자id
    private Date modDate;//최종수정일시
   /**
    * 사이트그룹식별자 조회
    * @return siteGrpIdx
    */
    public Integer getSiteGrpIdx() {
        return this.siteGrpIdx;
    }
   /**
    * 사이트그룹식별자 설정
    * @return siteGrpIdx
    */
    public void setSiteGrpIdx(Integer siteGrpIdx) {
        this.siteGrpIdx = siteGrpIdx;
    }
   /**
    * 사용자식별자 조회
    * @return userIdx
    */
    public Integer getUserIdx() {
        return this.userIdx;
    }
   /**
    * 사용자식별자 설정
    * @return userIdx
    */
    public void setUserIdx(Integer userIdx) {
        this.userIdx = userIdx;
    }
   /**
    * 사이트그룹명 조회
    * @return siteGrpName
    */
    public String getSiteGrpName() {
        return this.siteGrpName;
    }
   /**
    * 사이트그룹명 설정
    * @return siteGrpName
    */
    public void setSiteGrpName(String siteGrpName) {
        this.siteGrpName = siteGrpName;
    }
   /**
    * 삭제여부(y:예,n:아니오) 조회
    * @return delYn
    */
    public String getDelYn() {
        return this.delYn;
    }
   /**
    * 삭제여부(y:예,n:아니오) 설정
    * @return delYn
    */
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }
   /**
    * 등록자id 조회
    * @return regUid
    */
    public String getRegUid() {
        return this.regUid;
    }
   /**
    * 등록자id 설정
    * @return regUid
    */
    public void setRegUid(String regUid) {
        this.regUid = regUid;
    }
   /**
    * 등록일시 조회
    * @return regDate
    */
    public Date getRegDate() {
        return this.regDate;
    }
   /**
    * 등록일시 설정
    * @return regDate
    */
    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }
   /**
    * 최종수정자id 조회
    * @return modUid
    */
    public String getModUid() {
        return this.modUid;
    }
   /**
    * 최종수정자id 설정
    * @return modUid
    */
    public void setModUid(String modUid) {
        this.modUid = modUid;
    }
   /**
    * 최종수정일시 조회
    * @return modDate
    */
    public Date getModDate() {
        return this.modDate;
    }
   /**
    * 최종수정일시 설정
    * @return modDate
    */
    public void setModDate(Date modDate) {
        this.modDate = modDate;
    }
}