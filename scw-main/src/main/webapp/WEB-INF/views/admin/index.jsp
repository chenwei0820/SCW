<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<%@ include file="/WEB-INF/views/common/css.jsp"%>
<style>
.tree li {
	list-style-type: none;
	cursor: pointer;
}

table tbody tr:nth-child(odd) {
	background: #F4F4F4;
}

table tbody td:nth-child(even) {
	color: #C00;
}
</style>
</head>

<body>

	<jsp:include page="/WEB-INF/views/common/admin.jsp"></jsp:include>

	<div class="container-fluid">
		<div class="row">
			<jsp:include page="/WEB-INF/views/common/menu.jsp"></jsp:include>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">
							<i class="glyphicon glyphicon-th"></i> 数据列表
						</h3>
					</div>
					<div class="panel-body">
						<form id="queryForm" class="form-inline" role="form"
							style="float: left;" action="${PATH }/admin/index" method="post">
							<div class="form-group has-feedback">
								<div class="input-group">
									<div class="input-group-addon">查询条件</div>
									<input class="form-control has-success" type="text"
										name="keyWord" value="${param.keyWord }" placeholder="请输入查询条件">
								</div>
							</div>
							<button type="button" class="btn btn-warning" id="queryBut">
								<i class="glyphicon glyphicon-search"></i> 查询
							</button>
						</form>
						<button id="delButton" type="button" class="btn btn-danger"
							style="float: right; margin-left: 10px;">
							<i class=" glyphicon glyphicon-remove"></i> 删除
						</button>
						<button type="button" class="btn btn-primary"
							style="float: right;"
							onclick="window.location.href='${PATH}/admin/toAdd'">
							<i class="glyphicon glyphicon-plus"></i> 新增
						</button>
						<br>
						<hr style="clear: both;">
						<div class="table-responsive">
							<table class="table  table-bordered">
								<thead>
									<tr>
										<th width="30">#</th>
										<th width="30"><input id="thCheckbox" type="checkbox"></th>
										<th>账号</th>
										<th>名称</th>
										<th>邮箱地址</th>
										<th width="100">操作</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${page.list }" var="admin" varStatus="status">
										<tr>
											<td>${status.count}</td>
											<td><input type="checkbox" adminId = ${admin.id}></td>
											<td>${admin.loginacct}</td>
											<td>${admin.username}</td>
											<td>${admin.email}</td>
											<td>
												<button type="button" class="btn btn-success btn-xs" 
													onclick="window.location.href='${PATH}/admin/toAssignRole?adminid=${admin.id }'">
													<i class=" glyphicon glyphicon-check"></i>
												</button>
												<button type="button" class="btn btn-primary btn-xs"
													onclick="window.location.href='${PATH}/admin/toUpdate?pageNum=${page.pageNum}&id=${admin.id }'">
													<i class=" glyphicon glyphicon-pencil"></i>
												</button>
												<button type="button" class="btn btn-danger btn-xs" onclick="deleteAdmin(${admin.id},'${admin.loginacct }')">
													<i class=" glyphicon glyphicon-remove"></i>
												</button>
											</td>
										</tr>
									</c:forEach>
								</tbody>
								<tfoot>
									<tr>
										<td colspan="6" align="center">
											<ul class="pagination">
												<c:if test="${page.isFirstPage}">
													<li class="disabled"><a href="#">上一页</a></li>
												</c:if>
												<c:if test="${!page.isFirstPage}">
													<li><a
														href="${PATH}/admin/index?pageNum=${page.pageNum-1}&keyWord=${param.keyWord}">上一页</a></li>
												</c:if>
												<c:forEach items="${page.navigatepageNums }" var="num">
													<c:if test="${num == page.pageNum}">
														<li class="active"><a
															href="${PATH}/admin/index?pageNum=${num}&keyWord=${param.keyWord}">${num}</a></li>
													</c:if>
													<c:if test="${num != page.pageNum}">
														<li><a
															href="${PATH}/admin/index?pageNum=${num}&keyWord=${param.keyWord}">${num}</a></li>
													</c:if>
												</c:forEach>
												<c:if test="${page.isLastPage}">
													<li class="disabled"><a href="#">下一页</a></li>
												</c:if>
												<c:if test="${!page.isLastPage}">
													<li><a
														href="${PATH}/admin/index?pageNum=${page.pageNum+1}&keyWord=${param.keyWord}">下一页</a></li>
												</c:if>
											</ul>
										</td>
									</tr>

								</tfoot>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/common/js.jsp"%>
	<script type="text/javascript">
            $(function () {
			    $(".list-group-item").click(function(){
				    if ( $(this).find("ul") ) {
						$(this).toggleClass("tree-closed");
						if ( $(this).hasClass("tree-closed") ) {
							$("ul", this).hide("fast");
						} else {
							$("ul", this).show("fast");
						}
					}
				});
			    
			   
            });
            $("#queryBut").click(function(){
            	$("#queryForm").submit();
            });
//             layer.confirm('您是如何看待前端开发？', {
//             	  btn: ['重要','奇葩'] //按钮
//             	}, function(){
//             	  layer.msg('的确很重要', {icon: 1});
//             	}, function(){
//             	  layer.msg('也可以这样', {
//             	    time: 20000, //20s后自动关闭
//             	    btn: ['明白了', '知道了']
//             	  });
//             	});
            function deleteAdmin(id,loginacct){
            	layer.confirm("您确定要删除【"+loginacct+"】用户吗？",{btn:['确定','取消']},function(index){
            	layer.msg('删除成功',{time:1000,icon:6},function(){
            		window.location.href="${PATH}/admin/delete?pageNum=${page.pageNum}&id="+id;	
            	});
            	layer.close(index);
            	},function(){
            		layer.close(index);
            	});
            }
            //批量删除
          <!-- 总控制分 -->
			$("#thCheckbox").click(function(){
        	var thChecked = this.checked;
        	var checkList = $("tbody input[type='checkbox']");
        	$.each(checkList,function(i,e){
        		e.checked = thChecked;
        	});
          });
		//分控制总
          $("tbody input[type='checkbox']").click(function(){
      		var checkboxLen = $("tbody input[type='checkbox']").length;
      		var checkedLen = $("tbody input[type='checkbox']:checked").length;
      		if(checkboxLen == checkedLen){
      			$("#thCheckbox").prop("checked",true);
      		}else{
      			$("#thCheckbox").prop("checked",false);
      		}
      	});
          $("#delButton").click(function(){
        	  //获取已经被选中的选项
        	  var checkList = $("tbody input[type='checkbox']:checked");
        	  if(checkList.length == 0){
        		  layer.msg('请先选中，再进行删除操作',{time:1000,icon:1});
        		  return false;
        	  }
        	  var str = "";
        	  var array = new Array();
        	  $.each(checkList,function(i,e){
        		 var adminId = $(e).attr("adminId");
        		 array.push(adminId);
        	  });
        	  str = array.join(",");
        	  layer.confirm("您确定要删除这些用户吗？",{btn:['确定','取消']},function(index){
              	layer.msg('删除成功',{time:1000,icon:6},function(){
              		window.location.href="${PATH}/admin/deleteBatch?pageNum=${page.pageNum}&ids="+str;	
              	});
              	layer.close(index);
              	},function(){
              		layer.close(index);
              	});
          });
            
        </script>
</body>
</html>
