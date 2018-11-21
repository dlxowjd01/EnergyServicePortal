package kr.co.ewp.api.dao;

import java.util.Date;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.DrRevenue;
import kr.co.ewp.api.util.PrettyLog;

@Mapper
public interface DrRevenueDao extends BaseDao<DrRevenue, String> {

  DrRevenue selectOneLast(@Param("siteId") String siteId, PrettyLog prettyLog);

  DrRevenue selectOneByUnique(@Param("siteId") String siteId, @Param("stdTimestamp") Date stdTimestamp, @Param("reductStimestamp") Date reductStimestamp, PrettyLog prettyLog);
}
