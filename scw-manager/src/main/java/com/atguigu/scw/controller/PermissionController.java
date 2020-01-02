package com.atguigu.scw.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.scw.bean.TPermission;
import com.atguigu.scw.service.PermissionService;

@Controller
public class PermissionController {

	@Autowired
	PermissionService permissionService;
	
	
	/**
	 * 删除权限信息
	 * @param permission
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/permission/delPermission")
	public String delPermission(Integer id) {
		permissionService.delPermission(id);
		return "ok";
	}
	
	/**
	 * 根据id获取权限信息
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/permission/getPermission")
	public TPermission getPermission(Integer id) {
		TPermission permission = permissionService.getPermission(id);
		return permission;
		
	}
	
	/**
	 * 修改权限信息
	 * @param permission
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/permission/updatePermission")
	public String updatePermission(TPermission permission) {
		permissionService.updatePermission(permission);
		return "ok";
	}
	
	/**
	 * 添加
	 * @param permission
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/permisssion/savePermisssion")
	public String savePermisssion(TPermission permission) {
		permissionService.savePermisssion(permission);
		return "ok";
	}
	
	/**
	 * 获取全部权限信息
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/permission/listALLPermission")
	public List<TPermission> listALLPermission() {
		List<TPermission> listPermission = permissionService.getListALLPermission();
		return listPermission;
		
	}
	
	
	
	//去权限维护界面
	@RequestMapping("/permission/index")
	public String toIndex() {
		return "permission/index";
	}
}
