package kr.co.ewp.api.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ewp.api.dao.SiteDao;
import kr.co.ewp.api.dao.SiteSetDao;
import kr.co.ewp.api.entity.Site;
import kr.co.ewp.api.entity.SiteSet;
import kr.co.ewp.api.util.PrettyLog;

@Service
@Transactional
public class SiteService {

  @Autowired
  private SiteDao siteDao;
  @Autowired
  private SiteSetDao siteSetDao;

  @Transactional(readOnly = true)
  public List<Site> getSiteList(PrettyLog prettyLog) {
    return siteDao.selectList(prettyLog);
  }

  @Transactional(readOnly = true)
  public Site getSite(String siteId, PrettyLog prettyLog) {
    return siteDao.selectOne(siteId, prettyLog);
  }

  @Transactional(readOnly = true)
  public SiteSet getSiteSet(String siteId, PrettyLog prettyLog) {
    return siteSetDao.selectOne(siteId, prettyLog);
  }
}
