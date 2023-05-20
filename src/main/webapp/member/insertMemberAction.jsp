<%@page import="javax.naming.spi.DirStateFactory.Result"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*"%> <!-- 한글 인코딩 포함 -->
<%@ page import = "java.sql.*"%>
<%@ page import = "vo.*"%>
<%

	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	
	// 회원가입폼 null값이나 공백일 때 폼변화 없음. 메세지 출력
	String msg="";
	if(request.getParameter("memberId") == null
	||request.getParameter("memberId").equals("")
	||request.getParameter("memberPw") == null
	||request.getParameter("memberPw").equals("")){
	msg = URLEncoder.encode("사용할 아이디 또는 비밀번호를 입력해주세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
		return;
	}

	// 요청값 유효성 검사와 변수 저장 (회원가입 폼에 필요한 정보 ID/PW)
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");

	/*System.out.println(memberId + "<--insertMemberAction memberId--");
	System.out.println(memberPw + "<--insertMemberAction memberPw--"); 디버깅 확인*/
	
	//드라이버 로딩 DB 연동
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	
	// 동적 쿼리를 위한 변수
	Connection conn = null; // DB와 서버를 연결하는 객체
	PreparedStatement stmt = null; // PreparedStatement = 값 지정
	ResultSet rs = null; // 결과셋
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/* System.out.println("<---insertMemberAction 드라이버 실행 확인");
	System.out.println(conn + "<--- insertAction conn "); */ 
	
	// 1. 중복아이디 체크 쿼리 실행(SELECT) - 동일한 아이디가 존재하면 안 되므로.
	// executeQuery : DB로 부터 정보를 가져올 경우 사용 - 실행시 결과가 result set에 담겨져서 반환 된다.
	PreparedStatement checkStmt = null;
	ResultSet checkRs = null;
	/*
		SELECT
		COUNT(*) -- count(*) 테이블 레코드 수 반환
		from member where member_id = ?
	*/
	String checkSql = "SELECT count(*) FROM member WHERE member_id = ?";
	checkStmt = conn.prepareStatement(checkSql);
	checkStmt.setString(1, memberId);
	checkRs = checkStmt.executeQuery();
	int cnt = 0;
	if(checkRs.next()){
		cnt = checkRs.getInt("count(*)");
	}
	
	if(cnt > 0) { // cnt의 값이 1이상이면 중복 아이디 존재. 폼 변화 없음
		System.out.println("중복된 아이디가 있습니다");
		msg = URLEncoder.encode("이미 사용중인 아이디입니다", "utf-8");
	    response.sendRedirect(request.getContextPath() + "/member/insertMemberForm.jsp?msg="+msg);
	    return;
	}
	
	// 2. 회원가입 쿼리 실행(INSERT) DB서버에 추가
	// executeUpdate : DB에게 정보를 넘길 때 사용 - 수정된 레코드(행)의 개수(int)가 반환된다.
	/*
		패스워드 암호화 사용 PASSWORD(?)
		INSERT
		INTO member(member_id, member_pw, createdate, updatedate)
		VALUES(?, PASSWORD(?), now(), now())
	*/
	String sql = "INSERT into member(member_id, member_pw, createdate, updatedate) VALUES(?, PASSWORD(?), now(), now())";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	stmt.setString(2, memberPw);
	int row = stmt.executeUpdate(); // insert -> update 행추가
	/*System.out.println(row + "<---insertMemberAction row"); == 1 확인 */
	
	if(row==1) { // 행 추가 성공시 회원가입 완료. 동일한 페이지에서 메세지 띄우기
		System.out.println(row + "<--- insertAction 회원가입 완료");
		msg = URLEncoder.encode("회원 가입이 완료되었습니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/insertMemberForm.jsp?msg="+msg);
		return;
	} else {
		System.out.println(row+ "<--- insertAction 회원가입 실패");
		msg = URLEncoder.encode("다시 시도해주세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp=?msg="+msg);
		return;
	}
		
%>