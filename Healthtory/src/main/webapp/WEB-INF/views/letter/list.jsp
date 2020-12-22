<%@page import="com.control.vo.LetterVO"%>
<%@page import="com.control.dao.LetterDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>쪽지 목록 | Healthtory</title>
	<link href="${pageContext.request.contextPath}/resources/css/index.css" rel="stylesheet" type="text/css">
	<link rel="shortcut icon" type="image⁄x-icon" href="${pageContext.request.contextPath}/resources/image/icon/icon.jpg">
	</head>	
	<%
		Object nick = session.getAttribute("NICKNAME");
		String nickname = (String)nick;%>
	<body>
		<!-- 네비게이션 시작 -->
			<%@ include file="../include/nav.jsp" %>
		<!-- 네비게이션 종료 -->
		
		<%
			//검색 단어
			String searchText=request.getParameter("search");//검색 값
	                                	
	        if(searchText==null){searchText="X";}
	        else if(searchText.equals("")){searchText="X";}
		%>
		<%--DAO, VO 선언 시작 --%>
			
		<%--DAO, VO 선언 종료 --%>
		
		<!-- 컨텐츠 시작 -->
		<section class="letter_section">
			<div class="letter_content">
				<div class="letter_menu_panel">
					<div class="top">
						<%
							if(request.getParameter("type")==null || request.getParameter("type").equals("receive")){
								%>
								<div class="selected" onclick="go_receive()"><span>받은 쪽지</span></div>
								<div onclick="go_send()"><span></span>보낸 쪽지</div>
								<%
							}
							else if(request.getParameter("type").equals("send")){
								%>
								<div onclick="go_receive()"><span>받은 쪽지</span></div>
								<div class="selected" onclick="go_send()"><span>보낸 쪽지</span></div>
								<%
							}
						%>
					</div>
					<div class="bottom">
						<% if(session.getAttribute("ID") != null) 
	                        {
	                        %>
	                        	<span class="go_write" onclick="go_write()">글쓰기 ▶</span>
	                        <%
	                        }else{
	                        %>
	                        	<span class="go_write" onclick="go_login()">글쓰기 ▶</span>
	                        <%} %>
					</div>
				</div>
				<div class="letter_list_panel">
					<header class="letter_list_header">
							<%
							if(request.getParameter("type")==null || request.getParameter("type").equals("receive")){
								%>
									<span>받은 쪽지</span>
								<%
							}
							else if(request.getParameter("type").equals("send")){
								%>
									<span>보낸 쪽지</span>
								<%
							}
							%>
						<div class="search_box">
                        	<form name="searchForm" class="searchForm">
                        	<% if(searchText.equals("X")){ %>
                        		<input type="text" name="search" class="search_box_text" value=""/>
                        	<%} else{ %>
                        		<input type="text" name="search" class="search_box_text" value="<%=searchText%>"/>
                        	<%} %>
                        		<div class="search_box_button" onclick="submit_searchForm()"><i class="fas fa-search"></i></div>
                        	</form>
              			 </div>
					</header>
					<main class="letter_list_main">
						<%
							if(request.getParameter("type")==null || request.getParameter("type").equals("receive")){
								%>
									<div class="letter_list_line_start">
										<div class="content"><span>내용</span></div>
										<div class="user"><span>보낸 사람</span></div>
										<div class="date"><span>전송 시각</span></div>
									</div>
									<%--DAO, VO 설정 시작 --%>
									<%
									LetterDAO dao = new LetterDAO();
						            LetterVO vo = new LetterVO();
						            
						            dao.selectReceiveLetter(nickname);
									//페이지설정부
							            String strPg = request.getParameter("pg"); //list.jsp?pg=?
							            int rowSize = 5; //한페이지에 보여줄 글의 수
							            int pg = 1; //페이지 , list.jsp로 넘어온 경우 , 초기값 =1
							            
							            if(strPg != null){ //list.jsp?pg=2
							            	pg = Integer.parseInt(strPg); //.저장
							            } 
							            
							            int from = (pg * rowSize) - (rowSize-1); //(1*10)-(10-1)=10-9=1 //from
							            int to=(pg * rowSize); //(1*10) = 10 //to
							            int total = dao.list.size();
							            if(total<to){to=total;};
							            
							            int allPage = (int) Math.ceil(total/(double)rowSize); //페이지수
							            //int totalPage = total/rowSize + (total%rowSize==0?0:1);
							            int block = 10; //한페이지에 보여줄  범위 << [1] [2] [3] [4] [5] [6] [7] [8] [9] [10] >>
							            
							            int fromPage = ((pg-1)/block*block)+1;  //보여줄 페이지의 시작
							            int toPage = ((pg-1)/block*block)+block; //보여줄 페이지의 끝
							            if(toPage> allPage){ // 예) 20>17
							            	toPage = allPage;
							            };
							            //페이지설정부
							            %>
									<%--DAO, VO 설정 종료 --%>
									<!-- 반복 시작 -->
									<% if(dao.list.size()==0) { %>
									<div class="letter_list_line">
										<span>등록된 글이 없습니다.</span>
									</div>
									<% }
				   					else {
				   						for(int i=from-1;i<to;i++){
											vo=dao.list.get(i);
									%>
									<div class="letter_list_line">
										<div class="content"><a href="./viewReceive?no=<%= vo.getNo() %>"><span><%= vo.getText() %></span></a></div>
										<div class="user"><span><%= vo.getFromnickname() %></span></div>
										<div class="date"><span><%= vo.getSigndate() %></span></div>
									</div>
									<%} %>
									<!-- 반복 종료 -->
									<footer class="community_list_page">
					<span>
						<%
								            if(pg>block){ //처음, 이전 링크
								       
								        		if(allPage>20){
										%>
								                [<a href="list?type=receive&pg=1">◀◀</a>]
								                <%
								                }
								                %>
								                [<a href="list?type=receive&pg=<%=fromPage-1%>">◀</a>] 
								        <%     
								            }
								            for(int i=fromPage; i<= toPage; i++){
								                if(i==pg){
								        %>         
								                    [<%=i%>]
								       
								        <%     
								                }else{
								        %>
								                    [<a href="list?type=receive&pg=<%=i%>"><%=i%></a>]
								        <%
								                }
								            }
								       
								        %>
								       
								       
								        <%
								            if(toPage<allPage){ //다음, 이후 링크
								       
								        %>
								                [<a href="list?type=receive&pg=<%=toPage+1%>">▶</a>]
								                <%if(allPage>20)
								                {
								                %>
								                	[<a href="list?type=receive&pg=<%=allPage%>">▶▶</a>]
								                <%
								                }
								                %>
								                       
								        <%     
								            }
								        %>
					</span>
				</footer>
								<%
									}
							}
							else if(request.getParameter("type").equals("send")){
								%>
									<div class="letter_list_line_start">
										<div class="content"><span>제목</span></div>
										<div class="user"><span>받는 사람</span></div>
										<div class="date"><span>전송 시각</span></div>
									</div>
									<%--DAO, VO 설정 시작 --%>
									<%
									LetterDAO dao = new LetterDAO();
						            LetterVO vo = new LetterVO();
						            
						            dao.selectSendLetter(nickname);
						            
						          //페이지설정부
						            String strPg = request.getParameter("pg"); //list.jsp?pg=?
						            int rowSize = 5; //한페이지에 보여줄 글의 수
						            int pg = 1; //페이지 , list.jsp로 넘어온 경우 , 초기값 =1
						            
						            if(strPg != null){ //list.jsp?pg=2
						            	pg = Integer.parseInt(strPg); //.저장
						            } 
						            
						            int from = (pg * rowSize) - (rowSize-1); //(1*10)-(10-1)=10-9=1 //from
						            int to=(pg * rowSize); //(1*10) = 10 //to
						            int total = dao.list.size();
						            if(total<to){to=total;};
						            
						            int allPage = (int) Math.ceil(total/(double)rowSize); //페이지수
						            //int totalPage = total/rowSize + (total%rowSize==0?0:1);
						            int block = 10; //한페이지에 보여줄  범위 << [1] [2] [3] [4] [5] [6] [7] [8] [9] [10] >>
						            
						            int fromPage = ((pg-1)/block*block)+1;  //보여줄 페이지의 시작
						            int toPage = ((pg-1)/block*block)+block; //보여줄 페이지의 끝
						            if(toPage> allPage){ // 예) 20>17
						            	toPage = allPage;
						            };
						            //페이지설정부
						            %>
										<%--
											보낸 쪽지에 대한 설정 (페이징 개수 : 5개)
										 --%>
									<%--DAO, VO 설정 종료 --%>
									<!-- 반복 시작 -->
									<% if(dao.list.size()==0) { %>
									<div class="letter_list_line">
										<span>등록된 글이 없습니다.</span>
									</div>
									<% }
				   					else {
				   						for(int i=from-1;i<to;i++){
											vo=dao.list.get(i);
									%>
									<div class="letter_list_line">
										<div class="content"><a href="./viewSend?no=<%= vo.getNo() %>"><span><%= vo.getText() %></span></a></div>
										<div class="user"><span><%= vo.getTonickname() %></span></div>
										<div class="date"><span><%= vo.getSigndate() %></span></div>
									</div>
									<%} %>
									<!-- 반복 종료 -->
									<footer class="community_list_page">
					<span>
						<%
								            if(pg>block){ //처음, 이전 링크
								       
								        		if(allPage>20){
										%>
								                [<a href="list?type=send&pg=1">◀◀</a>]
								                <%
								                }
								                %>
								                [<a href="list?type=send&pg=<%=fromPage-1%>">◀</a>] 
								        <%     
								            }
								            for(int i=fromPage; i<= toPage; i++){
								                if(i==pg){
								        %>         
								                    [<%=i%>]
								       
								        <%     
								                }else{
								        %>
								                    [<a href="list?type=send&pg=<%=i%>"><%=i%></a>]
								        <%
								                }
								            }
								       
								        %>
								       
								       
								        <%
								            if(toPage<allPage){ //다음, 이후 링크
								       
								        %>
								                [<a href="list?type=send&pg=<%=toPage+1%>">▶</a>]
								                <%if(allPage>20)
								                {
								                %>
								                	[<a href="list?type=send&pg=<%=allPage%>">▶▶</a>]
								                <%
								                }
								                %>
								                       
								        <%     
								            }
								        %>
					</span>
				</footer>
								<%
								}
							}
							%>
					</main>
				</div>
			</div>
		</section>
		<!-- 컨텐츠 종료 -->
		
		<script src="../../../resources/js/letter.js"></script>
		<script src="https://kit.fontawesome.com/34a8d510cf.js" crossorigin="anonymous" ></script>
	</body>
</html>