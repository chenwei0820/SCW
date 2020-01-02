package com.atguigu.scw.service;

import java.util.Map;

import com.atguigu.scw.bean.TAdmin;
import com.github.pagehelper.PageInfo;

public interface AdminService {

	public TAdmin selectByLogin(String loginacct,String userpswd);

	public PageInfo<TAdmin> listAdminPage(Map<String, Object> paramMap);

	public void saveAdmin(TAdmin admin);

	public TAdmin getAdminById(Integer id);

	public void updateAdmin(TAdmin admin);

	public void deleteAdminById(Integer id);

	public void deleteBatch(String ids);
}
