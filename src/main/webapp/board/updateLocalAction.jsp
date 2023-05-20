<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>
<%
	// LOCAL 지역명 인코딩 따로 필수로 하기 !!
	
	request.setCharacterEncoding("utf-8");
	
	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 폼에서 받아온 값 저장 변경 전 / 변경 후 지역명
	String localName = request.getParameter("localName");
	String newLocalName = request.getParameter("newLocalName");
	
	String msg ="";
	if(request.getParameter("localName") == null
	|| request.getParameter("localName").equals("")) { // 기존 지역명 유효하지 않을시 변화X
		response.sendRedirect(request.getContextPath()+"/board/updateLocalForm.jsp?msg="+msg);
		return;
	}
	
	if(request.getParameter("newLocalName")==null
			|| request.getParameter("newLocalName").equals("")){
			msg = URLEncoder.encode("변경할 내용을 입력하세요", "utf-8");
			localName = URLEncoder.encode(localName, "utf-8");
			response.sendRedirect(request.getContextPath()+"/board/updateLocalForm.jsp?localName="+localName+"&msg="+msg);
			return;
		}
	
	// 모델값
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	// 필요 stmt 변수 미리 지정
	PreparedStatement stmt = null;
	PreparedStatement stmt2 = null; 
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 1. 첫번째 쿼리: 중복 판단 SELECT
	String sql1="SELECT local_name localName FROM local WHERE local_name=?";
	stmt = conn.prepareStatement(sql1);
	stmt.setString(1, newLocalName);
	rs = stmt.executeQuery();
	
	// localName 중복검사
	if(rs.next()){
		localName = URLEncoder.encode(localName, "utf-8");
		msg = URLEncoder.encode("이미 존재하는 카테고리명입니다.", "utf-8");
		// 중복값 메세지 
		response.sendRedirect(request.getContextPath()+"/board/updateLocalForm.jsp?localName="+localName+"&msg="+msg);
		return;
	}
	
	// ---------------- //
	
	// 2. 두번째 쿼리: 새로운 이름으로 변경 UPDATE set
	String sql2 = "UPDATE local SET local_name = ?, updatedate = NOW() WHERE local_name = ?";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, newLocalName); //변경
	stmt2.setString(2, localName); //전
	System.out.println(stmt + " <-- updateLocalAction stmt");
	
	// || UPDATE 행 확인
	int row = stmt2.executeUpdate();
	System.out.println(row + "<--updateLocalAction row");
	//완료 행 값에 따라 메세지 주기
	if(row == 1){ //수정 완료. 수정폼에 메세지 띄움
		msg = URLEncoder.encode("변경 완료되었습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/category.jsp?msg="+msg);
	} else if(row == 0){
		localName = URLEncoder.encode(localName, "utf-8");
		msg = URLEncoder.encode("변경에 실패하였습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateLocalForm.jsp?localName="+localName+"&msg="+msg);
		return;
	}
%>