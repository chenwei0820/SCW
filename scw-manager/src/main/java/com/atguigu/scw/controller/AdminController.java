package com.atguigu.scw.controller;



import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.scw.bean.TAdmin;
import com.atguigu.scw.bean.TMenu;
import com.atguigu.scw.bean.TRole;
import com.atguigu.scw.service.AdminRoleService;
import com.atguigu.scw.service.AdminService;
import com.atguigu.scw.service.TMenuService;
import com.atguigu.scw.util.Const;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Controller
public class AdminController {

	@Autowired
	AdminService adminService;
	
	@Autowired
	TMenuService menuService;
	
	@Autowired
	AdminRoleService  adminRoleService;
	
	@ResponseBody
	@RequestMapping("/admin/delRoleToAdmin")
	public String  delRoleToAdmin(String str,Integer adminid) {
		//在adminrole表中添加信息
		System.out.println(adminid);
		adminRoleService.delRoleToAdmin(str,adminid);
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/admin/addRoleToAdmin")
	public String  addRoleToAdmin(String str,Integer adminid) {
		//在adminrole表中添加信息
		System.out.println(adminid);
		adminRoleService.addRoleToAdmin(str,adminid);
		return "ok";
	}
	
	
	
	/**
	 * 获取选中的角色集合
	 * @param adminid
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/admin/getSelected")
	public List<TRole> getSelected(Integer adminid) {
		List<TRole> roleList = adminRoleService.getSelected(adminid);
		return roleList;
	}
	
	/**
	 * 获取未选中的角色集合
	 * @param adminid
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/admin/getNotSelected")
	public List<TRole> getNotSelect(Integer adminid) {
		List<TRole> roleList = adminRoleService.getNotSelected(adminid);
		return roleList;
	}
	/**
	 * 去往角色用户关联设置页面
	 * @param adminid
	 * @return
	 */
	@RequestMapping("/admin/toAssignRole")
	public String toAssignRole(Integer adminid) {
//		return "redirect:/admin/assignRole?id="+id;
		return "admin/assignRole";
	}
	
	//**************************************************************************************
	
	/**
	 * 批量删除
	 * @param ids
	 * @param pageNum
	 * @return
	 */
	@RequestMapping("/admin/deleteBatch")
	public String deleteBatch(String ids,String pageNum) {
		adminService.deleteBatch(ids);
		
		return "redirect:/admin/index?pageNum="+pageNum;
	}
	
	
	@RequestMapping("/admin/delete")
	public String deleteBatch(Integer id,String pageNum) {
		System.out.println(id);
		adminService.deleteAdminById(id);
		
		return "redirect:/admin/index?pageNum="+pageNum;
	}
	
	/**
	 * 修改
	 * @param admin
	 * @param pageNum
	 * @return
	 */
	@RequestMapping("/admin/doUpdate")
	public String updateAdmin(TAdmin admin,Integer pageNum) {
		
		adminService.updateAdmin(admin);

		return "redirect:/admin/index?pageNum="+pageNum;
	}
	/**
	 * 去修改
	 * @param id
	 * @param map
	 * @return
	 */
	@RequestMapping("/admin/toUpdate")
	public String toUpdate(Integer id,Model model) {
		
		TAdmin admin = adminService.getAdminById(id);
		model.addAttribute("admin", admin);
		return "admin/update";
	}
	
	/**
	 * 添加
	 * @return
	 */
	@RequestMapping("/admin/doAdd")
	public String addAdmin(TAdmin admin) {
		adminService.saveAdmin(admin);

		return "redirect:/admin/index?pageNum="+Integer.MAX_VALUE;
	}
	
	/**
	 * 去添加页面
	 * @return
	 */
	@RequestMapping("/admin/toAdd")
	public String toAdd() {
		return "admin/add";
	}
	
	/**
	 * 分页数据
	 * @param pageNum
	 * @param pageSize
	 * @param keyWord
	 * @param map
	 * @return
	 */
	@RequestMapping("/admin/index")
	public String index(@RequestParam(value="pageNum",required=false,defaultValue="1")Integer pageNum,
						@RequestParam(value="pageSize",required=false,defaultValue="2")Integer pageSize,
						@RequestParam(value="keyWord",required=false,defaultValue="")String keyWord,
						Map map) {
		//开启分页业务
		PageHelper.startPage(pageNum, pageSize);
		//存放查询条件
		Map<String,Object> paramMap = new HashMap<String,Object>();
		paramMap.put("keyWord", keyWord);
		//获取分页信息
		PageInfo<TAdmin> page = adminService.listAdminPage(paramMap);
		map.put("page", page);
		
		return "admin/index";
	}
	
	
	
	//********************登陆注销和菜单***************************
	/**
	 * 菜单显示
	 * @param session
	 * @return
	 */
	@RequestMapping("/main")
	public String main(HttpSession session) {
		//查看session域中是否存在父菜单的集合
		List<TMenu> listMenu = (List<TMenu>)session.getAttribute("parentList");
		//如果不存在就从数据库中获取父菜单集合，并存放到session域中
		if(listMenu == null) {
			listMenu = menuService.listMenu();
			session.setAttribute("parentList", listMenu);
		}
		
		return "main";
	}

	/**
	 * 登录 判断用户名和密码是否正确
	 * 
	 * @param loginacct
	 * @param userpswd
	 * @return
	 */
	@RequestMapping("/doLogin")
	public String doLogin(String loginacct, String userpswd, HttpSession session) {
		session.setAttribute("loginacct", loginacct);
		
		try {
			TAdmin admin = adminService.selectByLogin(loginacct, userpswd);
			if (admin == null) {
				session.setAttribute("message", Const.LOGIN_LOGINACCT_ERROR);
				return "redirect:/login.jsp";
			}else {
				// 采用重定向进行跳转页面，避免表单的重复提交。
				session.setAttribute("loginacct", loginacct);
				
				return "redirect:/main";
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			session.setAttribute("message", e.getMessage());
			session.setAttribute("loginacct", loginacct);
			e.printStackTrace();
			return "redirect:/login.jsp";
		}

		

	}
	/**
	 * 注销
	 * @param session
	 * @return
	 */
	@RequestMapping("/exit")
	public String exit(HttpSession session) {
		session.invalidate();

		return "redirect:/login.jsp";

	}
}
