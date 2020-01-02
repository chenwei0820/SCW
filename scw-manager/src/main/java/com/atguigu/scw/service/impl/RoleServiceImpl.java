package com.atguigu.scw.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.scw.bean.TRole;
import com.atguigu.scw.bean.TRoleExample;
import com.atguigu.scw.dao.TRoleMapper;
import com.atguigu.scw.service.RoleService;
import com.atguigu.scw.util.StringUtil;
import com.github.pagehelper.PageInfo;
@Service
public class RoleServiceImpl implements RoleService {
	@Autowired
	TRoleMapper roleMapper;
	
	
	
	/**
	 * 获取分页信息
	 * 
	 */
	@Override
	public PageInfo<TRole> listRolePage(Map<String, Object> paramMap) {
		TRoleExample example = new TRoleExample();
		String keyWord = (String) paramMap.get("keyWord");
		if(StringUtil.isNotEmpty(keyWord)) {
			example.createCriteria().andNameLike("%" + keyWord + "%");
		}
		List<TRole> list = roleMapper.selectByExample(example);
		PageInfo<TRole> page = new PageInfo<TRole>(list, 5);
		return page;
	}


	/**
	 * 添加角色
	 */
	@Override
	public void saveRole(TRole role) {
		roleMapper.insertSelective(role);
		
	}

	/**
	 * 根据id获取角色
	 */
	@Override
	public TRole getRole(Integer id) {
		TRole role = roleMapper.selectByPrimaryKey(id);
		return role;
	}

	/**
	 * 更新信息
	 */
	@Override
	public void updateRole(TRole role) {
		roleMapper.updateByPrimaryKeySelective(role);
		
	}

	/**
	 * 删除信息
	 */
	@Override
	public void deleteRole(Integer id) {
		roleMapper.deleteByPrimaryKey(id);		
	
	}

	/**
	 * 批量删除
	 */
	@Override
	public void deleteRoles(String str) {
		String[] strings = str.split(",");
		List<Integer> idList = new ArrayList<Integer>();
		for (String strId : strings) {
			int intId = Integer.parseInt(strId);
			idList.add(intId);
		}
		roleMapper.deleteRolesById(idList);		
	}
	
}
