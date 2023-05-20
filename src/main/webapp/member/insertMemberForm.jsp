<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder"%>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") !=null) {
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
<title>회원가입</title>
<style>
a {text-decoration: none;}
#customers {
  font-family: Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

#customers td, #customers th {
  border: 1px solid #ddd;
  padding: 8px;
}

#customers tr:nth-child(even){background-color: #f2f2f2;}

#customers tr:hover {background-color: #ddd;}

</style>
</head>
<body>
<div class="container mt-3">
	<!--- 메인메뉴(가로) ---------------------------------------------------------------------------->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<h2 style="text-align: center">회원가입</h2>
	<!-- 회원가입 폼 내에서 출력할 메세지 칸 -->
	<div>
		<%
			if(request.getParameter("msg")!=null) {
		%>
			<div style="color: #22741C"><%=request.getParameter("msg")%></div>
		<%
			}
		%>
	</div>
	<!--- 회원정보 폼 ------------------------------------------------------------------------------>
	<form action="<%=request.getContextPath()%>/member/insertMemberAction.jsp" method="post">
		<table id="customers">
			<tr>
				<td>아이디</td>
				<td>
				<input type="text" name="memberId">
				</td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td>
				<input type="password" name="memberPw">
				</td>
			</tr>
		</table>
		<br>
		<button type="submit" class="btn btn-success">회원가입</button>
	</form>
	<br>
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
	<br>
</div>
</body>
</html>