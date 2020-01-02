package com.atguigu.scw.service;

import java.util.Map;

import com.atguigu.scw.bean.TRole;
import com.github.pagehelper.PageInfo;

public interface RoleService {

	PageInfo<TRole> listRolePage(Map<String, Object> paramMap);

	void saveRole(TRole role);

	TRole getRole(Integer id);

	void updateRole(TRole role);

	void deleteRole(Integer id);

	void deleteRoles(String str);

}
