<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%>
<%
	// 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
	   response.sendRedirect(request.getContextPath()+"/home.jsp");
	   return;
	} 

	// 삭제할 댓글 번호 유효성 검사
	if(request.getParameter("commentNo") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 필요한 요청 값 받아와 저장하기
	String loginMemberId = "";
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	
	// DB연동 모델값
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);

	// 댓글 수정 쿼리 SELECT
	// executeQuery
	PreparedStatement Stmt = null;
	ResultSet Rs = null;
	String Sql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM comment WHERE comment_no = ?";
	Stmt = conn.prepareStatement(Sql);
	Stmt.setInt(1, commentNo);
	System.out.println(Stmt + "<--- Updatecomment Stmt");
		
	Rs = Stmt.executeQuery(); 
	Comment com = new Comment();
	if(Rs.next()){
		com = new Comment();
		com.setCommentNo(Rs.getInt("commentNo"));
		com.setBoardNo(Rs.getInt("boardNo"));
		com.setCommentContent(Rs.getString("commentContent"));
		com.setMemberId(Rs.getString("memberId"));
		com.setCreatedate(Rs.getString("createdate"));
		com.setUpdatedate(Rs.getString("updatedate"));
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<title>댓글수정</title>
</head>
<body>
	<!-- 메인메뉴 -->
	<div class="container mt-3">
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<h2 style="text-align: center">댓글 수정</h2>
	<hr>
	<form action="<%=request.getContextPath()%>/board/updateCommentAction.jsp?commentNo=<%=com.getCommentNo()%>&boardNo=<%=com.getBoardNo()%>">
		<table class="table">
			<tr>
				<td>현재 댓글</td>
				<td>
					<input type="text" name="commentNo" hidden="hidden" value="<%=com.getCommentNo()%>">
					<input type ="text" name="comment" value="<%=com.getCommentContent()%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td>수정 댓글</td>
				<td><input type ="text" name="updateComment" size="120"></td>
			</tr>
		</table>
		<button type="submit" class="btn btn-light">수정</button>
		<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=com.getBoardNo()%>" class="btn btn-light">취소</a>
	</form>
</div>
</body>
</html>