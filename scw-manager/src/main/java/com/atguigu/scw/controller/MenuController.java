package com.atguigu.scw.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.scw.bean.TMenu;
import com.atguigu.scw.service.TMenuService;

@Controller
public class MenuController {
	@Autowired
	TMenuService menuService;
	
	/**
	 * 删除
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/menu/delMenu")
	public String delMenu(Integer id) {
		menuService.delMenu(id);
		return "ok";
	}
	
	/**
	 * 根据id获取菜单，用于回显数据
	 */
	@ResponseBody
	@RequestMapping("/menu/getMenu")
	public TMenu getMenu(Integer id) {
		TMenu menu = menuService.getMenu(id);
		return menu;
	}
	/**
	 * 修改
	 * @param menu
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/menu/updateMenu")
	public String updateMenu(TMenu menu) {
		menuService.updateMenu(menu);
		return "ok";
	}
	
	
	/**
	 * 添加
	 */
	@ResponseBody
	@RequestMapping("/menu/saveMenu")
	public String saveMenu(TMenu menu) {
		menuService.saveMenu(menu);
		return "ok";
	}
	
	
	
	/**
	 * 获取菜单（TREE）
	 */
	@ResponseBody
	@RequestMapping("/menu/loadTree")
	public List<TMenu> loadTree() {
		List<TMenu> listMenu = menuService.loadAllMenu();
		return listMenu;
	}
	
	/**
	 * 去菜单参数页
	 * @return
	 */
	@RequestMapping("/menu/index")
	public String toIndex() {
		return "menu/index";
	}
	
}
