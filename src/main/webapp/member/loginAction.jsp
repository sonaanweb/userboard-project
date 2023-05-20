<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %> <!-- utf-8 한글 인코딩 -->
<%@ page import = "vo.*" %>
<%
	// 1.세션 유효성 검사
	if(session.getAttribute("loginMemberId")!=null) { // 로그인 성공했으면 home으로 이동
		response.sendRedirect(request.getContextPath()+"/member/loginForm.jsp");
		return;
	}

	// 2.요청값 유효성 검사 loginForm에서 받아온 값을 저장
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	System.out.println(memberId + "<--loginAction memberId--");
	System.out.println(memberPw + "<--loginAction memberPw--");
	
	// 위에서 받은 값이 null 또는 공백일 시 안내 메세지 출력
	String msg = null;
	if(request.getParameter("memberId") == null
	|| request.getParameter("memberId").equals("")){
		msg = URLEncoder.encode("아이디를 입력해주세요", "utf-8");
	}else if(request.getParameter("memberPw") == null
	|| request.getParameter("memberPw").equals("")){
		msg = URLEncoder.encode("비밀번호를 입력해주세요", "utf-8");
	}
	
	if(msg != null){ // 위에 하나라도 해당 될 시 페이지와 폼 변화가 일어나지 않음. loginForm에서 메세지 출력
		response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp?msg=" + msg);
		return;
	}
	
	Member paramMember = new Member();
	paramMember.setMemberId(memberId); // 파람멤버에다 memberId 넣는다
	paramMember.setMemberPw(memberPw); // 파람멤버에다 memberPw 넣는다
	
	// DB 연동
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// * PW값은 암호화 설정. pw = PASSWORD(?)
	String sql = "SELECT member_id memberId FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	stmt.setString(2, memberPw);
	System.out.println(stmt);
	rs = stmt.executeQuery();
	if(rs.next()) { //로그인 성공
		// 세션에 로그인 정보(ID)를 저장(유효성 검사 실행시 사용). 자동 홈 이동
		session.setAttribute("loginMemberId", rs.getString("memberId"));
		System.out.println("로그인 성공 세션정보 : " + session.getAttribute("loginMemberId"));
		response.sendRedirect(request.getContextPath()+"/home.jsp");
	}else{ // 로그인 실패
		System.out.println("로그인 실패");
		msg = URLEncoder.encode("아이디 또는 비밀번호를 확인해주세요.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/loginForm.jsp?msg="+ msg);
	}
%>