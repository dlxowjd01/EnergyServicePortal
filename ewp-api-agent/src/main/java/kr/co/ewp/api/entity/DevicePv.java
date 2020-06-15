package kr.co.ewp.api.entity;
import java.util.Date;
/**
 * PV장치  Class
 */
public class DevicePv {
	private Long devicePvIdx;//pv장치식별자
	private String siteId;//사이트id
	private String deviceId;//장치id
	private String deviceName;//장치명
	private String deviceStat;//pv상태
	private String alarmMsg;//알람메시지
	private Float acVoltage;// ac출력 - 전압(단위:v)
	private Float acPower;// ac출력 - 전력(단위:kWh -> W)
	private Float acCurrent;// ac출력 - 전류(단위:a)
	private Float acFreq;// ac출력 - 주파수(단위:hz)
	private Float dcVoltage;// dc출력 - 전압(단위:v)
	private Float dcPower;// dc출력 - 전력(단위:kWh -> W)
	private Float dcCurrent;// dc출력 - 전류(단위:a)
	private Float dcFreq;// dc출력 - 주파수(단위:hz)
	private Float temp;//온도(단위:℃)
	private Float totPower;//금일누적발전량(단위:kWh -> Wh)
	private Float todayGenPower;//Today generated energy (Wh)
	private Float totalGenPower;//Accumulated generated energy (Wh)
	private Date stdDate;//기준일시
	private Date regDate;//등록일시
	/**
	* pv장치식별자 조회
	* @return devicePvIdx
	*/
	public Long getDevicePvIdx() {
		return this.devicePvIdx;
	}
	/**
	* pv장치식별자 설정
	* @return devicePvIdx
	*/
	public void setDevicePvIdx(Long devicePvIdx) {
		this.devicePvIdx = devicePvIdx;
	}
	/**
	* 사이트id 조회
	* @return siteId
	*/
	public String getSiteId() {
		return this.siteId;
	}
	/**
	* 사이트id 설정
	* @return siteId
	*/
	public void setSiteId(String siteId) {
		this.siteId = siteId;
	}
	/**
	* 장치id 조회
	* @return deviceId
	*/
	public String getDeviceId() {
		return this.deviceId;
	}
	/**
	* 장치id 설정
	* @return deviceId
	*/
	public void setDeviceId(String deviceId) {
		this.deviceId = deviceId;
	}
	/**
	* 장치명 조회
	* @return deviceName
	*/
	public String getDeviceName() {
		return this.deviceName;
	}
	/**
	* 장치명 설정
	* @return deviceName
	*/
	public void setDeviceName(String deviceName) {
		this.deviceName = deviceName;
	}
	/**
	* pv상태 조회
	* @return deviceStat
	*/
	public String getDeviceStat() {
		return this.deviceStat;
	}
	/**
	* pv상태 설정
	* @return deviceStat
	*/
	public void setDeviceStat(String deviceStat) {
		this.deviceStat = deviceStat;
	}
	/**
	* 알람메시지 조회
	* @return alarmMsg
	*/
	public String getAlarmMsg() {
		return this.alarmMsg;
	}
	/**
	* 알람메시지 설정
	* @return alarmMsg
	*/
	public void setAlarmMsg(String alarmMsg) {
		this.alarmMsg = alarmMsg;
	}
	/**
	 * ac출력 - 전압(단위:v) 조회
	 *
	 * @return acVoltage
	 */
	public Float getAcVoltage() {
		return this.acVoltage;
	}
	/**
	 * ac출력 - 전압(단위:v) 설정
	 *
	 * @return acVoltage
	 */
	public void setAcVoltage(Float acVoltage) {
		this.acVoltage = acVoltage;
	}
	/**
	 * ac출력 - 전력(단위:kWh -> Wh) 조회
	 *
	 * @return acPower
	 */
	public Float getAcPower() {
		return this.acPower;
	}
	/**
	 * ac출력 - 전력(단위:kWh -> Wh) 설정
	 *
	 * @return acPower
	 */
	public void setAcPower(Float acPower) {
		this.acPower = acPower;
	}
	/**
	 * ac출력 - 전류(단위:a) 조회
	 *
	 * @return acCurrent
	 */
	public Float getAcCurrent() {
		return this.acCurrent;
	}
	/**
	 * ac출력 - 전류(단위:a) 설정
	 *
	 * @return acCurrent
	 */
	public void setAcCurrent(Float acCurrent) {
		this.acCurrent = acCurrent;
	}
	/**
	 * ac출력 - 주파수(단위:hz) 조회
	 *
	 * @return acFreq
	 */
	public Float getAcFreq() {
		return this.acFreq;
	}
	/**
	 * ac출력 - 주파수(단위:hz) 설정
	 *
	 * @return acFreq
	 */
	public void setAcFreq(Float acFreq) {
		this.acFreq = acFreq;
	}
	/**
	 * dc출력 - 전압(단위:v) 조회
	 *
	 * @return dcVoltage
	 */
	public Float getDcVoltage() {
		return this.dcVoltage;
	}
	/**
	 * dc출력 - 전압(단위:v) 설정
	 *
	 * @return dcVoltage
	 */
	public void setDcVoltage(Float dcVoltage) {
		this.dcVoltage = dcVoltage;
	}
	/**
	 * dc출력 - 전력(단위:kWh -> Wh) 조회
	 *
	 * @return dcPower
	 */
	public Float getDcPower() {
		return this.dcPower;
	}
	/**
	 * dc출력 - 전력(단위:kWh -> Wh) 설정
	 *
	 * @return dcPower
	 */
	public void setDcPower(Float dcPower) {
		this.dcPower = dcPower;
	}
	/**
	 * dc출력 - 전류(단위:a) 조회
	 *
	 * @return dcCurrent
	 */
	public Float getDcCurrent() {
		return this.dcCurrent;
	}
	/**
	 * dc출력 - 전류(단위:a) 설정
	 *
	 * @return dcCurrent
	 */
	public void setDcCurrent(Float dcCurrent) {
		this.dcCurrent = dcCurrent;
	}
	/**
	 * dc출력 - 주파수(단위:hz) 조회
	 *
	 * @return dcFreq
	 */
	public Float getDcFreq() {
		return this.dcFreq;
	}
	/**
	 * dc출력 - 주파수(단위:hz) 설정
	 *
	 * @return dcFreq
	 */
	public void setDcFreq(Float dcFreq) {
		this.dcFreq = dcFreq;
	}
	/**
	* 온도(단위:℃) 조회
	* @return temp
	*/
	public Float getTemp() {
		return this.temp;
	}
	/**
	* 온도(단위:℃) 설정
	* @return temp
	*/
	public void setTemp(Float temp) {
		this.temp = temp;
	}
	/**
	* 금일누적발전량(단위:kWh -> Wh) 조회
	* @return totPower
	*/
	public Float getTotPower() {
		return this.totPower;
	}
	/**
	* 금일누적발전량(단위:kWh -> Wh) 설정
	* @return totPower
	*/
	public void setTotPower(Float totPower) {
		this.totPower = totPower;
	}
	/**
	 * 금일누적발전량(단위:kWh -> Wh) 조회
	 * @return totPower
	 */
	public Float getTodayGenPower() {
		return this.todayGenPower;
	}
	/**
	 * 금일누적발전량(단위:kWh -> Wh) 설정
	 * @return totPower
	 */
	public void setTodayGenPower(Float todayGenPower) {
		this.todayGenPower = todayGenPower;
	}
	/**
	 * 금일누적발전량(단위:kWh -> Wh) 조회
	 * @return totPower
	 */
	public Float getTotalGenPower() {
		return this.totalGenPower;
	}
	/**
	 * 금일누적발전량(단위:kWh -> Wh) 설정
	 * @return totPower
	 */
	public void setTotalGenPower(Float totalGenPower) {
		this.totalGenPower = totalGenPower;
	}
	/**
	* 기준일시 조회
	* @return stdDate
	*/
	public Date getStdDate() {
		return this.stdDate;
	}
	/**
	* 기준일시 설정
	* @return stdDate
	*/
	public void setStdDate(Date stdDate) {
		this.stdDate = stdDate;
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

	@Override
	public String toString() {
		return "DevicePv [devicePvIdx=" + devicePvIdx + ", siteId=" + siteId + ", deviceId=" + deviceId + ", deviceName="
				+ deviceName + ", deviceStat=" + deviceStat + ", alarmMsg=" + alarmMsg + ", temp=" + temp + ", totPower="
				+ totPower + ", stdDate=" + stdDate + ", regDate=" + regDate + "]";
	}
	
}