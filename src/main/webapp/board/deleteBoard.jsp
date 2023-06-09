<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%>   
<%
	
	request.setCharacterEncoding("utf-8");

	// 세션 로그인 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 로그인 아이디 세션 값 loginmemberId 저장
	String loginMemberId = (String)session.getAttribute("loginMemberId") ;
	/*System.out.println(loginMemberId + "<--- deleteboard loginMemberId");*/
	
	// 하나라도 null or 공백 값이 있으면 돌아간다
	if(request.getParameter("boardNo") == null
	||request.getParameter("boardNo").equals("")
	||request.getParameter("memberId") == null
	||request.getParameter("memberId").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
		return;	
	}
	
	// boardOne 삭제버튼에서 받아온 값 저장하기
	String boardNo = request.getParameter("boardNo");
	String memberId = request.getParameter("memberId");
	/* System.out.println(boardNo + "<--- del board boardNo " );
	System.out.println(memberId + "<--- del board memberId " );  */
		
	String msg="";
	
	if(!loginMemberId.equals(memberId)){ // 로그인 멤버와, 받아온 memberid가 일치하지 않으면 게시글 삭제 X
		msg = URLEncoder.encode("작성자가 일치하지 않습니다", "utf-8"); 
		System.out.println("게시글 삭제에 실패하였습니다");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo=" + boardNo + "&msg="+msg);
	}
	
	
	// DB연동 모델값
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println(conn + "<---del board conn");
	
	// 게시글 삭제 쿼리 DELETE
	String delSql = "DELETE FROM board WHERE board_no = ? and member_id = ?";
	PreparedStatement delStmt = conn.prepareStatement(delSql);
	delStmt.setString(1, boardNo);
	delStmt.setString(2, memberId);
	System.out.println(delStmt + " <--- delete board Action Stmt");
	
	// 게시글 삭제 확인 행
	int row = delStmt.executeUpdate();
	if (row > 0) { // 0보다 크면 댓글 삭제 성공
		msg = URLEncoder.encode("게시글이 삭제되었습니다.", "utf-8");
	    System.out.println("게시글이 삭제되었습니다.");
	    response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg); //home으로
	    return;
	} else { // 실패
	    System.out.println("삭제된 게시글이 없습니다");
	}

%>
