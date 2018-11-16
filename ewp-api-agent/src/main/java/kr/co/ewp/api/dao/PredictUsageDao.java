package kr.co.ewp.api.dao;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.PredictUsage;
import kr.co.ewp.api.util.PrettyLog;

@Mapper
public interface PredictUsageDao extends BaseDao<PredictUsage, String> {
  PredictUsage selectOneLastPredictUage(@Param("siteId") String siteId, @Param("deviceId") String deviceId, PrettyLog prettyLog);

  PredictUsage selectOneByUnique(@Param("siteId") String siteId, @Param("deviceId") String deviceId, @Param("stdTimestamp") Date stdTimestamp, PrettyLog prettyLog);

  List<PredictUsage> selectListByDeviceId(@Param("deviceId") String deviceId, @Param("begin") Date begin, @Param("end") Date end, PrettyLog prettyLog);
}
