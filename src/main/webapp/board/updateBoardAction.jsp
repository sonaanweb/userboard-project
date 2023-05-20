<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	request.setCharacterEncoding("utf-8");

	// 세션 유효성 검사 && 받아온 요청값 디버깅
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	/*System.out.println(request.getParameter("boardNo") + " <--- updateBoardAction param boardNo");
	System.out.println(request.getParameter("LocalName") + " <--- updateBoardAction param LocalName");
	System.out.println(request.getParameter("boardTitle") + " <--- updateBoardAction param boardTitle");
	System.out.println(request.getParameter("boardContent") + " <--- updateBoardAction param boardContent");*/
	
	// 안내 메세지를 위한 초기화
	// boardNo값이 유효하지 않을 시 홈으로 
	if(request.getParameter("boardNo") == null 
			|| request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 받아온 요청값 변수에 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String LocalName = request.getParameter("LocalName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	/*System.out.println(boardNo + " <--updateBoardAction no");
	System.out.println(LocalName + " <--updateBoardAction LocalName");
	System.out.println(boardTitle + " <--updateBoardAction Title");
	System.out.println(boardContent + " <--updateBoardAction Content");*/
	
	
	String msg = "";
	// 수정시 공백 칸 불가 - 필수 입력 사항 3가지
	// 안내 메세지 출력 + 폼 변화 없음
	if(request.getParameter("LocalName") == null
			|| request.getParameter("LocalName").equals("")
			|| request.getParameter("boardTitle") == null
			|| request.getParameter("boardTitle").equals("")
			|| request.getParameter("boardContent") == null
			|| request.getParameter("boardContent").equals("")){
		msg = URLEncoder.encode("내용을 입력해주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/updateBoard.jsp?boardNo=" +boardNo+ "&msg="+msg);
		return;
	}
	// DB연동 모델셋
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	ResultSet rs = null;

	// -------- 게시글 수정 쿼리 ------- update set
	// executeUpdate
	/* 
		UPDATE board 
		set local_name = ?, board_title = ?, board_content = ?, updatedate = now() <createdate는 고정>
		where board_no = ? 
	*/
	String sql = "UPDATE board SET local_name = ?, board_title = ?, board_content = ?, updatedate = now() WHERE board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println(stmt + " <--- updateBoardAction stmt");
	stmt.setString(1, LocalName);
	stmt.setString(2, boardTitle);
	stmt.setString(3, boardContent);
	stmt.setInt(4, boardNo);
	
	// 수정 행 확인 쿼리
	int row = stmt.executeUpdate();
	System.out.println(row + " <--- updateBoardAction row");
	
	if(row == 1){ // 수정된 행 1행일 시 수정 완료
		msg = URLEncoder.encode("게시글 수정이 완료되었습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
		return;
	} else { 
		msg = URLEncoder.encode("게시글 수정에 실패하였습니다. 다시 시도해주세요.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoard.jsp?msg="+ msg);
	}
%>