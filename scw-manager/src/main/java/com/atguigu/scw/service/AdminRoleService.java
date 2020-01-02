package com.atguigu.scw.service;

import java.util.List;

import com.atguigu.scw.bean.TRole;

public interface AdminRoleService {

	List<TRole> getNotSelected(Integer adminid);

	List<TRole> getSelected(Integer adminid);

	void addRoleToAdmin(String str, Integer adminid);

	void delRoleToAdmin(String str, Integer adminid);

}
