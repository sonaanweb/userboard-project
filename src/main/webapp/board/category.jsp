<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.net.*" %>
<%
	// 세션 유효성 검사
	// 카테고리 메뉴는 로그인 성공한 후에 보임
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	String memberId = (String)session.getAttribute("loginMemberId");
	System.out.println(memberId + " <--- category Id");
	
	// DB연동 모델값
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// local 테이블 결과셋 SELECT - 데이터는 다 불러오지만 노출 되는 건 지역명으로만 설정
	// executeQuery
	PreparedStatement localStmt = null;
	ResultSet localRs = null;
	String localSql = "SELECT local_name localName, createdate, updatedate From local;";
	localStmt = conn.prepareStatement(localSql);
	/*System.out.println( localStmt + "<--- category localstmt" );*/
	
	localRs = localStmt.executeQuery();
	
	// vo * arraylist 사용
	ArrayList<Local> localList = new ArrayList<Local>();
	while(localRs.next()) {
		Local c = new Local();
		c.setLocalName(localRs.getString("localName"));
		c.setCreatedate(localRs.getString("createdate"));
		c.setUpdatedate(localRs.getString("updatedate"));
		localList.add(c); // 끝날 때 까지 추가
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
a {text-decoration: none;}
th,td{
 text-align : center;
 vertical-align : middle;}
th,th{
width: 200px;}
</style>
<title>localList.jsp</title>
</head>
<body>
<!---------------------------- 관리 페이지에 카테고리 관리 버튼 추가 버튼 누르면 -> 카테고리 리스트 + 수정 + 삭제 + 추가 구현 -->
	<div class="container mt-3">
	<div>
	<!--- 메인메뉴(가로) ---------------------------------------------------------------------------->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<h2 style="text-align: center">카테고리 목록</h2>
	<hr>
	<!-- 카테고리 폼 내에서 출력할 메세지 칸 -->
		<div style="text-align: center;">
		<%
			if(request.getParameter("msg")!=null) {
		%>
			<%=request.getParameter("msg")%>
		<%
			}
		%>
		</div>
	<a href="<%=request.getContextPath()%>/board/insertLocalForm.jsp" class="btn btn-warning">추가</a>
	<table class="table">
		<tr>
			<th>지역명</th>
			<th>편집</th>
		</tr>
	<!--- 카테고리 폼 ------------------------------------------------------------------------------>
	<%
		for(Local c : localList) {
	%>
		<tr>
			<td>
				<%=c.getLocalName()%>
			</td>
			<td>
				<a href="<%=request.getContextPath()%>/board/updateLocalForm.jsp?localName=<%=c.getLocalName()%>" class="btn btn-light">수정</a>
				<a href="<%=request.getContextPath()%>/board/deleteLocalForm.jsp?localName=<%=c.getLocalName()%>" class="btn btn-light">삭제</a>
			</td>
	<%
		}
	%>
	</table>
	<!-- include 페이지 :  Copyright &copy; 구디아카데미 ---------------------------------------------->
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
	<br>
	</div>
</body>
</html>