<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%
	response.setCharacterEncoding("utf-8");	
	
	// 세션&요청값 유효성 검사
	// 로그인하지 않은 사용자는 홈으로
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	// 카테고리에서 넘어온 값 유효성 검사
	if(request.getParameter("localName")==null 
	|| request.getParameter("localName").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/category.jsp"); //다시 Form 화면 보여줌
		return;
	}
	
	// 받아온 localName String 변수에 저장
	String localName = request.getParameter("localName");
	System.out.println(localName+"<--delCategoryForm localName");

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<title>카테고리 삭제</title>
<style>
td{
width: 170px;
 text-align : center;
 vertical-align : middle;}
</style>
</head>
<body>
	<div class="container mt-3">
	<div>
		<!-- 액션태그 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<h2 style="text-align: center">카테고리 삭제</h2>
	<hr>
	<form action="<%=request.getContextPath()%>/board/deleteLocalAction.jsp" method="post">
		<div style="text-align: center;">
		<%
			if(request.getParameter("msg")!=null) {
		%>
			<%=request.getParameter("msg")%>
		<%
			}
		%>
		</div>
	<table class="table">
		<tr>
			<td style="text-align:right;">지역명</td> <!-- value값 readonly -->
			<td><input type="text" name="localName" value="<%=localName%>" readonly="readonly" style="float:left;">
		</tr>
	</table>
	<div>
		<button type="submit" class="btn btn-light">삭제</button>
		<a href="<%=request.getContextPath()%>/board/category.jsp" class="btn btn-light">취소</a>	
	</div>
	</form>
	</div>
</body>
</html>