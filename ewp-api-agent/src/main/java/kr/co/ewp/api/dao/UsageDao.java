package kr.co.ewp.api.dao;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.Usage;
import kr.co.ewp.api.util.PrettyLog;

@Mapper
public interface UsageDao extends BaseDao<Usage, String> {

  Usage selectOneByUnique(@Param("siteId") String siteId, @Param("deviceId") String deviceId, @Param("stdTimestamp") Date stdTimestamp, PrettyLog prettyLog);

  Usage selectOneLastUage(@Param("siteId") String siteId, @Param("deviceId") String deviceId, PrettyLog prettyLog);

  List<Usage> selectListByDeviceId(@Param("deviceId") String deviceId, @Param("begin") Date begin, @Param("end") Date end, PrettyLog prettyLog);

  List<Usage> selectListBySiteId(@Param("siteId") String siteId, @Param("begin") Date begin, @Param("end") Date end, PrettyLog prettyLog);
}
