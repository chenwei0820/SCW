package com.atguigu.scw.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.scw.bean.TMenu;
import com.atguigu.scw.dao.TMenuMapper;
import com.atguigu.scw.service.TMenuService;

@Service
public class TMenuServiceImpl implements TMenuService {

	@Autowired
	TMenuMapper menuMapper;

	@Override
	public List<TMenu> listMenu() {
		// 用于存放父菜单
		List<TMenu> parentList = new ArrayList<TMenu>();

		// 用于关联子菜单和父菜单
		Map<Integer, TMenu> parentMap = new HashMap<Integer, TMenu>();

		List<TMenu> allList = menuMapper.selectByExample(null);
		// 循环存储父菜单
		for (TMenu tMenu : allList) {
			if (tMenu.getPid() == 0) {
				parentList.add(tMenu);
				parentMap.put(tMenu.getId(), tMenu);
			}
		}
		//关联子菜单和父菜单
		for (TMenu tMenu : allList) {
			
			if (tMenu.getPid() != 0) {
				Integer pid = tMenu.getPid();
				//pid不是0的就是子菜单，子菜单的pid就是父菜单的id
				TMenu parentMenu = parentMap.get(pid);
				//关联
				System.out.println(parentMenu.toString());
				System.out.println(tMenu.toString());
				parentMenu.getChildren().add(tMenu);
			}
		}
		return parentList;
	}

	@Override
	public List<TMenu> loadAllMenu() {
		
		return menuMapper.selectByExample(null);
	}

	@Override
	public void saveMenu(TMenu menu) {
		
		menuMapper.insertSelective(menu);
	}

	@Override
	public void updateMenu(TMenu menu) {
		menuMapper.updateByPrimaryKeySelective(menu);
	}

	@Override
	public void delMenu(Integer id) {
		menuMapper.deleteByPrimaryKey(id);
		
	}

	@Override
	public TMenu getMenu(Integer id) {
		TMenu menu = menuMapper.selectByPrimaryKey(id);
		return menu;
	}
}
