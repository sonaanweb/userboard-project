<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 세션 유효성 검사
	// 세션에서 지정한 loginmemberid 얻어 와 검사
	if(session.getAttribute("loginMemberId") !=null) { // 로그인 성공했으면 home으로 이동
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
<style>
@font-face {
    font-family: 'omyu_pretty';
    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2304-01@1.0/omyu_pretty.woff2') format('woff2');
    font-weight: normal;
    font-style: normal;
}
body{
font-family: 'omyu_pretty';
}
a {text-decoration: none;}
#customers {
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
<title>로그인</title>
</head>
<body>
	<div class="container mt-3">
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
		<%
			if(session.getAttribute("loginMemberId") == null) { 
		%>	
	<br>
	<h2 style="text-align: center">로그인</h2> <!-- contextPath: 전체 프로젝트의 경로 -> 이름을 변경해도 동일하게 실행 : "절대주소" -->
	<div>
		<%
			if(request.getParameter("msg") != null){
		%>
			<div style="color: #22741C"><%=request.getParameter("msg")%></div>
		<%
			}
		%>
	</div>
	<form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post">
		<table id="customers">
			<tr>
				<td>아이디</td>
				<td><input type="text" name="memberId"></td>
			</tr>	
			<tr>
				<td>비밀번호</td>
				<td><input type="password" name="memberPw"></td>
			</tr>	
		</table>
	<br>
		<button type="submit" class="btn btn-success">로그인</button>
	</form>
		<%
			}
		%>
	<br>
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>