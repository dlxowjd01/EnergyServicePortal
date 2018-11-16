package kr.co.ewp.api.entity;
import java.util.Date;
/**
 * 자주하는질문  Class
 */
public class Faq {
    private Integer faqIdx;//자주하는질문식별자
    private String question;//질문
    private String answer;//답변
    private String delYn;//삭제여부(y:예,n:아니오)
    private String regUid;//등록자id
    private Date regDate;//등록일시
    private String modUid;//최종수정자id
    private Date modDate;//최종수정일시
   /**
    * 자주하는질문식별자 조회
    * @return faqIdx
    */
    public Integer getFaqIdx() {
        return this.faqIdx;
    }
   /**
    * 자주하는질문식별자 설정
    * @return faqIdx
    */
    public void setFaqIdx(Integer faqIdx) {
        this.faqIdx = faqIdx;
    }
   /**
    * 질문 조회
    * @return question
    */
    public String getQuestion() {
        return this.question;
    }
   /**
    * 질문 설정
    * @return question
    */
    public void setQuestion(String question) {
        this.question = question;
    }
   /**
    * 답변 조회
    * @return answer
    */
    public String getAnswer() {
        return this.answer;
    }
   /**
    * 답변 설정
    * @return answer
    */
    public void setAnswer(String answer) {
        this.answer = answer;
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