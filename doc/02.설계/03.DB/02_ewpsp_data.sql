-- 테스트 데이터

insert into tb_user (user_id, user_pw, user_type, main_user_idx, main_user_yn, auth_type, lang_type, co_name, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('test01','1234','2','1','Y','4','1','구례','N','admin',now(),'admin',now());

insert into tb_user (user_id, user_pw, user_type, main_user_idx, main_user_yn, auth_type, lang_type, co_name, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('test02','1234','2','1','Y','4','1','괴산자연드림','N','admin',now(),'admin',now());



insert into tb_site (site_id, user_idx, site_name, area_type, time_zone, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('17094385','1','구례1_전기실','14','GMT+8','N','admin',now(),'admin',now());

insert into tb_site (site_id, user_idx, site_name, area_type, time_zone, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('22e83dfc','1','구례2_올곧은','14','GMT+8','N','admin',now(),'admin',now());

insert into tb_site (site_id, user_idx, site_name, area_type, time_zone, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('c64b328b','1','구례3_전분제분양곡','14','GMT+8','N','admin',now(),'admin',now());

insert into tb_site (site_id, user_idx, site_name, area_type, time_zone, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('7532a5c','1','구례4_기계실앞','14','GMT+8','N','admin',now(),'admin',now());

insert into tb_site (site_id, user_idx, site_name, area_type, time_zone, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('af19e136','1','구례5_맘씨','14','GMT+8','N','admin',now(),'admin',now());

insert into tb_site (site_id, user_idx, site_name, area_type, time_zone, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('f23ac0b6','1','구례6_유정란','14','GMT+8','N','admin',now(),'admin',now());

insert into tb_site (site_id, user_idx, site_name, area_type, time_zone, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('67b72dfb','1','구례7_밀크쿱','14','GMT+8','N','admin',now(),'admin',now());

insert into tb_site (site_id, user_idx, site_name, area_type, time_zone, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('1feef4db','2','괴산자연드림_냉동창고','11','GMT+8','N','admin',now(),'admin',now());

insert into tb_site (site_id, user_idx, site_name, area_type, time_zone, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('2f292a5a','2','괴산자연드림_해피푸르츠','11','GMT+8','N','admin',now(),'admin',now());

insert into tb_site (site_id, user_idx, site_name, area_type, time_zone, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('bb3090b9','2','괴산자연드림_순수유','11','GMT+8','N','admin',now(),'admin',now());

insert into tb_site (site_id, user_idx, site_name, area_type, time_zone, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('68c1699c','2','괴산자연드림_쿱양콕','11','GMT+8','N','admin',now(),'admin',now());



INSERT INTO tb_device (device_id, site_id, user_idx, device_name, reg_uid, reg_date, mod_uid, mod_date )
VALUES ( 'a8324a51', '17094385', '1', '전기실 테스트', 'admin', NOW(), 'admin', NOW());
INSERT INTO tb_device (device_id, site_id, user_idx, device_name, reg_uid, reg_date, mod_uid, mod_date )
VALUES ( 'd83be8c1', '22e83dfc', '1', '계량2_올곧은', 'admin', NOW(), 'admin', NOW());
INSERT INTO tb_device (device_id, site_id, user_idx, device_name, reg_uid, reg_date, mod_uid, mod_date )
VALUES ( 'c8cbb39d', '22e83dfc', '1', 'GOODCEN','admin', NOW(), 'admin', NOW());
INSERT INTO tb_device (device_id, site_id, user_idx, device_name, reg_uid, reg_date, mod_uid, mod_date )
VALUES ( 'd13bddbc', 'c64b328b', '1', '계량3_전분제분양곡', 'admin', NOW(), 'admin', NOW());
INSERT INTO tb_device (device_id, site_id, user_idx, device_name, reg_uid, reg_date, mod_uid, mod_date )
VALUES ( 'becba3df', 'c64b328b', '1', 'GOODCEN', 'admin', NOW(), 'admin', NOW());
INSERT INTO tb_device (device_id, site_id, user_idx, device_name, reg_uid, reg_date, mod_uid, mod_date )
VALUES ( '39d32145', '7532a5c', '1', 'GOODCEN', 'admin', NOW(), 'admin', NOW());
INSERT INTO tb_device (device_id, site_id, user_idx, device_name, reg_uid, reg_date, mod_uid, mod_date )
VALUES ( '38d31fb2', '7532a5c', '1', 'GOODCEN', 'admin', NOW(), 'admin', NOW());
INSERT INTO tb_device (device_id, site_id, user_idx, device_name, reg_uid, reg_date, mod_uid, mod_date )
VALUES ( 'df3e325d', '7532a5c', '1', '계량4_기계실앞', 'admin', NOW(), 'admin', NOW());
INSERT INTO tb_device (device_id, site_id, user_idx, device_name, reg_uid, reg_date, mod_uid, mod_date )
VALUES ( '36d31c8c', '7532a5c', '1', 'GOODCEN', 'admin', NOW(), 'admin', NOW());
INSERT INTO tb_device (device_id, site_id, user_idx, device_name, reg_uid, reg_date, mod_uid, mod_date )
VALUES ( 'de3e30ca', 'af19e136', '1', '계량5_맘씨', 'admin', NOW(), 'admin', NOW());
INSERT INTO tb_device (device_id, site_id, user_idx, device_name, reg_uid, reg_date, mod_uid, mod_date )
VALUES ( 'd93e28eb', 'f23ac0b6', '1', '계량6_유정란', 'admin', NOW(), 'admin', NOW());
INSERT INTO tb_device (device_id, site_id, user_idx, device_name, reg_uid, reg_date, mod_uid, mod_date )
VALUES ( 'd73e25c5', '67b72dfb', '1', '계량7_밀크쿱', 'admin', NOW(), 'admin', NOW());
INSERT INTO tb_device (device_id, site_id, user_idx, device_name, reg_uid, reg_date, mod_uid, mod_date )
VALUES ( 'be6c171', '1feef4db', '2', '괴산냉동창고', 'admin', NOW(), 'admin', NOW());
INSERT INTO tb_device (device_id, site_id, user_idx, device_name, reg_uid, reg_date, mod_uid, mod_date )
VALUES ( '11e9097a', '2f292a5a', '2', '괴산_해피푸르츠', 'admin', NOW(), 'admin', NOW());
INSERT INTO tb_device (device_id, site_id, user_idx, device_name, reg_uid, reg_date, mod_uid, mod_date )
VALUES ( 'de6c497', 'bb3090b9', '2', '괴산순수유', 'admin', NOW(), 'admin', NOW());
INSERT INTO tb_device (device_id, site_id, user_idx, device_name, reg_uid, reg_date, mod_uid, mod_date )
VALUES ( '9e6be4b', '68c1699c', '2', '괴산쿱양콕', 'admin', NOW(), 'admin', NOW());


-------------------------------------------------------------------------------------------------------------------------------------------------------


insert into tb_user (user_id, user_pw, user_type, main_user_idx, main_user_yn, auth_type, lang_type, co_name, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('test01','1234','2','1','Y','4','1','아트카스토리','N','admin',now(),'admin',now());

insert into tb_user (user_id, user_pw, user_type, main_user_idx, main_user_yn, auth_type, lang_type, co_name, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('test02','1234','2','1','Y','4','2','미즈메디병원','N','admin',now(),'admin',now());

insert into tb_user (user_id, user_pw, user_type, main_user_idx, main_user_yn, auth_type, lang_type, co_name, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('test03','1234','2','1','Y','4','3','서울면옥','N','admin',now(),'admin',now());



insert into tb_site (site_id, user_idx, site_name, area_type, time_zone, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('2d91098','1','아트카스토리','01','GMT+8','N','admin',now(),'admin',now());

insert into tb_site (site_id, user_idx, site_name, area_type, time_zone, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('6f4288d','2','미즈메디병원','01','GMT+8','N','admin',now(),'admin',now());

insert into tb_site (site_id, user_idx, site_name, area_type, time_zone, del_yn, reg_uid, reg_date, mod_uid, mod_date)
values ('c30f2c6d','3','서울면옥','01','GMT+8','N','admin',now(),'admin',now());



insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( '3d0f2bc9', '2d91098', '1', '아트카스토리_장치01', '1', 'admin', now(), 'admin', now());

insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( '3c0f2a36', '2d91098', '1', '아트카스토리_장치02', '1', 'admin', now(), 'admin', now());

insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( 'cf2ce78d', '2d91098', '1', '아트카스토리_장치03', '1', 'admin', now(), 'admin', now());

insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( 'ce2ce5fa', '2d91098', '1', '아트카스토리_장치04', '1', 'admin', now(), 'admin', now());



insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( '5aaf931b', '6f4288d', '2', '미즈메디병원_장치01', '1', 'admin', now(), 'admin', now());

insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( '5daf97d4', '6f4288d', '2', '미즈메디병원_장치02', '1', 'admin', now(), 'admin', now());

insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( '53af8816', '6f4288d', '2', '미즈메디병원_장치03', '1', 'admin', now(), 'admin', now());

insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( 'd0b4ca0b', '6f4288d', '2', '미즈메디병원_장치04', '1', 'admin', now(), 'admin', now());

insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( '5dbc63c7', '6f4288d', '2', '미즈메디병원_장치05', '1', 'admin', now(), 'admin', now());

insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( '52bc5276', '6f4288d', '2', '미즈메디병원_장치06', '1', 'admin', now(), 'admin', now());

insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( '53bc5409', '6f4288d', '2', '미즈메디병원_장치07', '1', 'admin', now(), 'admin', now());

insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( '4a9bf233', '6f4288d', '2', '미즈메디병원_장치08', '1', 'admin', now(), 'admin', now());

insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( '499bf0a0', '6f4288d', '2', '미즈메디병원_장치09', '1', 'admin', now(), 'admin', now());

insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( '509bfba5', '6f4288d', '2', '미즈메디병원_장치10', '1', 'admin', now(), 'admin', now());

insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( '4f9bfa12', '6f4288d', '2', '미즈메디병원_장치11', '1', 'admin', now(), 'admin', now());

insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( '47da3e40', '6f4288d', '2', '미즈메디병원_장치12', '1', 'admin', now(), 'admin', now());



insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( 'e9a2c981', 'c30f2c6d', '3', '서울면옥_장치01', '1', 'admin', now(), 'admin', now());

insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( 'e8a2c7ee', 'c30f2c6d', '3', '서울면옥_장치02', '1', 'admin', now(), 'admin', now());

insert into tb_device (device_id, site_id, user_idx, device_name, inst_type, reg_uid, reg_date, mod_uid, mod_date )
values ( 'e7a2c65b', 'c30f2c6d', '3', '서울면옥_장치03', '1', 'admin', now(), 'admin', now());



insert into tb_site_set (site_id, plan_type, plan_name, contract_power, meter_read_day, charge_yearm, charge_power, charge_rate, goal_power, smp_rate, rec_rate, rec_weight, profit_ratio, del_yn, reg_uid, reg_date, mod_uid, mod_date) values
('2d91098', 'general_A1_low_voltage_A', '일반용 (갑) 저압', 1200, 25, '201810', 1200, 1, 1000, 1, 1, 1, 0, 'N', 'admin', now(), 'admin', now());

insert into tb_site_set (site_id, plan_type, plan_name, contract_power, meter_read_day, charge_yearm, charge_power, charge_rate, goal_power, smp_rate, rec_rate, rec_weight, profit_ratio, del_yn, reg_uid, reg_date, mod_uid, mod_date) values
('6f4288d', 'general_A1_low_voltage_A', '일반용 (갑) 저압', 1200, 25, '201810', 1200, 1, 1000, 1, 1, 1, 0, 'N', 'admin', now(), 'admin', now());

insert into tb_site_set (site_id, plan_type, plan_name, contract_power, meter_read_day, charge_yearm, charge_power, charge_rate, goal_power, smp_rate, rec_rate, rec_weight, profit_ratio, del_yn, reg_uid, reg_date, mod_uid, mod_date) values
('c30f2c6d', 'general_A1_low_voltage_A', '일반용 (갑) 저압', 1200, 25, '201810', 1200, 1, 1000, 1, 1, 1, 0, 'N', 'admin', now(), 'admin', now());

