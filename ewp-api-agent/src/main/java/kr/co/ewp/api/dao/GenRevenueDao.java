package kr.co.ewp.api.dao;

import java.util.Date;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.GenRevenue;
import kr.co.ewp.api.util.PrettyLog;

@Mapper
public interface GenRevenueDao extends BaseDao<GenRevenue, String> {

  GenRevenue selectOneByUnique(@Param("siteId") String siteId, @Param("genType") String genType, @Param("stdTimestamp") Date stdTimestamp, PrettyLog prettyLog);

  GenRevenue selectOneLast(@Param("siteId") String siteId, PrettyLog prettyLog);
}
