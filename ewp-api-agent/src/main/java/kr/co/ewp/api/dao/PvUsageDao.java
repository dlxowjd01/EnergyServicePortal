package kr.co.ewp.api.dao;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.PvUsage;
import kr.co.ewp.api.util.PrettyLog;

@Mapper
public interface PvUsageDao extends BaseDao<PvUsage, String> {

  PvUsage selectOneLast(@Param("siteId") String siteId, @Param("deviceId") String deviceId, PrettyLog prettyLog);

  PvUsage selectOneByUnique(@Param("siteId") String siteId, @Param("deviceId") String deviceId, @Param("stdTimestamp") Date stdTimestamp, PrettyLog prettyLog);

  List<PvUsage> selectPvUsageListBySiteId(@Param("siteId") String siteId, @Param("beginDate") Date beginDate, @Param("endDate") Date endDate, PrettyLog prettyLog);

}
