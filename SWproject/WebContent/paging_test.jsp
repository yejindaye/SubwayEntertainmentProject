<%@ page import="java.sql.*"%>
<jsp:useBean id="DB" class="beans.JavaBeans" scope="page"/>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>Festival Metro</title>

        <!-- Bootstrap core CSS -->
        <link href="css/bootstrap.css" rel="stylesheet">

        <!-- Add custom CSS here -->
        <link href="css/style.css" rel="stylesheet">
        <link href="font-awesome/css/font-awesome.min.css" rel="stylesheet">
        <link href='http://fonts.googleapis.com/css?family=Lato' rel='stylesheet' type='text/css'>
        <link href='http://fonts.googleapis.com/css?family=Lobster' rel='stylesheet' type='text/css'>
		
<style>
		.btn1{
  background-color: white;
  border: none;
  color: black;
  padding: 15px 32px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 20px;
  border-radius:10px;
  width:30px;
  height:38px;
	}
    footer{
	background-color:#E8F5FF;
	}
		.btn2{
  background-color: white;
  border: none;
  color: black;
  font-size: 20px;
  height:38px;
	}

</style>
    </head>

    <body>
  		<%@ include file = "sidemenubar.jsp" %>
  		
        <!-- Portfolio -->
        <div id="places" class="places">
            <div class="container">
				<table width="100%">
						<tr>
							<td><p algn="left"><a href="main.jsp"><button type="button" class="btn1">before</button></a></p></td>
							<td><p align="right"><a href="theme.jsp"><button type="button" class="btn1">next</button></a></p></td>
						</tr>
					</table>
                <div class="row">
                    <div class="col-md-4 col-md-offset-4 text-center">
                        <h2 class="main-title">호선별 즐길거리</h2>
                        <hr>
                    </div>
                </div>
            </div>  
            <div class="divide50"></div>  
            <div class="container">
				<table width = "100%">
					<tr>
						<td><button type="button" class="btn2" onclick="location.href='line.jsp'">전체</button></td>	
						<% for(int i=1;i<=9;i++){ %>
						<td><button type="button" class="btn2" onclick="location.href='line.jsp?id=<%=i%>'">#<%=i %>호선</button></td>
						<%}%>				
					</tr>
				</table>
				<%
					
		  			final int ROWSIZE=10; // 한페이지에 보일 게시물 수
		  			final int BLOCK=5; // 아래에 보일 페이지 최대 개수 1~5 / 6~10 
		  			int pg=1; // 기본 페이지 값
		  			if(request.getParameter("pg")!=null){ // 다른 페이지 일 때
		  				pg= Integer.parseInt(request.getParameter("pg"));
		  			}
		  			int start=(pg*ROWSIZE)-(ROWSIZE-1);
		  			int end=(pg*ROWSIZE);
		  			int allPage=0;
		  			int startPage = ((pg-1)/BLOCK*BLOCK)+1; // 시작블럭숫자 (1~5페이지일경우 1, 6~10일경우 6)
		  			int endPage = ((pg-1)/BLOCK*BLOCK)+BLOCK; // 끝 블럭 숫자 (1~5일 경우 5, 6~10일경우 10)
		  			int total=0;
		  		%>
				<div class="row">
				<%
		  			
					int id=0;
					String name="", station="", img="", line="";
					Connection conn=null;
					Statement stmt=null;
					ResultSet rs=null;
					String sql="";
					request.setCharacterEncoding("utf-8");
					
					sql="select count(*) as cnt from attraction";
					rs=DB.getResult(sql);
					while(rs.next()){
						total=rs.getInt("cnt");
					}
					rs.close();
					allPage=(int)Math.ceil(total/(double)ROWSIZE);
					if(endPage>allPage){
						endPage=allPage;
					}
					if(request.getParameter("id")!=null){
						id=Integer.parseInt(request.getParameter("id"));
						sql="select a.name, a.img, a.station, s.line from attraction a, station2 s, subwayLine l where a.station=s.name and s.line=l.line_num and l.line_num like '%"+id+"%' and (id between "+start+"and "+end+") order by a.name";

					}
					else{
						sql="select a.name, a.img, a.station, s.line from attraction a, station2 s, subwayLine l where a.station=s.name and s.line=l.line_num and (id>= "+start+" and id <= "+end+") order by a.name";
					}
					rs=DB.getResult(sql);
					if(rs==null){
						out.println("DB연동 오류");
					}
					while(rs.next()){
						name=rs.getString("name");
						station=rs.getString("station");
						img=rs.getString("img");
						line=rs.getString("line");
					%>
					<!-- DB에서 불러오기 -->
					<div class="col-md-6 col-sm-12 col-xs-12">
                        <div class="grid center-block">
                            <figure class="effect-zoe">
                                <img src="<%=img %> " class="img-responsive center-block" style="width:800px;height:400px;">
                                <figcaption>
                                    <h2><%=name %> </h2>
                                    <p class="description"><%=line%>호선 &nbsp<%=station %>역</p>
                                </figcaption>           
                            </figure>
                        </div>
                    </div>
					<% }%>
					<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr><td colspan="4" height="5"></td></tr>
  <tr>
	<td align="center">
		<%
			if(pg>BLOCK) {
		%>
			[<a href="paging_test.jsp?pg=1">◀◀</a>]
			[<a href="paging_test.jsp?pg=<%=startPage-1%>">◀</a>]
		<%
			}
		%>
		
		<%
			for(int i=startPage; i<= endPage; i++){
				if(i==pg){
		%>
					<u><b>[<%=i %>]</b></u>
		<%
				}else{
		%>
					<a href="paging_test.jsp?pg=<%=i %>">[<%=i %>]</a>
		<%
				}
			}
		%>
		
		<%
			if(endPage<allPage){
		%>
			[<a href="paging_test.jsp?pg=<%=endPage+1%>">▶</a>]
			[<a href="paging_test.jsp?pg=<%=allPage%>">▶▶</a>]
		<%
			}
		%>
		</td>
		</tr>
		  <tr align="center">
  </tr> 
</table>



				</div>
			</div>
		</div>
        <!-- Footer -->
        <footer>
            <div class="container">
                <div class="row">
                    <div class="col-md-6 col-md-offset-3 text-center">
                        <ul class="list-inline">
                           
                        </ul>
                        <hr>
                        <p>Copyright &copy; <a href="https://github.com/Minjoo-L/SWProject"><font color=black>software_project 세일러문조</font></a>  2019</p>
                        <div class="top-scroll">
                            <a href="#top"><i class="fa fa-arrow-circle-up scroll"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </footer>
        <!-- /Footer -->

        <!-- JavaScript -->
        <script src="js/jquery-1.10.2.js"></script>
        <script src="js/bootstrap.js"></script>
        <script type="text/javascript" src="js/jquery.parallax-1.1.3.js"></script>

        <!-- Custom JavaScript for the Side Menu and Smooth Scrolling -->
        <script>
        $("#menu-close").click(function(e) {
            e.preventDefault();
            $("#sidebar-wrapper").toggleClass("active");
        });
        </script>
        <script>
        $("#menu-toggle").click(function(e) {
            e.preventDefault();
            $("#sidebar-wrapper").toggleClass("active");
        });
        </script>
        <script>
        $(function() {
            $('a[href*=#]:not([href=#])').click(function() {
                if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') || location.hostname == this.hostname) {
                    var target = $(this.hash);
                    target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
                    if (target.length) {
                        $('html,body').animate({
                            scrollTop: target.offset().top
                        }, 1000);
                        return false;
                    }
                }
            });
        });
        </script>

        <!-- modal -->

        <script>
            $('.modal').on('shown.bs.modal', function () {
                var curModal = this;
                $('.modal').each(function(){
                    if(this != curModal){
                        $(this).modal('hide');
                    }
                });
            });
        </script>

    </body>
</html>