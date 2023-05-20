<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
	   response.sendRedirect(request.getContextPath()+"/member/memberInfo.jsp");
	   return;
	} 
	
	// 로그인 시 아이디 받아온 값을 memberId에 넣음
	String loginmemberId = (String)session.getAttribute("loginMemberId");
	System.out.println( loginmemberId + "<---deletemember id");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<title>회원탈퇴</title>
</head>
<body>
	<!--- 메인메뉴(가로) ---------------------------------------------------------------------------->
	<div  class="container mt-3">
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<h2 style="text-align: center">회원탈퇴</h2>
	<hr>
	<!-- 회원탈퇴 폼 내에서 출력할 메세지 칸 -->
	<div>
	<%
		if(request.getParameter("msg") != null){
	%>
		<div style="color: #22741C" align="center"><%=request.getParameter("msg")%></div>
	<%
		}
	%>
	</div>
	<!--- 회원정보 폼 ------------------------------------------------------------------------------>
	<form action="<%=request.getContextPath()%>/member/deleteMemberAction.jsp" method="post">
	<div class="alert alert-secondary">
	<strong>회원탈퇴 시 계정 복구가 불가능합니다. 탈퇴를 원하시면 비밀번호를 입력해주세요.</strong>
	</div>
	<table class="table">
		<tr>
			<td>아이디</td>
			<td><%=loginmemberId%></td>
		</tr>
		<tr>
			<td>비밀번호</td>
			<td>
			<input type="password" name="memberPw">
			</td>
		</tr>
	</table>
		<a href="<%=request.getContextPath()%>/member/userinfomation.jsp" class="btn btn-light" style="float: left;">취소</a>	
		<button type="submit" class="btn btn-dark" style="float: right">탈퇴하기</button>
	</form>
	</div>
</body>
</html>