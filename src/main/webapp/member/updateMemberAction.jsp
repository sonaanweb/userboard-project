<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%@ page import="vo.*" %>
<%
	// 세션 유효성 검사
	// 받아 온 세션 값이 유효하지 않으면 홈으로 이동됨.
	// 회원정보칸은 로그인시만 메뉴에 노출 되지만 주소를 통한 접속을 막기 위함
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	String loginmemberId = (String)session.getAttribute("loginMemberId"); 
	
	// 받아온 값 (현재 비밀번호와 변경할 비밀번호) 유효하지 않을 시 안내 메세지 출력
	String msg = null;
	if(request.getParameter("memberPw") == null
	|| request.getParameter("memberPw").equals("")){
		msg = URLEncoder.encode("현재 비밀번호를 입력하세요", "utf-8");
	}else if(request.getParameter("updatePw") == null
	|| request.getParameter("updatePw").equals("")){
		msg = URLEncoder.encode("변경할 비밀번호를 입력하세요", "utf-8");
	}
	if(msg != null){ // 위에 하나라도 해당 될 시 페이지, 폼 변화 X - form에서 안내 메세지 출력
		response.sendRedirect(request.getContextPath() + "/member/updateMemberForm.jsp?msg=" + msg);
		return;
	}
	
	// 정보 수정페이지 요청값 저장 & 디버깅
	String memberPw = request.getParameter("memberPw");
	String updatePw = request.getParameter("updatePw");
	System.out.println(memberPw + "<---updatememberAction memberpw");
	System.out.println(updatePw + "<---updatememberAction updatepw");
	
	/*변경하려는 비밀번호와 현재 비밀번호가 같을 시 메세지 출력. 폼 변화 없음 * 데이터베이스 값과 일치하지 않아서 다시 해보기
	if (memberPw.equals(updatePw)) {
		msg = URLEncoder.encode("현재 비밀번호와 다른 비밀번호를 입력해주세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/updateMemberForm.jsp?msg="+msg);
		return;
	} */
	
	// 모델 계층
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 비밀번호 변경 결과셋 쿼리 update set
	String updateSql = null;
	PreparedStatement updateStmt = null;
	/*
		UPDATE	패스워드 암호화와 SET 사용. where절 이전 새로운 값
		member set member_pw = password(?) where member_id = ? and member_pw = password(?)
	*/	
	updateSql = "update member set member_pw = password(?) where member_id = ? and member_pw = password(?)";
	updateStmt = conn.prepareStatement(updateSql);
	updateStmt.setString(1, updatePw);
	updateStmt.setString(2, loginmemberId); // 폼에서 지정한 이름 동일하게
	updateStmt.setString(3, memberPw);
	System.out.println( updateStmt + "<--- updateMemberAction stmt" );
	
	// 쿼리 실행 - 변경 확인에 필요한 행
	int row = updateStmt.executeUpdate();
	/* System.out.println(row + " <--- updateMemberAction row" ); 0확인*/
	
	if(row == 1){ // 정상적으로 변경 성공했을 때 로그인폼으로 이동 후 메세지 출력
		msg = URLEncoder.encode("회원정보가 정상적으로 변경되었습니다. 다시 로그인 해주세요.", "utf-8");
		session.invalidate(); //세션 삭제
		response.sendRedirect(request.getContextPath()+"/member/loginForm.jsp?msg="+msg);
	} else { // 변경에 실패한 경우
		msg = URLEncoder.encode("변경에 실패하였습니다. 비밀번호를 다시 확인해주세요.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/updateMemberForm.jsp?msg="+msg);
	}
	
%>