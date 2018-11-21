package kr.co.ewp.api.dao;
import org.apache.ibatis.annotations.Mapper;
import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.DeviceGroup;
@Mapper
public interface DeviceGroupDao extends BaseDao<DeviceGroup, String> {
}
