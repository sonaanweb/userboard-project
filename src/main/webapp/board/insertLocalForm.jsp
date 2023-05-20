<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

	request.setCharacterEncoding("UTF-8");

	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
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
<title>카테고리 추가</title>
<style>
td{
 text-align : center;
 vertical-align : middle;}
td{
	width: 170px;}
</style>
</head>
<body>
	<div class="container mt-3">
	<!--- 메인메뉴(가로) ---------------------------------------------------------------------------->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<h2 style="text-align: center">카테고리 추가</h2>
	<hr>
	<!-- 카테고리 추가 폼 내 메세지 출력 -->
		<div style="text-align: center;">
		<%
			if(request.getParameter("msg")!=null) {
		%>
			<%=request.getParameter("msg")%>
		<%
			}
		%>
		</div>
	<form action="<%=request.getContextPath()%>/board/insertLocalAction.jsp" method="post">
	<table class="table">
		<tr>
			<td style="text-align:right;">지역명</td>
			<td style="text-align:left;"><input type="text" name="localName"></td>
		</tr>
	</table>
	<div>
		<button type="submit" class="btn btn-light">추가</button>
		<a href="<%=request.getContextPath()%>/board/category.jsp" class="btn btn-light">취소</a>	
	</div>
	</form>
	</div>
</body>
</html>