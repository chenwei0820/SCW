package com.atguigu.scw.service;

import java.util.List;

import com.atguigu.scw.bean.TMenu;

public interface TMenuService {

	public List<TMenu> listMenu();

	public List<TMenu> loadAllMenu();

	public void saveMenu(TMenu menu);

	public void updateMenu(TMenu menu);

	public void delMenu(Integer id);

	public TMenu getMenu(Integer id);

}
