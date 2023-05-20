<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<% 
	// 세션 유효성 검사
	// 받아 온 세션 값이 유효하지 않으면 홈으로 이동됨.
	// 회원정보칸은 로그인시만 메뉴에 노출 되지만 주소를 통한 접속을 막기 위함
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	// 정보 수정창에서도 아이디 보이게 설정. 세션에서 로그인으로 받아온 값을 memberId으로 가져온다.
	String loginmemberId = (String)session.getAttribute("loginMemberId");
	System.out.println(loginmemberId + " <- update m.f memberid");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<title>회원정보 수정</title>
</head>
<body>
	<div  class="container mt-3">
	<!--- 메인메뉴(가로) ---------------------------------------------------------------------------->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<h2 style="text-align: center">회원정보 수정</h2>
	<hr>
	<!-- 회원정보 폼 내에서 출력할 메세지 칸 -->
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
	<form action="<%=request.getContextPath()%>/member/updateMemberAction.jsp" method="post">
	<table class="table">
		<tr>
			<td>아이디</td>
			<td><%=loginmemberId%></td>
		</tr>
		<tr>
			<td>현재 비밀번호</td>
			<td><input type="password" name="memberPw"></td>
		</tr>
		<tr>
			<td>비밀번호 변경</td>
			<td><input type="password" name="updatePw"></td>
		</tr>
	</table>
	<div>
	<button type="submit" class="btn btn-light">수정</button>
	<a href="<%=request.getContextPath()%>/member/userinfomation.jsp" class="btn btn-light">취소</a>
	</div>
	</form>
	</div>
</body>
</html>