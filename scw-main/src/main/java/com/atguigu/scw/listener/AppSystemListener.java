package com.atguigu.scw.listener;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.atguigu.scw.util.Const;

public class AppSystemListener implements ServletContextListener {

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		//服务器启动时，将系统上下文路径存放到application域中，给jsp页面使用${appPath}
		ServletContext application = sce.getServletContext();
		String contextPath = application.getContextPath();
		application.setAttribute(Const.PATH, contextPath);
		System.out.println("contextPath="+contextPath);
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		

	}

}
