<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
			<div class="col-sm-3 col-md-2 sidebar">
				<%@include file="/WEB-INF/views/common/menu.jsp"%>
			</div>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">
							<i class="glyphicon glyphicon-th"></i> 数据列表
						</h3>
					</div>
					<div class="panel-body">
						<ul id="treeDemo" class="ztree"></ul>
					</div>
				</div>
			</div>
		</div>
	</div>



	<!-- 添加模态框 -->	
<div class="modal fade"  id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">添加菜单模块</h4>
      </div>
      <div class="modal-body">
       <form role="form" id="addForm">
				  <div class="form-group">
					<label for="exampleInputPassword1">菜单模块名称</label>
					<input type="text" class="form-control" id="exampleInputPassword1" name="title" placeholder="请输入菜单模块名称">
					<input type="hidden" name="pid" >
				  </div>
				  <div class="form-group">
					<label for="exampleInputPassword1">菜单图标</label>
					<input type="text" class="form-control" id="exampleInputPassword1" name="icon" placeholder="请输入菜单图标">
				  </div>
				</form>
      </div>
      <div class="modal-footer">
        <button id="savePermission" type="button" class="btn btn-primary">保存</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
      </div>
    </div>
  </div>
</div>

<!-- 修改模态框 -->	
<div class="modal fade"  id="updateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">修改菜单模块</h4>
      </div>
      <div class="modal-body">
       <form role="form" id="updateForm">
				  <div class="form-group">
					<label for="exampleInputPassword1">菜单模块名称</label>
					<input type="text" class="form-control" id="exampleInputPassword1" name="title" placeholder="请输入菜单模块名称">
					<input type="hidden" name="id" >
				  </div>
				   <div class="form-group">
					<label for="exampleInputPassword1">菜单图标</label>
					<input type="text" class="form-control" id="exampleInputPassword1" name="icon" placeholder="请输入菜单图标">
				  </div>
				</form>
      </div>
      <div class="modal-footer">
        <button id="updatePermission" type="button" class="btn btn-primary">修改</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
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
			initTree();
		});
		
		function initTree(){
			var setting = {
					data: {
						key: {
							name: 'title'
						},
						simpleData: {
							//开启简单函数
							enable: true,
							pIdKey: 'pid'
						}
					},
					view: {
						addDiyDom: function(treeId,treeNode){ //treeNode =>> {"id":1,"pid":0,"name":"控制面板","icon":"glyphicon glyphicon-dashboard","url":"main.html","children":[]}
							//设置节点前的图标
							//先将旧的图标移除
							$("#"+treeNode.tId+"_ico").removeClass();//.addClass();
							//设置新的图标
							$("#"+treeNode.tId+"_span").before("<span class='"+treeNode.icon+"'></span>")
						},
						//设置节点链接，在点击后不会转发
						addHoverDom: function(treeId, treeNode){  
							//获取节点
							var aObj = $("#" + treeNode.tId + "_a"); // tId = permissionTree_1, ==> $("#permissionTree_1_a")
							//aObj.attr("href", "javascript:;"); //表示禁用href，但是，没好使
							//设置禁用href
							aObj.attr("onclick","return false;");
							//将href的链接清空
							aObj.attr("href", "#");
						//用连接字符串的方法，设置增删改  根节点：增  分支节点没有子节点：增删改  分支节点有子节点：增改  叶子节点：增删改
						if (treeNode.editNameFlag || $("#btnGroup"+treeNode.tId).length>0) return;
						var s = '<span id="btnGroup'+treeNode.tId+'">';
							if ( treeNode.level == 0 ) { //根节点
							s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="add('+treeNode.id+')" title="添加权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
							} else if ( treeNode.level == 1 ) { //分支节点
							s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  onclick="update('+treeNode.id+')"  title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
							if (treeNode.children == null) { //分支节点没有孩子节点，可以删除的。
							s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="del('+treeNode.id+')" title="删除权限信息" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
							}
							s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="add('+treeNode.id+')" title="添加权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
							} else if ( treeNode.level == 2 ) { //叶子节点
							s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  onclick="update('+treeNode.id+')"  title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
							s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="del('+treeNode.id+')" title="添加权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
							}  			
							s += '</span>';
							//将拼接好的字符串放到节点后
							aObj.after(s);
						},
						removeHoverDom: function(treeId, treeNode){
					    	$("#btnGroup"+treeNode.tId).remove();
						}
					}
			};
				$.get("${PATH}/permission/listALLPermission",{},function(result){
					//增加一个根节点
					result.push(  {"id":0,"title":"系统权限树","icon":"glyphicon glyphicon-dashboard"}  );
					var treeObj = $.fn.zTree.init($("#treeDemo"), setting, result);
					treeObj.expandAll(true);//展开整棵树
					
				});
		}
		
		//添加
		function add(id){
			$("#addModal").modal({
				show:true,
				backdrop:'static'
			});
			$("#addModal input[name='pid']").val(id);
		}
		
		$("#savePermission").click(function(){
			var title = $("#addModal input[name='title']").val();
			var icon = $("#addModal input[name='icon']").val();
			var pid = $("#addModal input[name='pid']").val();
			$.post("${PATH}/permisssion/savePermisssion",{title:title,icon:icon,pid:pid},function(result){
				if(result == "ok"){
					initTree();
					layer.msg("添加成功",{time: 1000, icon:6},function(){
					$("#addModal").modal('hide');
					$("#addModal input[name='title']").val("");
					$("#addModal input[name='icon']").val("");
				});
				}else{
					layer.msg("添加失败",{time: 10*1000, icon:5, shift:6});
				}
			});
		});
		//修改
		function update(id){
			//回显
			$.get("${PATH}/permission/getPermission",{id:id},function(result){
				$("#updateModal input[name='title']").val(result.title);
				$("#updateModal input[name='icon']").val(result.icon);
			});
			$("#updateModal").modal({
				show:true,
				backdrop:'static'
			});
			$("#updateModal input[name='id']").val(id);
			
		}
		
		$("#updatePermission").click(function(){
			
			var title = $("#updateModal input[name='title']").val();
			var id = $("#updateModal input[name='id']").val();
			var icon = $("#updateModal input[name='icon']").val();
			$.post("${PATH}/permission/updatePermission",{title:title,id:id,icon:icon},function(result){
				if(result == "ok"){
					initTree();
					layer.msg("修改成功",{time: 1000, icon:6},function(){
					$("#updateModal").modal('hide');
					$("#updateModal input[name='title']").val("");
					$("#updateModal input[name='icon']").val("");
				});
				}else{
					layer.msg("修改失败",{time: 10*1000, icon:5, shift:6});
				}
			});
		});
	//删除
		function del(id){
			layer.confirm("您确定要删除这个模块吗？",{btn:["确定","取消"]},function(index){
				$.post("${PATH}/permission/delPermission",{id:id},function(result){
					if(result == "ok"){
						initTree();
						layer.msg("删除成功",{time: 1000,icon:6},function(){
							
						});
					}else{
						layer.msg("删除成功",{time: 2000,icon:5,shift:6});
					}
				});
				layer.close(index);
			},function(){
				layer.close(index);
			});
		}	
		
		
		
		
	</script>



</body>
</html>
