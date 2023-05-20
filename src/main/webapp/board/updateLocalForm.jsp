<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	response.setCharacterEncoding("utf-8");	

	// 세션&요청값 유효성 검사
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
	System.out.println(localName+"<--updateCategoryForm localName");

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
a {text-decoration: none;}
th,td{
width: 250px;
 text-align : center;
 vertical-align : middle;}
</style>
<title>카테고리 수정</title>
</head>
<body>
	<div class="container mt-3">
	<div>
		<!-- 액션태그 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<h2 style="text-align: center">카테고리 수정</h2>
	<hr>
		<div style="text-align: center;">
		<%
			if(request.getParameter("msg")!=null) {
		%>
			<%=request.getParameter("msg")%>
		<%
			}
		%>
		</div>
	<form action="<%=request.getContextPath()%>/board/updateLocalAction.jsp" method="post">
	<table class="table">
		<tr>
			<th style="text-align: right;">현재 지역명</th>
			<td style="text-align: left;">
			<%=localName%>
			<input type="hidden" name="localName" value="<%=localName%>">
			</td>
		</tr>
		<tr>
			<th style="text-align: right;">변경</th>
			<td style="text-align: left;">
			<input type="text" name="newLocalName">
			</td>
		</tr>
	</table>
	<div>
		<button type="submit" class="btn btn-light">변경</button>
		<a href="<%=request.getContextPath()%>/board/category.jsp" class="btn btn-light">취소</a>	
	</div>
	</form>
	</div>
</body>
</html>