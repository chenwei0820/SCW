package com.atguigu.scw.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.scw.bean.TAdminRole;
import com.atguigu.scw.bean.TAdminRoleExample;
import com.atguigu.scw.bean.TAdminRoleExample.Criteria;
import com.atguigu.scw.bean.TRole;
import com.atguigu.scw.bean.TRoleExample;
import com.atguigu.scw.dao.TAdminRoleMapper;
import com.atguigu.scw.dao.TRoleMapper;
import com.atguigu.scw.service.AdminRoleService;

@Service
public class AdminRoleServiceImpl implements AdminRoleService {
	@Autowired
	TAdminRoleMapper adminRoleMapper;
	@Autowired
	TRoleMapper roleMapper;

	/**
	 * 获取未分配的角色
	 */
	@Override
	public List<TRole> getNotSelected(Integer adminid) {

		// 先根据adminid获取选中的角色ID的list集合
		TAdminRoleExample example = new TAdminRoleExample();
		Criteria criteria = example.createCriteria();
		criteria.andAdminidEqualTo(adminid);
		List<TAdminRole> seleceedRole = adminRoleMapper.selectByExample(example);
		List<Integer> seleceedRoleId = new ArrayList<Integer>();
		// 循环遍历取出已选中角色的id
		for (TAdminRole tAdminRole : seleceedRole) {
			Integer roleid = tAdminRole.getRoleid();
			seleceedRoleId.add(roleid);
		}
		// 根据已选中角色ID的集合，获取未选中角色的集合
		TRoleExample example2 = new TRoleExample();
		com.atguigu.scw.bean.TRoleExample.Criteria criteria2 = example2.createCriteria();
		criteria2.andIdNotIn(seleceedRoleId);
		List<TRole> listNotSelectedRole = roleMapper.selectByExample(example2);
		return listNotSelectedRole;
	}

	/**
	 * 获取已分配的角色
	 */
	@Override
	public List<TRole> getSelected(Integer adminid) {
		// 先根据adminid获取选中的角色ID的list集合
		TAdminRoleExample example = new TAdminRoleExample();
		Criteria criteria = example.createCriteria();
		criteria.andAdminidEqualTo(adminid);
		List<TAdminRole> seleceedRole = adminRoleMapper.selectByExample(example);
		List<Integer> seleceedRoleId = new ArrayList<Integer>();
		// 循环遍历取出已选中角色的id
		for (TAdminRole tAdminRole : seleceedRole) {
			Integer roleid = tAdminRole.getRoleid();
			seleceedRoleId.add(roleid);
		}
		//根据已选中的ID获取已选中的role
		TRoleExample example2 = new TRoleExample();
		com.atguigu.scw.bean.TRoleExample.Criteria criteria2 = example2.createCriteria();
		criteria2.andIdIn(seleceedRoleId);
		List<TRole> listRole = roleMapper.selectByExample(example2);
		return listRole;
	}
	/**
	 * 为用户添加角色
	 */
	@Override
	public void addRoleToAdmin(String str, Integer adminid) {
		//获取新选中的role的id
		String[] idStr = str.split(",");
		for (String roleIdStr : idStr) {
			TAdminRole adminRole = new TAdminRole();
			Integer roleIdInt = Integer.parseInt(roleIdStr);
			adminRole.setRoleid(roleIdInt);
			adminRole.setAdminid(adminid);
			adminRoleMapper.insertSelective(adminRole);
		}	
	}

	@Override
	public void delRoleToAdmin(String str, Integer adminid) {
		// TODO Auto-generated method stub
		String[] idStr = str.split(",");
		List<Integer> roleIdList = new ArrayList<Integer>();
		for (String roleIdStr : idStr) {
			TAdminRole adminRole = new TAdminRole();
			Integer roleIdInt = Integer.parseInt(roleIdStr);
			roleIdList.add(roleIdInt);
		}	
		adminRoleMapper.deleteByAdminidAndRoleId(adminid,roleIdList);
	}

}
