package com.atguigu.scw.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.scw.bean.TPermission;
import com.atguigu.scw.dao.TPermissionMapper;
import com.atguigu.scw.service.PermissionService;
@Service
public class PermissionServiceImpl implements PermissionService {
	@Autowired
	TPermissionMapper permissionMapper;
	/**
	 * 获取全部权限信息
	 */
	@Override
	public List<TPermission> getListALLPermission() {
		List<TPermission> selectByExample = permissionMapper.selectByExample(null);
		return selectByExample;
	}
	
	/**
	 * 添加权限信息
	 */
	@Override
	public void savePermisssion(TPermission permission) {
		permissionMapper.insertSelective(permission);
		
	}
	/**
	 * 修改权限信息
	 */
	@Override
	public void updatePermission(TPermission permission) {
		permissionMapper.updateByPrimaryKeySelective(permission);		
	}
	/**
	 * 根据id获取权限信息
	 */
	@Override
	public TPermission getPermission(Integer id) {
		TPermission selectByPrimaryKey = permissionMapper.selectByPrimaryKey(id);
		return selectByPrimaryKey;
	}
	/**
	 * 删除权限信息
	 */
	@Override
	public void delPermission(Integer id) {
		permissionMapper.deleteByPrimaryKey(id);
		
	}
}
