package kr.co.ewp.api.dao;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.EssCharge;
import kr.co.ewp.api.util.PrettyLog;

@Mapper
public interface EssChargeDao extends BaseDao<EssCharge, String> {
  EssCharge selectOneByUnique(@Param("siteId") String siteId, @Param("deviceId") String deviceId, @Param("stdTimestamp") Date stdTimestamp, PrettyLog prettyLog);

  EssCharge selectOneLast(@Param("siteId") String siteId, @Param("deviceId") String deviceId, PrettyLog prettyLog);

  List<EssCharge> selectEssChargeListBySiteId(@Param("siteId") String siteId, @Param("beginDate") Date beginDate, @Param("endDate") Date endDate, PrettyLog prettyLog);
}
