<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8"); //post - action - request.encoding

	// 세션 & 요청값 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	// 입력칸 유효하지 않을 시 안내메세지 출력 - 카테고리/제목/내용
	String msg =""; 
	if(request.getParameter("localName") == null
	|| request.getParameter("localName").equals("")// 공백 입력시 변화 없음. 요청 무효
	|| request.getParameter("boardTitle") == null
	|| request.getParameter("boardTitle").equals("")
	|| request.getParameter("boardContent") == null
	|| request.getParameter("boardContent").equals("")){
		msg = URLEncoder.encode("내용을 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoard.jsp?msg="+msg);
		return;
	}
	
	// 폼에서 받아온 필요 값 저장 (아이디/카테고리/제목/내용)
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	/*System.out.println(loginMemberId + " <-- insert boardAction MemberId");
	System.out.println(localName + " <-- insert boardAction localName");
	System.out.println(boardTitle + " <-- insert boardAction boardTitle");
	System.out.println(boardContent + " <-- insert boardAction boardContent");*/
	
	// DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//1) 게시글 추가시 카테고리 유효값 확인 쿼리
	String insertsql = "SELECT count(*) FROM board WHERE local_name = ?";
	PreparedStatement insertstmt = conn.prepareStatement(insertsql);
	insertstmt.setString(1,localName);
	System.out.println(insertstmt + "<--- insert board stmt");
	ResultSet rs = insertstmt.executeQuery();
	
	int cnt = 0;
	    if (rs.next()) { // 존재하는 카테고리면 cnt값 (+)
	        cnt = rs.getInt("count(*)");
	    }
	
    if (cnt <= 0) { //존재하지 않는 카테고리일 시 메세지 출력 cnt값 변화 없음
    	System.out.println("유효하지 않은 카테고리입니다.");
    	msg = URLEncoder.encode("유효하지 않은 카테고리입니다. 카테고리를 추가해주세요","utf-8");
        response.sendRedirect(request.getContextPath()+"/board/insertBoard.jsp?msg="+msg);
        return;
    }
    
    //2) 게시글 추가 쿼리 insert into
	String boardSql = "INSERT into board(local_name, board_title, board_content, member_id, createdate, updatedate) value(?, ?, ?, ?, NOW(), NOW())";
	PreparedStatement BoardStmt = conn.prepareStatement(boardSql);
	BoardStmt.setString(1, localName);
	BoardStmt.setString(2, boardTitle);
	BoardStmt.setString(3, boardContent);
	BoardStmt.setString(4, loginMemberId);
	System.out.println(BoardStmt + " <--- insert Board action Stmt");

	// 추가 결과셋
	int row = BoardStmt.executeUpdate(); 
	if(row == 1) {  // 1 카운트 = 추가 성공
		System.out.println("게시물 추가 성공");
		msg = URLEncoder.encode("게시글 작성이 완료되었습니다","utf-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg="+msg);
	} else { // 실패시 폼 변화 없음
		System.out.println("게시물 추가 실패");
		msg = URLEncoder.encode("게시글 작성에 실패하였습니다.다시 시도해주세요.","utf-8");
		response.sendRedirect(request.getContextPath() + "/board/insertBoard.jsp?msg="+msg);
		return;
	}	

%>