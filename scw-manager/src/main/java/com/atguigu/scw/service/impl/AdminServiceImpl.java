package com.atguigu.scw.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.scw.bean.TAdmin;
import com.atguigu.scw.bean.TAdminExample;
import com.atguigu.scw.bean.TAdminExample.Criteria;
import com.atguigu.scw.dao.TAdminMapper;
import com.atguigu.scw.service.AdminService;
import com.atguigu.scw.util.Const;
import com.atguigu.scw.util.DateUtil;
import com.atguigu.scw.util.MD5Util;
import com.atguigu.scw.util.StringUtil;
import com.github.pagehelper.PageInfo;

@Service
public class AdminServiceImpl implements AdminService {

	@Autowired
	TAdminMapper adminMapper;

	@Override
	public TAdmin selectByLogin(String loginacct, String userpswd) {

		TAdminExample example = new TAdminExample();
		Criteria criteria = example.createCriteria();
		criteria.andLoginacctEqualTo(loginacct);
		// 根据用户账号查看数据库中，该账户是否存在
		List<TAdmin> list = adminMapper.selectByExample(example);
		if (list == null || list.size() == 0) {
			throw new RuntimeException(Const.LOGIN_LOGINACCT_ERROR);
		}
		// 获得账户信息
		TAdmin admin = list.get(0);
		// 比较密码是否正确，用的是MD5加密后的密码
		if (admin.getUserpswd().equals(MD5Util.digest(userpswd))) {
			admin.setUserpswd(null);
			return admin;
		} else {
			throw new RuntimeException(Const.LOGIN_USERPSWD_ERROR);
		}

	}

	@Override
	public PageInfo<TAdmin> listAdminPage(Map<String, Object> paramMap) {
		TAdminExample example = new TAdminExample();
		String keyWord = (String) paramMap.get("keyWord");
		if(StringUtil.isNotEmpty(keyWord)) {
			example.createCriteria().andLoginacctLike("%" + keyWord + "%");
			Criteria criteria2 = example.createCriteria();
			criteria2.andUsernameLike("%" + keyWord + "%");
			Criteria criteria3 = example.createCriteria();
			criteria3.andEmailLike("%" + keyWord + "%");
			example.or(criteria2);
			example.or(criteria3);
		}
		
		
		List<TAdmin> list = adminMapper.selectByExample(example);
		PageInfo<TAdmin> page = new PageInfo<TAdmin>(list, 5);
		return page;
	}
	/**
	 * 添加数据到数据库
	 */
	@Override
	public void saveAdmin(TAdmin admin) {
		//设置初始密码
		admin.setUserpswd(MD5Util.digest(Const.DEFALUT_PASSWORD));
		//设置注册时间
		admin.setCreatetime(DateUtil.getFormatTime());
		adminMapper.insertSelective(admin);
	}

	@Override
	public TAdmin getAdminById(Integer id) {
		TAdmin admin = adminMapper.selectByPrimaryKey(id);
		return admin;
	}

	@Override
	public void updateAdmin(TAdmin admin) {
		TAdmin admin2 = adminMapper.selectByPrimaryKey(admin.getId());
	
		String loginacct = admin2.getLoginacct();
		admin.setLoginacct(loginacct);
		//密码加密
		admin.setUserpswd(MD5Util.digest(admin.getUserpswd()));
		adminMapper.updateByPrimaryKey(admin);
	}

	@Override
	public void deleteAdminById(Integer id) {
		adminMapper.deleteByPrimaryKey(id);
		
	}

	@Override
	public void deleteBatch(String ids) {
		// TODO Auto-generated method stub
		String[] strings = ids.split(",");
		List<Integer> idList = new ArrayList<Integer>();
		for (String s : strings) {
			try {
				idList.add(Integer.parseInt(s));
			} catch (NumberFormatException e) {
				
			}
		}
		adminMapper.deleteBatch(idList);
	}
}
