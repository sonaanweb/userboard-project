<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 관리창도 로그인 사용자에게만 보이게 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<title>EDIT</title>
</head>
<body>
	<div class="container mt-3">
	<!--- 메인메뉴(가로) ---------------------------------------------------------------------------->
		<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
	<!--- 카테고리 관리 버튼 ------------------------------------------------------------------------->
		<br>
		<div>
		<h2 style="text-align: center">관리</h2>
		<hr>
		<table class="table">
			<tr>
				<td>
				<a style="float:inherit;" href="<%=request.getContextPath()%>/board/category.jsp" class="btn btn-warning">카테고리</a>
				</td>
			</tr>
		</table>
		</div>
	<!-- include 페이지 :  Copyright &copy; 구디아카데미  -->
		<% //자바태그
		//request.getRequestDispatcher(request.getContextPath()+"/inc/copyright.jsp").include(request, response);
		//위 코드를 아래 코드로 변경하면 아래와 같다.	
		//+)절대주소 상대주소
		%>
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>