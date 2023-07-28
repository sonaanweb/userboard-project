<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
li {list-style: none;}
.header a{
 display:block;
 width:100%;
 height:100%;
  background-color: #FCFCFC;
  padding: 50px;
  text-align: center;
}
.header a:hover{color: black;}
a {text-decoration: none; color:black; }
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</style>
<div class="header">
  <a href="<%=request.getContextPath()%>/home.jsp" style="font-size: 40px;">Travel go '◡'💚🏝️</a>
</div>
<nav class="navbar navbar-expand-sm bg-success navbar-dark">
<div class="container-fluid">
	<ul class="navbar-nav">
		<li class="nav-item"><a class="nav-link active" href="<%=request.getContextPath()%>/home.jsp">홈으로</a></li>
	
		<!--
			 로그인 전 : 로그인 / 회원가입
			 로그인 후 : 회원정보 / 로그아웃
		-->
		
		<%
			if(session.getAttribute("loginMemberId") == null) { // 로그인 전 세션값 확인
		%>	
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/member/loginForm.jsp">로그인</a><li>
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/member/insertMemberForm.jsp">회원가입</a><li>
		<% 	
			}else{ // 로그인 후
		%>	
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/board/edit.jsp">관리</a></li>
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/member/userinfomation.jsp">회원정보</a></li>
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a></li>
		<% 		
			}
		%>
	</ul>
</div>
</nav>