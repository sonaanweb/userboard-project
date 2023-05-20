<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.util.*"%>
<%
	//인코딩
	request.setCharacterEncoding("UTF-8");
	
	//세션 로그인 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 어느 게시글의 댓글을 삭제 했는 지 알기 위함 _ boardNo 값이 유효하지 않을 시 홈으로 이동
	if(request.getParameter("boardNo") == null
	|| request.getParameter("boardNo").equals("")){	
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	String msg="";
	// 댓글 공백 불가능.
	if(request.getParameter("commentContent").equals("")) {
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+request.getParameter("boardNo"));
		return;
	}

	//필요한 값 변수 지정 : 게시글 번호, 댓글, 아이디
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentContent = request.getParameter("commentContent");
	String memberId = request.getParameter("memberId");
	
	/*System.out.println(boardNo + "<---Insert comment boardNo");
	System.out.println(commentContent + "<---Insert comment boardNo"); 
	System.out.println(memberId + "<---Insert comment boardNo");*/
	
	// DB연동 모델값
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 댓글 입력 결과셋 insert into
	/*INSERT INTO COMMENT 필요 값 , 보여질 값 
	(board_no
	comment_content, member_id, createdate, updatedate)
	VALUE(?, ?, ?, NOW(), NOW())
	*/
	PreparedStatement insertCommentstmt = null;
	String insertCommentsql = "INSERT INTO comment(board_no, comment_content, member_id, createdate, updatedate) values(?,?,?,now(),now())";
	insertCommentstmt = conn.prepareStatement(insertCommentsql);
	insertCommentstmt.setInt(1,boardNo);
	insertCommentstmt.setString(2,commentContent);
	insertCommentstmt.setString(3,memberId);
	
	// 쿼리 결과셋
	int row = insertCommentstmt.executeUpdate();
	System.out.println(row + "<--insertCommentAction row");
	
	if(row == 1) { // 댓글 입력 성공시 디버깅
		System.out.println("댓글입력 완료");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	} else { // 행 영향 X 댓글 입력 실패
		System.out.println("댓글입력 실패");
	}
	
%>