package kr.co.ewp.api.dao;

import java.util.Date;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.EssChargePlan;
import kr.co.ewp.api.util.PrettyLog;

@Mapper
public interface EssChargePlanDao extends BaseDao<EssChargePlan, String> {
  EssChargePlan selectOneByUnique(@Param("siteId") String siteId, @Param("deviceId") String deviceId, @Param("stdTimestamp") Date stdTimestamp, PrettyLog prettyLog);

  EssChargePlan selectOneLast(@Param("siteId") String siteId, @Param("deviceId") String deviceId, PrettyLog prettyLog);
}
