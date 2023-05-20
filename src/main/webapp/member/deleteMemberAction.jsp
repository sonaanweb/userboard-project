<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>
<%
	request.setCharacterEncoding("utf-8");

	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	String memberId = (String)session.getAttribute("loginMemberId"); 
	/*System.out.println(request.getParameter( memberId + "<--- deleteMemberAction id"));*/
	
	// 탈퇴시 필요한 비밀번호 값 공백일 때 메세지 출력
	String msg="";
	if (request.getParameter("memberPw") == null
	|| request.getParameter("memberPw").equals("")) {
	msg = URLEncoder.encode("비밀번호를 입력해주세요", "UTF-8");
	response.sendRedirect(request.getContextPath() + "/member/deleteMember.jsp?msg=" + msg);
	return;
	}
	
	String memberPw = request.getParameter("memberPw");
	/*System.out.println( memberPw + " <--- deleteMemberAction pw");*/
	
	// 모델계층 DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 회원탈퇴 쿼리
	// executeUpdate
	/*
		DELETE 
		FROM member where member_id? and member_pw=?
	*/
	String delSql = "DELETE FROM member where member_id=? and member_pw=PASSWORD(?)";
	PreparedStatement delStmt = conn.prepareStatement(delSql);
	delStmt.setString(1, memberId);
	delStmt.setString(2, memberPw);
	System.out.println(delStmt + " <--- deleteMemberAction stmt");
	
	// 쿼리 실행 - 삭제 확인에 필요한 행 
	int row = delStmt.executeUpdate();
	/* System.out.println(row + " <--- delmemberaction row" ); 0확인 */
	if (row == 1) {
		msg = URLEncoder.encode("회원 탈퇴가 완료되었습니다", "UTF-8");
		session.invalidate(); // 세션 정보 삭제
		response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp?msg="+ msg);
	} else {
		msg = URLEncoder.encode("비밀번호를 확인해주세요", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/member/deleteMember.jsp?msg="+ msg);
	}
%>