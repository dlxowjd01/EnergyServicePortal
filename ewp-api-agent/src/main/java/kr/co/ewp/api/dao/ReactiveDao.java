package kr.co.ewp.api.dao;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.Reactive;
import kr.co.ewp.api.util.PrettyLog;

@Mapper
public interface ReactiveDao extends BaseDao<Reactive, String> {

  Reactive selectOneLastReactive(@Param("siteId") String siteId, @Param("deviceId") String deviceId, PrettyLog prettyLog);

  Reactive selectOneByUnique(@Param("siteId") String siteId, @Param("deviceId") String deviceId, @Param("stdTimestamp") Date stdTimestamp, PrettyLog prettyLog);

  List<Reactive> selectReactiveListBySiteId(@Param("siteId") String siteId, @Param("begin") Date begin, @Param("end") Date end, PrettyLog prettyLog);
}
