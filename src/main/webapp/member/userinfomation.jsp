<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	// 세션 유효성 검사
	// 받아 온 세션 값이 유효하지 않으면 홈으로 이동됨.
	// 회원정보칸은 로그인시만 메뉴에 노출 되지만 주소를 통한 접속을 막기 위함
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
	}

	// 세션에서 로그인으로 받아온 값을 memberId으로 가져온다. 해당 사용자에 맞는 정보를 보여주기 위함
	// getAttribute 메소드의 반환 데이터타입은 object인데 memberId=String값이 필요하므로 변환
	String loginmemberId = (String)session.getAttribute("loginMemberId");
	System.out.println( loginmemberId + "<---userinfomation id");
	
	// 2. 모델 계층
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 2-1) userinfomation 결과셋
	/*
		SELECT
		member_id, createdate, updatedate from member where member_id =?";
	*/
	PreparedStatement stmt = null;
	ResultSet uiRs = null;
	String uiSql = null;
	uiSql = "SELECT member_id memberId, member_pw memberPw, createdate, updatedate FROM member WHERE member_id = ?";
	stmt = conn.prepareStatement(uiSql);
	stmt.setString(1,loginmemberId);
	uiRs = stmt.executeQuery();
	
	// 모델계층
	// 회원정보 개수는 로그인 사용자 정보 하나이므로 ArrayList를 사용하지 않는다.
	Member member = null;
	if(uiRs.next()){
		member = new Member();
		member.setMemberId(uiRs.getString("memberId"));
		member.setMemberPw(uiRs.getString("memberPw"));
		member.setCreatedate(uiRs.getString("createdate"));
		member.setUpdatedate(uiRs.getString("updatedate"));
	}
	System.out.println( member + "<--- userinfomation memberid ");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
</style>
<title>회원정보</title>
</head>
<body>
	<!-- 메인메뉴 -->
	<div  class="container mt-3">
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<!-- 회원정보창 : 아이디와 가입일만 뷰 노출 -->
	<h2 style="text-align: center">회원정보</h2>
	<hr>
	<table class="table">
		<tr>
			<td>아이디</td>
			<td><%=member.getMemberId()%></td>
		</tr>
		<tr>
			<td>가입일</td>
			<td><%=member.getCreatedate()%></td>
		</tr>
	</table>
	<br>
	<div id="button">
		<a href="<%=request.getContextPath()%>/member/updateMemberForm.jsp" class="btn btn-light">회원정보 수정</a>
		<a href="<%=request.getContextPath()%>/member/deleteMember.jsp" class="btn btn-dark" style="float: right">회원탈퇴</a>
	</div>
	</div>
</body>
</html>