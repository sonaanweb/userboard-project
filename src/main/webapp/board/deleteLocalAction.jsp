<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");
	//local del Action utf-8 >> 리스폰스가 아닌 request로 요청시 정상 확인

	// 유효성 검사
	if (session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() +"/home.jsp");
		return;
	}
	
	if(request.getParameter("localName")==null 
	|| request.getParameter("localName").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/category.jsp"); //다시 Form 화면 보여줌
		return;
	}
	
	// 받아온 값 저장
	String localName = request.getParameter("localName");
	System.out.println(localName+"<--delAction localName");

	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 1. 게시판이 사용중이면 삭제 되지 않도록 설정 게시글수 count
	String sql = "select count(*) from board where local_name = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, localName);
	ResultSet rs = stmt.executeQuery();
	
	int cnt = 0;
	if(rs.next()){
		cnt = rs.getInt("count(*)");
	}
	
	String msg = null;
	if(cnt != 0){ // 0이 아니면 사용중인 게시판이므로 돌려보냄
		msg = URLEncoder.encode("게시글이 남아있는 카테고리이므로 삭제할 수 없습니다.", "utf-8");
		localName = URLEncoder.encode(localName, "UTF-8"); //로컬네임 인코딩
		response.sendRedirect(request.getContextPath()+"/board/deleteLocalForm.jsp?localName="+localName+"&msg="+msg);
		return;
	}
	
	// 2. 삭제 쿼리 DELETE
	PreparedStatement delStmt = null;
	ResultSet delLocalRs = null;
	String delSql = "DELETE FROM local WHERE local_name = ?";
	delStmt = conn.prepareStatement(delSql);
	delStmt.setString(1, localName);
	System.out.println(delStmt + " <--- deleteLocalAction Stmt");
	
	int row = delStmt.executeUpdate();
	
	if (row == 1){ // 삭제된 행 존재
		System.out.println(row + " <--- 카테고리 삭제성공");
		msg = URLEncoder.encode("카테고리가 삭제되었습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/category.jsp?msg="+msg);
	} else {
		System.out.println(row + " <--- 카테고리 삭제실패");
		msg = URLEncoder.encode("카테고리 삭제에 실패하였습니다", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/category.jsp?msg="+msg);
	}
%>
