package kr.co.ewp.api.entity;
import java.util.Date;
/**
 * 사용자  Class
 */
public class User {
    private Integer userIdx;//사용자식별자
    private String userId;//아이디
    private String userPw;//패스워드
    private String userType;//사용자구분(1:동서발전,2:고객사)
    private Integer mainUserIdx;//주사용자식별자
    private String mainUserYn;//주사용자여부(y:예,n:아니오)
    private String authType;//권한구분(1:포털관리자,2:그룹관리자,3:사이트관리자,4:사이트이용자)
    private String langType;//언어구분(1:한국어,2:영어,3:일본어)
    private String coName;//고객사명
    private String coTel;//회사전화번호
    private String coEmail;//회사이메일주소
    private String psnName;//담당자명
    private String psnDept;//담당자부서
    private String psnTel;//담당자전화번호
    private String psnMobile;//담당자휴대폰번호
    private String psnEmail;//담당자이메일주소
    private String note;//비고
    private String delYn;//삭제여부(y:예,n:아니오)
    private String regUid;//등록자id
    private Date regDate;//등록일시
    private String modUid;//최종수정자id
    private Date modDate;//최종수정일시
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
    * 아이디 조회
    * @return userId
    */
    public String getUserId() {
        return this.userId;
    }
   /**
    * 아이디 설정
    * @return userId
    */
    public void setUserId(String userId) {
        this.userId = userId;
    }
   /**
    * 패스워드 조회
    * @return userPw
    */
    public String getUserPw() {
        return this.userPw;
    }
   /**
    * 패스워드 설정
    * @return userPw
    */
    public void setUserPw(String userPw) {
        this.userPw = userPw;
    }
   /**
    * 사용자구분(1:동서발전,2:고객사) 조회
    * @return userType
    */
    public String getUserType() {
        return this.userType;
    }
   /**
    * 사용자구분(1:동서발전,2:고객사) 설정
    * @return userType
    */
    public void setUserType(String userType) {
        this.userType = userType;
    }
   /**
    * 주사용자식별자 조회
    * @return mainUserIdx
    */
    public Integer getMainUserIdx() {
        return this.mainUserIdx;
    }
   /**
    * 주사용자식별자 설정
    * @return mainUserIdx
    */
    public void setMainUserIdx(Integer mainUserIdx) {
        this.mainUserIdx = mainUserIdx;
    }
   /**
    * 주사용자여부(y:예,n:아니오) 조회
    * @return mainUserYn
    */
    public String getMainUserYn() {
        return this.mainUserYn;
    }
   /**
    * 주사용자여부(y:예,n:아니오) 설정
    * @return mainUserYn
    */
    public void setMainUserYn(String mainUserYn) {
        this.mainUserYn = mainUserYn;
    }
   /**
    * 권한구분(1:포털관리자,2:그룹관리자,3:사이트관리자,4:사이트이용자) 조회
    * @return authType
    */
    public String getAuthType() {
        return this.authType;
    }
   /**
    * 권한구분(1:포털관리자,2:그룹관리자,3:사이트관리자,4:사이트이용자) 설정
    * @return authType
    */
    public void setAuthType(String authType) {
        this.authType = authType;
    }
   /**
    * 언어구분(1:한국어,2:영어,3:일본어) 조회
    * @return langType
    */
    public String getLangType() {
        return this.langType;
    }
   /**
    * 언어구분(1:한국어,2:영어,3:일본어) 설정
    * @return langType
    */
    public void setLangType(String langType) {
        this.langType = langType;
    }
   /**
    * 고객사명 조회
    * @return coName
    */
    public String getCoName() {
        return this.coName;
    }
   /**
    * 고객사명 설정
    * @return coName
    */
    public void setCoName(String coName) {
        this.coName = coName;
    }
   /**
    * 회사전화번호 조회
    * @return coTel
    */
    public String getCoTel() {
        return this.coTel;
    }
   /**
    * 회사전화번호 설정
    * @return coTel
    */
    public void setCoTel(String coTel) {
        this.coTel = coTel;
    }
   /**
    * 회사이메일주소 조회
    * @return coEmail
    */
    public String getCoEmail() {
        return this.coEmail;
    }
   /**
    * 회사이메일주소 설정
    * @return coEmail
    */
    public void setCoEmail(String coEmail) {
        this.coEmail = coEmail;
    }
   /**
    * 담당자명 조회
    * @return psnName
    */
    public String getPsnName() {
        return this.psnName;
    }
   /**
    * 담당자명 설정
    * @return psnName
    */
    public void setPsnName(String psnName) {
        this.psnName = psnName;
    }
   /**
    * 담당자부서 조회
    * @return psnDept
    */
    public String getPsnDept() {
        return this.psnDept;
    }
   /**
    * 담당자부서 설정
    * @return psnDept
    */
    public void setPsnDept(String psnDept) {
        this.psnDept = psnDept;
    }
   /**
    * 담당자전화번호 조회
    * @return psnTel
    */
    public String getPsnTel() {
        return this.psnTel;
    }
   /**
    * 담당자전화번호 설정
    * @return psnTel
    */
    public void setPsnTel(String psnTel) {
        this.psnTel = psnTel;
    }
   /**
    * 담당자휴대폰번호 조회
    * @return psnMobile
    */
    public String getPsnMobile() {
        return this.psnMobile;
    }
   /**
    * 담당자휴대폰번호 설정
    * @return psnMobile
    */
    public void setPsnMobile(String psnMobile) {
        this.psnMobile = psnMobile;
    }
   /**
    * 담당자이메일주소 조회
    * @return psnEmail
    */
    public String getPsnEmail() {
        return this.psnEmail;
    }
   /**
    * 담당자이메일주소 설정
    * @return psnEmail
    */
    public void setPsnEmail(String psnEmail) {
        this.psnEmail = psnEmail;
    }
   /**
    * 비고 조회
    * @return note
    */
    public String getNote() {
        return this.note;
    }
   /**
    * 비고 설정
    * @return note
    */
    public void setNote(String note) {
        this.note = note;
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