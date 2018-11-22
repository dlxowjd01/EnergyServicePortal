package kr.co.ewp.api.dao;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.PvGen;
import kr.co.ewp.api.util.PrettyLog;

@Mapper
public interface PvGenDao extends BaseDao<PvGen, String> {
  PvGen selectOneByUnique(@Param("siteId") String siteId, @Param("deviceId") String deviceId, @Param("stdDate") Date stdDate, PrettyLog prettyLog);

  PvGen selectOneLast(@Param("siteId") String siteId, @Param("deviceId") String deviceId, PrettyLog prettyLog);

  List<PvGen> selectPvGenListBySiteId(@Param("siteId") String siteId, @Param("beginDate") Date beginDate, @Param("endDate") Date endDate, PrettyLog prettyLog);
}
