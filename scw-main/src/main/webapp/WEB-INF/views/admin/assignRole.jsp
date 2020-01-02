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
				<ol class="breadcrumb">
					<li><a href="#">首页</a></li>
					<li><a href="#">数据列表</a></li>
					<li class="active">分配角色</li>
				</ol>
				<div class="panel panel-default">
					<div class="panel-body">
						<form role="form" class="form-inline">
							<div class="form-group">
								<label for="exampleInputPassword1">未分配角色列表</label><br> 
								<select
									id="roleNotSelected" class="form-control" multiple size="15"
									style="width: 180px; overflow-y: auto;">
									<!--                         <option value="pm">PM</option> -->
									<!--                         <option value="sa">SA</option> -->
									<!--                         <option value="se">SE</option> -->
									<!--                         <option value="tl">TL</option> -->
									<!--                         <option value="gl">GL</option> -->
								</select>
							</div>
							<div class="form-group">
								<ul>
									<li class="btn btn-default glyphicon glyphicon-chevron-right" id="addSave"></li>
									<br>
									<li class="btn btn-default glyphicon glyphicon-chevron-left " id="delSave"
										style="margin-top: 20px;"></li>
								</ul>
							</div>
							<div class="form-group" style="margin-left: 40px;">
								<label for="exampleInputPassword1">已分配角色列表</label><br> <select
									id="roleSelected" class="form-control" multiple size="15"
									style="width: 180px; overflow-y: auto;">
<!-- 									<option value="qa">QA</option> -->
<!-- 									<option value="qc">QC</option> -->
<!-- 									<option value="pg">PG</option> -->
								</select>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">帮助</h4>
				</div>
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/common/js.jsp"%>
	<script type="text/javascript">
		$(function() {
			$(".list-group-item").click(function() {
				if ($(this).find("ul")) {
					$(this).toggleClass("tree-closed");
					if ($(this).hasClass("tree-closed")) {
						$("ul", this).hide("fast");
					} else {
						$("ul", this).show("fast");
					}
				}

			});
			initAssignRole("${param.adminid}");
		});
		function initAssignRole(adminid) {
			//获取未选中的角色
			$.get("${PATH}/admin/getNotSelected", {
				adminid : adminid
			}, function(result) {
				if(result != null){
					var notSelectedRole = "";
					$.each(result, function(i, e) {
						notSelectedRole += '<option  value='+e.id+'>' + e.name
								+ '</option>';
					});
					$("#roleNotSelected").html(notSelectedRole);
				}
			});
			//获取已经选中的角色
			$.get("${PATH}/admin/getSelected", {adminid : adminid}, function(result) {
				if(result != null){
					var selectedRole = "";
					$.each(result, function(i, e) {
						selectedRole += '<option value='+e.id+'>' + e.name+ '</option>';
					});
					$("#roleSelected").html(selectedRole);
				}
			});
		}
		//添加
		$("#addSave").click(function(){
			var list = $("#roleNotSelected option:selected");
			if(list.length == 0){
				layer.msg("添加失败，未选择可以添加的角色权限，请选择后添加",{time: 3000,icon:5,shift:6});
				return false;
			}
			var str = "";
			var array = new Array();
			$.each(list,function(i,e){
				array.push($(e).attr("value"));
			});
			str = array.join(",");
			var adminid = ${param.adminid};
			layer.confirm("您确定添加这些角色权限到该用户吗？",{btn: ['确定','取消']},function(index){
				$.post("${PATH}/admin/addRoleToAdmin",{str:str,adminid:adminid},function(result){
					if(result == "ok"){
						initAssignRole(adminid);
						layer.msg("添加成功",{time: 1000,icon:6});
					}else{
						layer.msg("添加失败",{time: 3000,icon:5,shift:6});
					}
				});
				layer.close(index);
			},function(index){
				layer.close(index);
			});
			
		});
		//移除
		$("#delSave").click(function(){
			var list = $("#roleSelected option:selected");
			if(list.length == 0){
				layer.msg("移除失败，未选择可以移除的角色权限，请选择后移除",{time: 3000,icon:5,shift:6});
				return false;
			}
			var str = "";
			var array = new Array();
			$.each(list,function(i,e){
				array.push($(e).attr("value"));
			});
			str = array.join(",");
			var adminid = ${param.adminid};
			layer.confirm("您确定移除该用户的这些角色权限吗？",{btn: ['确定','取消']},function(index){
				$.post("${PATH}/admin/delRoleToAdmin",{str:str,adminid:adminid},function(result){
					if(result == "ok"){
						initAssignRole(adminid);
						layer.msg("移除成功",{time: 1000,icon:6});
					}else{
						layer.msg("移除失败",{time: 3000,icon:5,shift:6});
					}
				});
				layer.close(index);
			},function(index){
				layer.close(index);
			});
		});
	</script>
</body>
</html>
