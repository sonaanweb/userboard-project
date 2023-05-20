<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 로컬네임 인코딩 오류 발생으로 수정 멈춤 
	
	response.setCharacterEncoding("UTF-8");

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
<title>게시글 추가</title>
<style>
td{
 vertical-align : middle;}
td{
	width: 170px;}
#sub{
text-align: center;
background-color: #F6F6F6;}
</style>
</head>
<body>
	<!-- 메인메뉴 -->
	<div class="container mt-3">
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<h2 style="text-align: center">게시글 추가</h2>
	<hr>
	<!-- 메세지 출력 -->
	<div style="text-align: center;">
	<%
		if(request.getParameter("msg") != null){
	%>
			<%=request.getParameter("msg")%>
	<%
		}
	%>
	</div>
	<!-------------->
	<form action="<%=request.getContextPath()%>/board/insertBoardAction.jsp" method="post">
	<table class="table">
		<tr>
			<td id="sub">카테고리</td>
			<td>
			<input type="text" name="localName">
			</td>
		</tr>
		<tr>
			<td id="sub">제목</td>
			<td>
			<input type="text" name="boardTitle">
			</td>
		</tr>
		<tr>
			<td id="sub">내용</td>
			<td>
			<textarea rows="5" cols="80" name="boardContent">
			</textarea>
			</td>
		</tr>
		<tr>
	</table>
	<div>
		<button type=submit class="btn btn-light">추가</button>
		<a href="<%=request.getContextPath()%>/home.jsp" class="btn btn-light">취소</a>
	</div>
	<br>
	</form>
	</div>
</body>
</html>