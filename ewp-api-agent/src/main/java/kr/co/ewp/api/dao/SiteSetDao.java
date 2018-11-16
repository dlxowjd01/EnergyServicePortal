package kr.co.ewp.api.dao;
import org.apache.ibatis.annotations.Mapper;
import kr.co.ewp.api.dao.base.BaseDao;
import kr.co.ewp.api.entity.SiteSet;
@Mapper
public interface SiteSetDao extends BaseDao<SiteSet, String> {
}
