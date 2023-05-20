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
	
	// 로그인 아이디 세션 값 loginmemberId
	String loginMemberId = (String)session.getAttribute("loginMemberId") ;
	/*System.out.println(loginMemberId + "<--- deletecomment loginMemberId");*/
	
	// 하나라도 null or 공백 값이 있으면 돌아간다
	if(request.getParameter("boardNo") == null
	||request.getParameter("boardNo").equals("")
	||request.getParameter("memberId") == null
	||request.getParameter("memberId").equals("")
	||request.getParameter("commentNo") == null
	||request.getParameter("commentNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
		return;	
	}
	
	// boardOne 삭제버튼에서 받아온 값 저장하기
	String boardNo = request.getParameter("boardNo");
	String memberId = request.getParameter("memberId");
	String commentNo = request.getParameter("commentNo");
	
	/*System.out.println(boardNo + "<--- del comment boardNo " );
	System.out.println(memberId + "<--- del comment memberId " );
	System.out.println(commentNo + "<--- del comment commentNo " );*/
	
	
	if(!loginMemberId.equals(memberId)){ // 로그인 멤버와, 받아온 memberid가 일치하지 않으면 댓글 삭제 X
		System.out.println("댓글 삭제에 실패하였습니다");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp"); //폼 변화 없음
	}
	
	
	// DB연동 모델값
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println(conn + "<---del com conn");	
	
	// 삭제 쿼리 DELETE FROM - where 요청값 세가지
	// executeUpdate
	String Sql = "DELETE FROM comment where comment_no =? AND member_id =? and board_no=?";
	PreparedStatement Stmt = conn.prepareStatement(Sql);
	Stmt.setString(1, commentNo);
	Stmt.setString(2, memberId);
	Stmt.setString(3, boardNo);
	System.out.println(Stmt + " <---stmt-- commentDelete.jsp delStmt" );

	// 댓글 삭제 확인 행
	int row = Stmt.executeUpdate();
	if (row > 0) { // 0보다 크면 댓글 삭제 성공
	    System.out.println("댓글이 삭제되었습니다.");
	    response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo); //boardone에서 변화
	    return;
	} else { // 실패
	    System.out.println("삭제된 행이 없습니다");
	}

%>
