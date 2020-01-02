package com.atguigu.scw.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.scw.bean.TAdmin;
import com.atguigu.scw.bean.TRole;
import com.atguigu.scw.service.RoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Controller
public class RoleController {
	@Autowired
	RoleService roleService;
	
	
	@ResponseBody
	@RequestMapping("/role/deleteRoles")
	public String deleteRoles(String str) {
		roleService.deleteRoles(str);
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/role/deleteRole")
	public String deleteRole(Integer id) {
		roleService.deleteRole(id);
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/role/updateRole")
	public String updateRole(TRole role) {
		roleService.updateRole(role);
		return "ok";
	}
	
	/**
	 * 根据id获取角色
	 */
	@ResponseBody
	@RequestMapping("/role/getRole")
	public TRole getRole(Integer id) {
		TRole role = roleService.getRole(id);
		return role;
	}
	
	/**
	 * 添加角色
	 * @param role
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/role/saveRole")
	public String saveRole(TRole role) {
		
		roleService.saveRole(role);
		
		return "ok";
	}
	
	/**
	 * 获取分页信息等
	 */
	@ResponseBody
	@RequestMapping("/role/roleList")
	public PageInfo<TRole> index(@RequestParam(value="pageNum",required=false,defaultValue="1")Integer pageNum,
						@RequestParam(value="pageSize",required=false,defaultValue="2")Integer pageSize,
						@RequestParam(value="keyWord",required=false,defaultValue="")String keyWord) {
		//开启分页业务
		PageHelper.startPage(pageNum, pageSize);
		//存放查询条件
		Map<String,Object> paramMap = new HashMap<String,Object>();
		paramMap.put("keyWord", keyWord);
		//获取分页信息
		PageInfo<TRole> page = roleService.listRolePage(paramMap);
		
		return page;
	}
	
	
	
	
	/**
	 * 从主页面跳到角色维护页面
	 * @return
	 */
	@RequestMapping("/role/index")
	public String goIndex() {
		
		return "role/index";
	}
}
