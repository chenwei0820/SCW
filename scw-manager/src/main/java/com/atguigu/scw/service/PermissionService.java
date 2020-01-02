package com.atguigu.scw.service;

import java.util.List;

import com.atguigu.scw.bean.TPermission;

public interface PermissionService {

	List<TPermission> getListALLPermission();

	void savePermisssion(TPermission permission);

	void updatePermission(TPermission permission);

	TPermission getPermission(Integer id);

	void delPermission(Integer id);

}
