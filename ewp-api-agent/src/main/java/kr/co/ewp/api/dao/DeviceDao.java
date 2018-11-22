package kr.co.ewp.api.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.Device;
import kr.co.ewp.api.util.PrettyLog;

@Mapper
public interface DeviceDao extends BaseDao<Device, String> {

  List<Device> selectListBySiteId(@Param("siteId") String siteId, PrettyLog prettyLog);
}
