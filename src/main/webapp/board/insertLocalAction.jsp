<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("UTF-8");

	// 세션 & 요청값 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	// 카테고리 입력 유효하지 않을 시 안내메세지 출력
	String msg =""; 
	if(request.getParameter("localName") == null
	|| request.getParameter("localName").equals("")) { // 공백 입력시 변화 없음. 요청 무효	
		msg = URLEncoder.encode("추가할 카테고리를 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertLocalForm.jsp?msg="+msg);
		return;
	}
	
	// 필요한 값 저장 (지역명)
	String localName = request.getParameter("localName");
	System.out.println(localName+"<---insertLocalAction");
	
	// DB 연동 모델값
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 카테고리 추가 결과셋 _ vo* 다 불러옴 _ insert into 사용
	String insertLocalSql = "INSERT INTO local(local_name, createdate, updatedate) values(?,now(),now())";
	PreparedStatement insertLocalStmt = conn.prepareStatement(insertLocalSql);
	insertLocalStmt.setString(1, localName);
	ResultSet insertLocalRs = null;
	
	System.out.println(insertLocalStmt + " <-- insertLocalAction Stmt");
	
	// 입력 성공시 행추가 설정
	int row = insertLocalStmt.executeUpdate(); // 추가 ) executeUpdate 사용
	
	if(row == 1){ // 추가 성공시 동일한 폼에 성공 메세지 띄우기
		System.out.println("카테고리가 추가되었습니다.");
		msg = URLEncoder.encode("카테고리가 추가되었습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertLocalForm.jsp?msg="+msg);
		return;
	} else { // 실패시 폼에서 멈춰있음 + "
		System.out.println("카테고리 추가가 실행되지 않았습니다.");
		msg = URLEncoder.encode("카테고리 추가에 실패하였습니다", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertLocalForm.jsp?msg="+msg);
		return;
	}
%>