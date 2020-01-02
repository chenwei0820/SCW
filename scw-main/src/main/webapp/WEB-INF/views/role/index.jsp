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
						<button id="addRole" type="button" class="btn btn-primary"
							style="float: right;">
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
										<th>角色名称</th>
										<th width="100">操作</th>
									</tr>
								</thead>
								<tbody>
									
								</tbody>
								<tfoot>
									<tr>
										<td colspan="6" align="center">
											<ul class="pagination">
												
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
	
<!-- 添加模态框 -->	
<div class="modal fade"  id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">添加角色</h4>
      </div>
      <div class="modal-body">
       <form role="form" action="${PATH }/admin/doAdd" id="addForm">
				  <div class="form-group">
					<label for="exampleInputPassword1">角色名称</label>
					<input type="text" class="form-control" id="exampleInputPassword1" name="name" placeholder="请输入角色名称">
				  </div>
				</form>
      </div>
      <div class="modal-footer">
        <button id="saveRole" type="button" class="btn btn-primary">保存</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
      </div>
    </div>
  </div>
</div>
	
<!-- 更新模态框 -->	
<div class="modal fade"  id="updateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">修改角色</h4>
      </div>
      <div class="modal-body">
       <form role="form" id="updateForm">
       		
				  <div class="form-group">
					<label for="exampleInputPassword1">角色名称</label>
					<input type="hidden" name="id">
					<input type="text" class="form-control" id="exampleInputPassword1" name="name" placeholder="请输入角色名称">
				  </div>
				</form>
      </div>
      <div class="modal-footer">
        <button id="updateBut" type="button" class="btn btn-primary">修改</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
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
	    initData(1);
    });
	 //装需要提交的参数
	 var jsonObj = {
		pageNum:1,
		pageSize:2,
		keyWord:'',
		pageLastNum:1
	 }
	function initData(pageNum){
		 var index = -1;
		 jsonObj.pageNum = pageNum;
		 $.ajax({
			 url:"${PATH}/role/roleList",
			 type:"post",
			 data:jsonObj,
			 beforeSend:function(){
				 index = layer.load(2,{time: 10*1000});
			 	 return true;
			 },
			 //result是controller层返回来的结果集
			 success:function(result){
				 jsonObj.pageLastNum = result.pages;
				 //显示返回的数据
				 console.log(result);
				 //关闭提示弹窗
				 layer.close(index);
				 //刷新表格数据
				 showData(result.list);
				 //刷新分页数据
				 showPageNav(result);
			 }
		 
		 })
	 }
	 //刷新表格数据
	 function showData(list){
		 var content = '';
		 $.each(list,function(i,e){
			content+='<tr>'
			content+='<td>'+(i+1)+'</td>'
			content+='<td><input type="checkbox" roleId='+e.id+'></td>'
			content+='<td>'+e.name+'</td>'
			content+='<td>'
			content+=' <button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>'
			content+=' <button type="button" roleId="'+e.id+'" class="updateRoleClass btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>'
			content+=' <button type="button" roleId="'+e.id+'" class="deleteRoleClass btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>'
			content+='</td>'
			content+='</tr>'
		 });
		 $("tbody").html(content);
	 }
	//刷新分页数据
	function showPageNav(result){
		var nav = '';
			if(result.isFirstPage){
				nav += '<li class="disabled"><a href="#">上一页</a></li>';
			}else{
				nav += '<li><a onclick="initData('+(result.pageNum - 1)+')">上一页</a></li>';
			}
			
			$.each(result.navigatepageNums,function(i,num){
				if(result.pageNum == num){
					nav += '<li class="active"><a onclick="initData('+num+')">'+num+'</a></li>';
				}else{
					nav += '<li><a onclick="initData('+num+')">'+num+'</a></li>';
				}
				
			});
			
			
				if(result.isLastPage){
					nav += '<li class="disabled"><a href="#">下一页</a></li>';
				}else{
					nav += '<li><a onclick="initData('+(result.pageNum + 1)+')">下一页</a></li>';
				}
			 $(".pagination").html(nav);
	}
	//查询
	$("#queryBut").click(function(){
		var keyWord = $("#queryForm input[name='keyWord']").val();
		jsonObj.keyWord = keyWord;
		initData(1);
	});
	
	//***************************************************************
	//新增 1.弹出模态框
	$("#addRole").click(function(){
		$("#addModal").modal({
			show:true,
			backdrop:'static'
		});
	});
	//2. 添加
	$("#saveRole").click(function(){
		var name = $("#addModal input[name='name']").val();
		$.post("${PATH}/role/saveRole",{name:name},function(result){//添加成功返货ok
			if(result=="ok"){
				layer.msg("添加成功",{time: 1000,icon:6},function(){
					$("#addModal input[name='name']").val("");
					$("#addModal").modal('hide');//关闭模态框
					initData(jsonObj.pageLastNum + 1);
				});
			}else{
				layer.msg("添加失败",{time: 10*1000,icon:5,shift:6},function(){
					$("#addModal").modal('hide');//关闭模态框
					})
			}
		});
	});
	//***************************************************
	//修改 1.信息回显
	$("tbody").on("click",".updateRoleClass", function(){
		var id = $(this).attr("roleId");
		$.get("${PATH}/role/getRole",{id:id},function(result){
			$("#updateModal input[name='id']").val(result.id);
			$("#updateModal input[name='name']").val(result.name);
			//弹出模态框
			$("#updateModal").modal({
				show:true,
				backdrop:'static'
			});
		});
	
	});
	//修改 2. 提交修改后的信息
	$("#updateBut").click(function(){
		var id = $("#updateModal input[name='id']").val();
		var name = $("#updateModal input[name='name']").val();
		$.post("${PATH}/role/updateRole",{id:id,name:name},function(result){//修改成功返回ok
			if(result == "ok"){
				layer.msg("修改成功",{time: 1000,icon:6},function(){
					$("#updateModal input[name='name']").val("");
					$("#updateModal").modal('hide');//关闭模态框
					initData(jsonObj.pageNum);
				});
			}else{
				layer.msg("修改失败",{time: 10*1000,icon:5,shift:6},function(){
					$("#updateModal input[name='name']").val("");
					$("#updateModal").modal('hide');//关闭模态框
				});
			}
		});
	});
	//******************************************
	//单个删除 
	$("tbody").on("click",".deleteRoleClass", function(){
		//获取id
		var id = $(this).attr("roleId");
		//弹框确认是否删除
		layer.confirm("您确定要删除这条数据吗？",{btn:["确定","取消"]},function(index){
			$.post("${PATH}/role/deleteRole",{id:id},function(result){
				if(result == "ok"){
					layer.msg("删除成功",{time: 1000,icon:6},function(){
						initData(jsonObj.pageNum);
					});
				}else{
					layer.msg("删除失败",{time: 1000,icon:5,shift:6});
				}
			});
			layer.close(index);
		},function(index){
			layer.close(index);
		});
	});
	//*********************************************************
	//批量删除
	//全选 总控制分
	$("#thCheckbox").click(function(){
		var thChecked = this.checked;
		var listCheckbox = $("tbody input[type='checkbox']");
		$.each(listCheckbox,function(i,e){
			e.checked = thChecked;
		});
	});
	//全选 分控制总
// 	$("tbody input[type='checkbox']").click(function(){
	$("tbody").on("click",":checkbox", function(){
		var checkboxLen = $("tbody input[type='checkbox']").length;
		var checkedLen = $("tbody input[type='checkbox']:checked").length;
		if(checkboxLen == checkedLen){
			$("#thCheckbox").prop("checked",true);
		}else{
			$("#thCheckbox").prop("checked",false);
		}
	});
	//删除
	$("#delButton").click(function(){
		var checkedList = $("tbody input[type='checkbox']:checked");
		if(checkedList.length == 0){
			layer.msg("请先选中要删除的职位，再进行删除操作",{time: 3000,icon:1,shift:6});
			return false;
		}
		var str = "";
		var array = new Array();
		$.each(checkedList,function(i,e){
			var roleId = $(e).attr("roleId");
			array.push(roleId);
		});
		//拼接id参数的字符串
		str = array.join(",");
		
		layer.confirm("您确定要删除这些职位吗？",{btn:["确定","取消"]},function(index){
			$.post("${PATH}/role/deleteRoles",{str:str},function(result){
				if(result == "ok"){
					layer.msg("删除成功",{time: 1000,icon:6},function(){
						initData(jsonObj.pageNum);
					});
				}else{
					layer.msg("删除失败",{time: 3000,icon:5,shift:6});
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
