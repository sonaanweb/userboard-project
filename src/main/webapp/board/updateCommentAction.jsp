<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>
<%

	// 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
	   response.sendRedirect(request.getContextPath()+"/home.jsp");
	   return;
	} 

	String msg = "";
	
	// 요청값 저장
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String comment = request.getParameter("comment");
	String updateComment = request.getParameter("updateComment");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	System.out.println(commentNo + "<---update com No");
	System.out.println(comment + "<---pre comment");
	System.out.println(updateComment + "<---update comment");
		
	// 유효성 검사 null값 * 공백은 받지 않는다. 폼 변화 X
	if(request.getParameter("commentNo") == null
	|| request.getParameter("commentNo").equals("")
	|| request.getParameter("comment")==null
	|| request.getParameter("comment").equals ("")
	|| request.getParameter("updateComment")==null
	|| request.getParameter("updateComment").equals ("")) {
		msg = URLEncoder.encode("수정할 내용을 입력해주세요.", "utf-8");
		response.sendRedirect(request.getContextPath() +"/board/updateCommentForm.jsp?msg="+msg+"&boardNo="+boardNo+"&commentNo="+commentNo); //msg호출 먼저
		return;
	} 
	// DB연동 모델값
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);	

	// 수정 쿼리 UPDATE
	// executeUpdate
	PreparedStatement CommentUpstmt = null;
	ResultSet CommentUpRs = null;
	String CommentUpsql = "UPDATE comment SET comment_content = ?, updatedate = now() WHERE comment_no = ?";
	CommentUpstmt = conn.prepareStatement(CommentUpsql);
	CommentUpstmt.setString(1, updateComment);
	CommentUpstmt.setInt(2, commentNo);
	System.out.println(CommentUpstmt + "<--댓글 수정 액션 stmt");
	
	int row = CommentUpstmt.executeUpdate();
	if(row == 1) {// 댓글 수정 성공 수정행 1 
		System.out.println("댓글이 수정되었습니다");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	} else {
		System.out.println("댓글 수정에 실패하였습니다");
		response.sendRedirect(request.getContextPath()+"/board/updateCommentForm.jsp?commentNo="+commentNo);
		return;
	}
%>