-- 사용자
create table tb_user (
  user_idx         int(11)         not null auto_increment  comment '사용자식별자',
  user_id          varchar(20)     not null                 comment '아이디',
  user_pw          varchar(100)                             comment '패스워드',
  user_type        varchar(1)                               comment '사용자구분(1:동서발전,2:고객사)',
  main_user_idx    int(11)                                  comment '주사용자식별자',
  main_user_yn     varchar(1)                               comment '주사용자여부(Y:예,N:아니오)',
  auth_type        varchar(1)                               comment '권한구분(1:포털관리자,2:고객사관리자,3:그룹관리자,4:사이트관리자,5:사이트이용자)',
  lang_type        varchar(20)                              comment '언어구분(1:한국어,2:영어,3:일본어)',
  comp_idx         int(11)                                  comment '회사식별자',
  co_name          varchar(50)                              comment '고객사명',
  co_tel           varchar(20)                              comment '회사전화번호',
  co_email         varchar(20)                              comment '회사이메일주소',
  psn_name         varchar(20)                              comment '담당자명',
  psn_dept         varchar(50)                              comment '담당자부서',
  psn_tel          varchar(20)                              comment '담당자전화번호',
  psn_mobile       varchar(20)                              comment '담당자휴대폰번호',
  psn_email        varchar(50)                              comment '담당자이메일주소',
  note             text                                     comment '비고',
  site_grp_idx     int(11)                                  comment '사이트그룹식별자',
  site_id          varchar(20)                              comment '사이트ID',
  del_yn           varchar(1)      default 'N'              comment '삭제여부(Y:예,N:아니오)',
  reg_uid          varchar(20)                              comment '등록자ID',
  reg_date         datetime                                 comment '등록일시',
  mod_uid          varchar(20)                              comment '최종수정자ID',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (user_idx),
  unique key (user_id)
) engine=InnoDB default charset=utf8 comment '사용자';


-- 회사
create table tb_company (
  comp_idx         int             not null auto_increment  comment '회사식별자',
  user_idx         int             not null                 comment '사용자식별자',
  comp_id          varchar(20)                              comment '회사ID',
  comp_name        varchar(50)                              comment '회사명',
  del_yn           varchar(1)      default 'N'              comment '삭제여부(Y:예,N:아니오)',
  reg_uid          varchar(20)                              comment '등록자ID',
  reg_date         datetime                                 comment '등록일시',
  mod_uid          varchar(20)                              comment '최종수정자ID',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (comp_idx),
  foreign key (user_idx) references tb_user(user_idx)
) engine=InnoDB default charset=utf8 comment '회사';


-- 사이트그룹
create table tb_site_group (
  site_grp_idx          int             not null auto_increment  comment '사이트그룹식별자',
  user_idx              int             not null                 comment '사용자식별자',
  site_grp_id           varchar(20)                              comment '사이트그룹ID',
  site_grp_name         varchar(50)                              comment '사이트그룹명',
  comp_idx              int(11)                                  comment '회사식별자',
  site_grp_img_path     varchar(255)                             comment '사이트그룹 이미지경로',
  site_grp_img_sname    varchar(100)                             comment '사이트그룹 저장이미지명',
  site_grp_img_rname    varchar(100)                             comment '사이트그룹 실제이미지명',
  del_yn                varchar(1)      default 'N'              comment '삭제여부(Y:예,N:아니오)',
  reg_uid               varchar(20)                              comment '등록자ID',
  reg_date              datetime                                 comment '등록일시',
  mod_uid               varchar(20)                              comment '최종수정자ID',
  mod_date              datetime                                 comment '최종수정일시',
  primary key (site_grp_idx)
) engine=InnoDB default charset=utf8 comment '사이트그룹';


-- 사이트
create table tb_site (
  site_id          varchar(20)     not null                 comment '사이트ID',
  user_idx         int             not null                 comment '사용자식별자',
  site_name        varchar(50)                              comment '사이트명',
  site_grp_idx     int                                      comment '사이트그룹식별자',
  area_type        varchar(2)                               comment '지역구분(01:서울,02:부산,03:대구,04:인천,05:광주,06:대전,07:울산,08:세종,09:경기,10:강원,11:충북,12:충남,13:전북,14:전남,15:경북,16:경남,17:제주)',
  time_zone        varchar(20)                              comment '타임Zone(예:GMT+8)',
  local_ems_addr   varchar(50)                              comment 'Local EMS 주소',
  local_ems_key    varchar(50)                              comment 'Local EMS 암호키',
  comp_idx         int(11)                                  comment '회사식별자',
  del_yn           varchar(1)      default 'N'              comment '삭제여부(Y:예,N:아니오)',
  reg_uid          varchar(20)                              comment '등록자ID',
  reg_date         datetime                                 comment '등록일시',
  mod_uid          varchar(20)                              comment '최종수정자ID',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (site_id),
  foreign key (user_idx) references tb_user(user_idx)
) engine=InnoDB default charset=utf8 comment '사이트';


-- 요금적용전력
create table tb_charge_power (
  chg_pwr_idx      int             not null auto_increment  comment '요금적용전력식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  std_date         varchar(8)      not null                 comment '기준일자(형식:YYYYMMDD)',
  charge_power     int             default 0                comment '요금적용전력(단위:kW)',
  reg_date         datetime                                 comment '등록일시',
  primary key (chg_pwr_idx),
  foreign key (site_id) references tb_site(site_id)
) engine=InnoDB default charset=utf8 comment '요금적용전력';


-- 사이트설정
create table tb_site_set (
  site_set_idx     int             not null auto_increment  comment '사이트설정식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  cust_num         varchar(20)                              comment '고객 번호',
  use_elec_addr    varchar(255)                             comment '전기사용 장소',
  meter_num        varchar(20)                              comment '계량기 번호',
  meter_sf         varchar(20)                              comment '계량기 배수',
  plan_type        varchar(50)                              comment '요금제구분(general_A1_low_voltage_A 외. bill_api.pdf 참조요망)',
  plan_type2       varchar(50)                              comment '요금제구분2(general_A1_low_voltage_A 외. bill_api.pdf 참조요망)',
  plan_type3       varchar(50)                              comment '요금제구분3(general_A1_low_voltage_A 외. bill_api.pdf 참조요망)',
  plan_name        varchar(50)                              comment '요금제(일반용 전력 (갑)I 저압전력 외. bill_api.pdf 참조요망)',
  contract_power   int                                      comment '계약전력(단위:kW)',
  meter_read_day   int                                      comment '검침일(단위:일)',
  charge_yearmd    varchar(8)                               comment '요금적용기준년월일(형식:YYYYMMDD)',
  charge_power     int             default 0                comment '요금적용전력(단위:kW)',
  charge_rate      int             default 0                comment '요금적용전력대비(단위:%)',
  goal_power       int             default 0                comment '목표전력(단위:kW)',
  reduce_amt       int             default 0                comment '감축용량(단위:kW)',
  smp_rate         float           default 0                comment 'SMP단가(System Marginal Price)(단위:원)',
  rec_rate         float           default 0                comment 'REC단가(단위:원)',
  rec_weight       float           default 0                comment 'REC가중치',
  profit_ratio     float           default 0                comment '수익배분 비율',
  del_yn           varchar(1)      default 'N'              comment '삭제여부(Y:예,N:아니오)',
  reg_uid          varchar(20)                              comment '등록자ID',
  reg_date         datetime                                 comment '등록일시',
  mod_uid          varchar(20)                              comment '최종수정자ID',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (site_set_idx),
  foreign key (site_id) references tb_site(site_id)
) engine=InnoDB default charset=utf8 comment '사이트설정';


-- 요금제
create table tb_plan_type(
  plan_type        varchar(50)                              comment '요금제구분(general_A1_low_voltage_A 외. bill_api.pdf 참조요망)',
  plan_type2       varchar(50)                              comment '요금제구분2(general_A1_low_voltage_A 외. bill_api.pdf 참조요망)',
  plan_type3       varchar(50)                              comment '요금제구분3(general_A1_low_voltage_A 외. bill_api.pdf 참조요망)',
  plan_name        varchar(50)                              comment '요금제(일반용 전력 (갑)I 저압전력 외. bill_api.pdf 참조요망)'

) engine=InnoDB default charset=utf8 comment '요금제';


-- SMS수신자
create table tb_sms_user (
  sms_user_idx     int             not null auto_increment  comment 'SMS수신자식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  name             varchar(20)                              comment '이름',
  mobile           varchar(20)                              comment '휴대폰번호',
  del_yn           varchar(1)      default 'N'              comment '삭제여부(Y:예,N:아니오)',
  reg_uid          varchar(20)                              comment '등록자ID',
  reg_date         datetime                                 comment '등록일시',
  mod_uid          varchar(20)                              comment '최종수정자ID',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (sms_user_idx)
) engine=InnoDB default charset=utf8 comment 'SMS수신자';


-- 장치그룹
create table tb_device_group (
  device_grp_idx   int             not null auto_increment  comment '장치그룹식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  user_idx         int             not null                 comment '사용자식별자',
  device_grp_name  varchar(50)                              comment '장치그룹명',
  del_yn           varchar(1)      default 'N'              comment '삭제여부(Y:예,N:아니오)',
  reg_uid          varchar(20)                              comment '등록자ID',
  reg_date         datetime                                 comment '등록일시',
  mod_uid          varchar(20)                              comment '최종수정자ID',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (device_grp_idx),
  foreign key (site_id) references tb_site(site_id)
) engine=InnoDB default charset=utf8 comment '장치그룹';


-- 장치
create table tb_device (
  device_id        varchar(20)     not null                 comment '장치ID',
  site_id          varchar(20)     not null                 comment '사이트ID',
  user_idx         int             not null                 comment '사용자식별자',
  device_name      varchar(50)                              comment '장치명',
  device_grp_idx   int                                      comment '장치그룹식별자',
  device_type      varchar(1)                               comment '장치구분(1:PCS,2:BMS,3:PV,4:부하측정기기,5:PV모니터링기기,6:ESS모니터링기기,7:iSmart,8:총량기기)',
  inst_type        varchar(1)                               comment '설치구분(1:에너톡,2:로컬EMS)',
  del_yn           varchar(1)      default 'N'              comment '삭제여부(Y:예,N:아니오)',
  reg_uid          varchar(20)                              comment '등록자ID',
  reg_date         datetime                                 comment '등록일시',
  mod_uid          varchar(20)                              comment '최종수정자ID',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (device_id, site_id, device_type),
  foreign key (site_id) references tb_site(site_id)
) engine=InnoDB default charset=utf8 comment '장치';


-- 자주하는질문
create table tb_faq (
  faq_idx          int             not null auto_increment  comment '자주하는질문식별자',
  question         varchar(100)                             comment '질문',
  answer           mediumtext                               comment '답변',
  del_yn           varchar(1)      default 'N'              comment '삭제여부(Y:예,N:아니오)',
  reg_uid          varchar(20)                              comment '등록자ID',
  reg_date         datetime                                 comment '등록일시',
  mod_uid          varchar(20)                              comment '최종수정자ID',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (faq_idx)
) engine=InnoDB default charset=utf8 comment '자주하는질문';


-- 자주하는 질문 카테고리
create table tb_faq (
  faq_cate_idx     int(11)         not null auto_increment  comment '카테고리식별자',
  faq_cate_step    int(11)                                  comment '카테고리순서',
  faq_cate_name    varchar(100)                             comment '카테고리명',
  reg_uid          varchar(20)                              comment '등록자ID',
  reg_date         datetime                                 comment '등록일시',
  mod_uid          varchar(20)                              comment '최종수정자ID',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (faq_cate_idx)
) engine=InnoDB default charset=utf8 comment '자주하는 질문 카테고리';


-- 사용량
create table tb_usage (
  usg_idx          bigint          not null auto_increment  comment '사용량식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  device_id        varchar(20)     not null                 comment '장치ID',
  std_timestamp    timestamp                                comment '기준타임스탬프',
  std_date         datetime                                 comment '기준일시',
  usg_val          int             default 0                comment '사용량(단위:mWh)',
  reg_date         datetime                                 comment '등록일시',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (usg_idx)
) engine=InnoDB default charset=utf8 comment '사용량';


-- 예측사용량
create table tb_predict_usage (
  pre_usg_idx      bigint          not null auto_increment  comment '예측사용량식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  device_id        varchar(20)     not null                 comment '장치ID',
  std_timestamp    timestamp                                comment '기준타임스탬프',
  std_date         datetime                                 comment '기준일시',
  pre_usg_val      int             default 0                comment '예측사용량(단위:mWh)',
  reg_date         datetime                                 comment '등록일시',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (pre_usg_idx)
) engine=InnoDB default charset=utf8 comment '예측사용량';


-- 무효전력
create table tb_reactive (
  rctv_idx         bigint          not null auto_increment  comment '무효전력식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  device_id        varchar(20)     not null                 comment '장치ID',
  std_timestamp    timestamp                                comment '기준타임스탬프',
  std_date         datetime                                 comment '기준일시',
  rctv_val         int             default 0                comment 'positive 방향 무효전력량(단위:mVarh)',
  neg_rctv_val     int             default 0                comment 'negative 방향 무효전력량(단위:mVarh)',
  reg_date         datetime                                 comment '등록일시',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (rctv_idx)
) engine=InnoDB default charset=utf8 comment '무효전력';


-- 피크
create table tb_peak (
  peak_idx         bigint          not null auto_increment  comment '피크식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  std_timestamp    timestamp                                comment '기준타임스탬프',
  std_date         datetime                                 comment '기준일시',
  peak_val         float           default 0                comment '최대수요(단위:kW)',
  peak_timestamp   timestamp                                comment '최대수요발생타임스탬프',
  peak_date        datetime                                 comment '최대수요발생일시',
  reg_date         datetime                                 comment '등록일시',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (peak_idx)
) engine=InnoDB default charset=utf8 comment '피크';


-- 예측피크
create table tb_predict_peak (
  pre_peak_idx     bigint          not null auto_increment  comment '예측피크식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  std_timestamp    timestamp                                comment '기준타임스탬프',
  std_date         datetime                                 comment '기준일시',
  peak_val         float           default 0                comment '최대수요(단위:kW)',
  peak_timestamp   timestamp                                comment '최대수요발생타임스탬프',
  peak_date        datetime                                 comment '최대수요발생일시',
  reg_date         datetime                                 comment '등록일시',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (pre_peak_idx)
) engine=InnoDB default charset=utf8 comment '예측피크';


-- ESS충방전량
create table tb_ess_charge (
  ess_chg_idx      bigint          not null auto_increment  comment 'ESS충방전량식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  device_id        varchar(20)     not null                 comment '장치ID',
  std_timestamp    timestamp                                comment '기준타임스탬프',
  std_date         datetime                                 comment '기준일시',
  chg_val          int             default 0                comment '충전량(단위:kWh)',
  dischg_val       int             default 0                comment '방전량(단위:kWh)',
  reg_date         datetime                                 comment '등록일시',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (ess_chg_idx)
) engine=InnoDB default charset=utf8 comment 'ESS충방전량';


-- ESS충방전량계획
create table tb_ess_charge_plan (
  ess_chg_plan_idx bigint          not null auto_increment  comment 'ESS충방전량계획식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  device_id        varchar(20)     not null                 comment '장치ID',
  std_timestamp    timestamp                                comment '기준타임스탬프',
  std_date         datetime                                 comment '기준일시',
  chg_val          int             default 0                comment '충전계획량(단위:kWh)',
  dischg_val       int             default 0                comment '방전계획량(단위:kWh)',
  reg_date         datetime                                 comment '등록일시',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (ess_chg_plan_idx)
) engine=InnoDB default charset=utf8 comment 'ESS충방전량계획';


-- ESS사용량
create table tb_ess_usage (
  ess_usg_idx      bigint          not null auto_increment  comment 'ESS사용량식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  device_id        varchar(20)     not null                 comment '장치ID',
  std_date         datetime                                 comment '기준일시',
  usg_val          int             default 0                comment '사용량(단위:kWh)',
  reg_date         datetime                                 comment '등록일시',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (ess_usg_idx)
) engine=InnoDB default charset=utf8 comment 'ESS사용량';


-- PV발전량
create table tb_pv_gen (
  pv_gen_idx       bigint          not null auto_increment  comment 'PV발전량식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  device_id        varchar(20)     not null                 comment '장치ID',
  std_date         datetime                                 comment '기준일시',
  gen_val          int             default 0                comment '발전량(단위:kWh)',
  temp             int                                      comment '온도(단위:℃)',
  reg_date         datetime                                 comment '등록일시',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (pv_gen_idx)
) engine=InnoDB default charset=utf8 comment 'PV발전량';


-- DR실적
create table tb_dr_result (
  dr_rst_idx       bigint          not null auto_increment  comment 'DR실적식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  start_timestamp  timestamp                                comment '감축시작타임스탬프',
  start_date       datetime                                 comment '감축시작일시',
  end_timestamp    timestamp                                comment '감축종료타임스탬프',
  end_date         datetime                                 comment '감축종료일시',
  cbl_amt          int             default 0                comment '기준부하(CBL)(단위:mWh)',
  act_amt          int             default 0                comment '실제사용량(단위:mWh)',
  contract_power   int                                      comment '계약전력(단위:kW)',
  goal_power       int             default 0                comment '목표전력(단위:kW)',
  reward_amt       int             default 0                comment '감축정산금',
  reg_date         datetime                                 comment '등록일시',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (dr_rst_idx)
) engine=InnoDB default charset=utf8 comment 'DR실적';


-- 알람
create table tb_alarm (
  alarm_idx        bigint          not null auto_increment  comment '알람식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  device_id        varchar(20)     not null                 comment '장치ID',
  device_type      varchar(1)                               comment '장치구분(1:PCS,2:BMS,3:PV,4:부하측정기기,5:PV모니터링기기,6:ESS모니터링기기,7:iSmart,8:총량기기)',
  std_date         datetime                                 comment '기준일시(알람발생일시)',
  alarm_type       varchar(1)                               comment '알람구분(1:비상,2:주의)',
  alarm_msg        text                                     comment '알람메시지',
  alarm_cfm_yn     varchar(1)                               comment '알람확인여부(Y:예,N:아니오)',
  alarm_cfm_date   datetime                                 comment '알람확인일시',
  alarm_cfm_uid    varchar(20)                              comment '알람확인자ID',
  alarm_act_yn     varchar(1)      default 'N'              comment '알람조치여부(Y:예,N:아니오)',
  alarm_note       text                                     comment '알람조치내역',
  reg_date         datetime                                 comment '등록일시',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (alarm_idx)
) engine=InnoDB default charset=utf8 comment '알람';


-- IOE장치
create table tb_device_ioe (
  device_ioe_idx   bigint          not null auto_increment  comment 'IOE장치식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  device_id        varchar(20)     not null                 comment '장치ID',
  device_name      varchar(50)                              comment '장치명',
  device_reg_id    varchar(50)                              comment '장치등록ID(UUID)',
  serial_no        varchar(20)                              comment '시리얼번호',
  inst_type        varchar(1)                               comment '설치구분(1:single-phase two-wires,2:single-phase three-wires,3:poly-phase three-wires,4:poly-phase four-wires,5:multi-channel,6:modem,7:plug,8:virtual device)',
  inst_purpose     varchar(1)                               comment '설치목적(1:site consumption,2:appliance consumption,3:site generation,4:standalone consumption)',
  data_period      int                                      comment '데이터업로드주기(단위:초)',
  data_cnt         int                                      comment '데이터업로드개수(단위:Hz)',
  ct_capacity      int                                      comment 'CT용량합계(단위:A)',
  ct_capacity_list varchar(255)                             comment 'CT용량리스트(여러개인 경우 콤마로 구분)',
  pw_capacity      int                                      comment '전력용량(단위:W)',
  ch_cnt           int                                      comment '채널수',
  ch_purpose       varchar(255)                             comment '채널목적(여러개인 경우 콤마로 구분)',
  provider         varchar(50)                              comment '장치공급자',
  vr_device_id     varchar(20)                              comment '가상장치ID',
  vr_device_grp_id varchar(20)                              comment '가상장치그룹ID',
  vr_owner_id      varchar(20)                              comment '가상장치소유자ID',
  vr_action        varchar(20)                              comment '가상장치액션',
  vr_stat          varchar(20)                              comment '가상장치상태',
  vr_mod_date      datetime                                 comment '가상장치업데이트일시',
  vr_error         varchar(255)                             comment '가상장치에러(JSON형태)',
  tm_voltage       int                                      comment 'TargetMeter 전압(단위:mV)',
  tm_pulse         int                                      comment 'TargetMeter 펄스(단위:pulse/kWh)',
  tm_ct_ratio      int                                      comment 'TargetMeter current transformation ratio',
  tm_pt_tatio      int                                      comment 'TargetMeter power transformation ratio',
  network_conf     varchar(255)                             comment '네트웍설정(JSON형태)',
  options          varchar(255)                             comment '사용자정의데이터',
  create_timestamp timestamp                                comment '생성타임스탬프',
  create_date      datetime                                 comment '생성일시',
  upload_timestamp timestamp                                comment '업로드타임스탬프',
  upload_date      datetime                                 comment '업로드일시',
  device_stat      varchar(1)                               comment '장치상태(1:connect,2:disconnect)',
  reg_date         datetime                                 comment '등록일시',
  primary key (device_ioe_idx)
) engine=InnoDB default charset=utf8 comment 'IOE장치';


-- PCS장치
create table tb_device_pcs (
  device_pcs_idx   bigint          not null auto_increment  comment 'PCS장치식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  device_id        varchar(20)     not null                 comment '장치ID',
  device_name      varchar(50)                              comment '장치명',
  device_stat      varchar(1)                               comment '운전상태(0:Schedule,1:Command)',
  alarm_msg        varchar(255)                             comment '알람메시지',
  ac_voltage       int                                      comment 'AC출력 - 전압(단위:V)',
  ac_power         int                                      comment 'AC출력 - 전력(단위:kWh)',
  ac_current       int                                      comment 'AC출력 - 전류(단위:A)',
  ac_freq          int                                      comment 'AC출력 - 주파수(단위:Hz)',
  ac_set_power     int                                      comment 'AC출력 - 전력설정치(단위:kWh)',
  ac_pf            int                                      comment 'AC출력 - 역률',
  dc_voltage       int                                      comment 'DC출력 - 전압(단위:V)',
  dc_power         int                                      comment 'DC출력 - 전력(단위:kWh)',
  dc_current       int                                      comment 'DC출력 - 전류(단위:A)',
  dc_freq          int                                      comment 'DC출력 - 주파수(단위:Hz)',
  dc_set_power     int                                      comment 'DC출력 - 전력설정치(단위:kWh)',
  dc_pf            int                                      comment 'DC출력 - 역률',
  std_date         datetime                                 comment '기준일시',
  reg_date         datetime                                 comment '등록일시',
  pcs_status       varchar(45),                             comment '0:OFF,1:ON,2:Fault,3:Warning',
  remote_mode       varchar(45),                            comment '0:Local,1:Remote',
  pcs_command       varchar(45),                            comment '0:Stop,1:Run',
  today_d_energy     varchar(45),
  today_c_energy     varchar(45),
  total_d_energy     varchar(45),
  total_c_energe     varchar(45),
  primary key (device_pcs_idx)
) engine=InnoDB default charset=utf8 comment 'PCS장치';


-- BMS장치
create table tb_device_bms (
  device_bms_idx   bigint          not null auto_increment  comment 'BMS장치식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  device_id        varchar(20)     not null                 comment '장치ID',
  device_name      varchar(50)                              comment '장치명',
  device_stat      varchar(1)                               comment '충방전상태(0:Idle,1:Charge,2:Discharge,3:MainS/W on/off,4:Off-line,5:Ready,6:Fault,7:Warning)',
  sys_soc          int                                      comment 'SOC(단위:%)',
  curr_soc         int                                      comment 'SOC현재(단위:kWh)',
  sys_soh          int                                      comment 'SOH(단위:%)',
  sys_voltage      int                                      comment '출력전압(단위:V)',
  sys_current      int                                      comment '출력전류(단위:A)',
  dod              int                                      comment 'DoD(단위:%)',
  std_date         datetime                                 comment '기준일시',
  reg_date         datetime                                 comment '등록일시',
  primary key (device_bms_idx)
) engine=InnoDB default charset=utf8 comment 'BMS장치';


-- PV장치
create table tb_device_pv (
  device_pv_idx    bigint          not null auto_increment  comment 'PV장치식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  device_id        varchar(20)     not null                 comment '장치ID',
  device_name      varchar(50)                              comment '장치명',
  device_stat      varchar(1)                               comment 'PV상태(0:Stop,1:Run,2:Fault,3:Warning)',
  alarm_msg        varchar(255)                             comment '알람메시지',
  temp             int                                      comment '온도(단위:℃)',
  tot_power        int                                      comment '금일누적발전량(단위:kWh)',
  std_date         datetime                                 comment '기준일시',
  reg_date         datetime                                 comment '등록일시',
  primary key (device_pv_idx)
) engine=InnoDB default charset=utf8 comment 'PV장치';


-- 요금
create table tb_bill (
  bill_idx         bigint          not null auto_increment  comment '요금식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  bill_yearm       varchar(6)                               comment '청구년월(형식:YYYYMM)',
  meter_read_day   int                                      comment '검침일(단위:일)',
  plan_type        varchar(50)                              comment '요금제구분',
  plan_name        varchar(50)                              comment '요금제',
  contract_power   int                                      comment '계약전력(단위:kW)',
  svc_sdate        varchar(8)                               comment '사용시작일(형식:YYYYMMDD)',
  svc_edate        varchar(8)                               comment '사용종료일(형식:YYYYMMDD)',
  base_rate        int                                      comment '기본요금',
  consume_rate     int                                      comment '전력량요금',
  off_peak_rate    int                                      comment '경부하요금',
  mid_peak_rate    int                                      comment '중부하요금',
  max_peak_rate    int                                      comment '최대부하요금',
  pwr_factor_rate  int                                      comment '역률요금',
  tot_elec_rate    int                                      comment '전기요금계',
  elec_fund        int                                      comment '전력기금',
  val_add_tax      int                                      comment '부가가치세',
  tot_amt_bill     int                                      comment '당월요금계',
  peak_pwr_demand  float                                    comment '요금적용전력(단위:kW)',
  usg              float                                    comment '전체전력사용량(단위:kWh)',
  off_peak_usg     float                                    comment '경부하전력사용량(단위:kWh)',
  mid_peak_usg     float                                    comment '중부하전력사용량(단위:kWh)',
  max_peak_usg     float                                    comment '최대부하전력사용량(단위:kWh)',
  lead_pwr_factor  int                                      comment '진상역률(단위:%)',
  lag_pwr_factor   int                                      comment '지상역률(단위:%)',
  ess_chg_incen    int                                      comment 'ESS충전요금할인',
  ess_dischg_incen     int                                  comment 'ESS방전요금할인',
  demand_chg_reduct    int                                  comment '기본요금절감금액',
  energy_chg_reduct    int                                  comment '전력량요금절감금액',
  ess_chg_off_peak     float                                comment '경부하시간대방전량(단위:kWh)',
  ess_chg_mid_peak     float                                comment '중부하시간대방전량(단위:kWh)',
  ess_chg_max_peak     float                                comment '최대부하시간대방전량(단위:kWh)',
  ess_dischg_off_peak  float                                comment '경부하시간대충전량(단위:kWh)',
  ess_dischg_mid_peak  float                                comment '중부하시간대충전량(단위:kWh)',
  ess_dischg_max_peak  float                                comment '최대부하시간대충전량(단위:kWh)',
  reg_date         datetime                                 comment '등록일시',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (bill_idx)
) engine=InnoDB default charset=utf8 comment '요금';


-- 발전수익
create table tb_gen_revenue (
  gen_revn_idx     bigint          not null auto_increment  comment '발전수익식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  gen_type         varchar(1)                               comment '발전구분(1:PV,2:ESS)',
  std_timestamp    timestamp                                comment '기준타임스탬프',
  std_date         datetime                                 comment '기준일시',
  meter_read_day   int                                      comment '검침일(단위:일)',
  smp_rate         float           default 0                comment 'SMP단가(System Marginal Price)(단위:원)',
  rec_rate         float           default 0                comment 'REC단가(단위:원)',
  rec_weight       float           default 0                comment 'REC가중치',
  produce_val      float           default 0                comment '생산량(단위:kWh)',
  consume_val      float           default 0                comment '소비량(단위:kWh)',
  net_gen_val      float           default 0                comment '순발전량(단위:kWh)',
  smp_price        float           default 0                comment 'SMP수익(단위:원)',
  rec_price        float           default 0                comment 'REC수익(단위:원)',
  tot_price        float           default 0                comment '총수익(단위:원)',
  reg_date         datetime                                 comment '등록일시',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (gen_revn_idx)
) engine=InnoDB default charset=utf8 comment '발전수익';


-- DR수익
create table tb_dr_revenue (
  dr_revn_idx      bigint          not null auto_increment  comment '발전수익식별자',
  site_id          varchar(20)     not null                 comment '사이트ID',
  std_yearm        varchar(6)                               comment '기준년월(형식:YYYYMM)',
  std_timestamp    timestamp                                comment '기준타임스탬프',
  std_date         datetime                                 comment '기준일시',
  reduct_cap       int                                      comment '감축용량(단위:kWh)',
  basic_price      int             default 0                comment '기본가격(단위:원/kWh)',
  max_reduct_ratio float           default 0                comment '감축상한비율',
  min_reduct_ratio float           default 0                comment '감축하한비율',
  profit_ratio     float           default 0                comment '수익비율',
  tot_pay          int             default 0                comment '총지급액',
  basic_pay        int             default 0                comment '기본지급액',
  reduct_stimestamp timestamp                               comment '감축시작타임스탬프',
  reduct_etimestamp timestamp                               comment '감축종료타임스탬프',
  reduct_sdate     datetime                                 comment '감축시작일시',
  reduct_edate     datetime                                 comment '감축종료일시',
  cbl_amt          int             default 0                comment '평균사용량(단위:kWh)',
  act_amt          int             default 0                comment '실제사용량(단위:kWh)',
  reduct_amt       int             default 0                comment '감축량(단위:kWh)',
  smp              int             default 0                comment 'SMP(단위:원)',
  reg_date         datetime                                 comment '등록일시',
  mod_date         datetime                                 comment '최종수정일시',
  primary key (dr_revn_idx)
) engine=InnoDB default charset=utf8 comment 'DR수익';


-- 기준부하
create table tb_cbl (
  cbl_idx           bigint          not null auto_increment  comment '발전수익식별자',
  site_id           varchar(20)     not null                 comment '사이트ID',
  start_timestamp   timestamp                                comment '시작타임스탬프',
  start_date        datetime                                 comment '시작일시',
  end_timestamp     timestamp                                comment '종료타임스탬프',
  end_date          datetime                                 comment '종료일시',
  cbl               int             default 0                comment '고객기준부하(단위:mWh)',
  cml               int             default 0                comment '고객최소부하(단위:mWh)',
  reg_date          datetime                                 comment '등록일시',
  mod_date          datetime                                 comment '최종수정일시',
  primary key (dr_revn_idx)
) engine=InnoDB default charset=utf8 comment '기준부하';