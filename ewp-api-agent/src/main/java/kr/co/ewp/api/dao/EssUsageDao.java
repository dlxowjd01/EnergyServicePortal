package kr.co.ewp.api.dao;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.EssUsage;
import kr.co.ewp.api.util.PrettyLog;

@Mapper
public interface EssUsageDao extends BaseDao<EssUsage, String> {
  EssUsage selectOneByUnique(@Param("siteId") String siteId, @Param("deviceId") String deviceId, @Param("stdDate") Date stdDate, PrettyLog prettyLog);

  EssUsage selectOneLast(@Param("siteId") String siteId, @Param("deviceId") String deviceId, PrettyLog prettyLog);

  List<EssUsage> selectEssUsageListBySiteId(@Param("siteId") String siteId, @Param("beginDate") Date beginDate, @Param("endDate") Date endDate, PrettyLog prettyLog);

}
