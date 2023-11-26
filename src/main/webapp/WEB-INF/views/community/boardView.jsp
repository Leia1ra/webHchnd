<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<script>
    function boardDel() {
        if(confirm("글을 정말로 삭제하시겠습니까?")){
            location.href = "<%=request.getContextPath()%>/community/delete?no=${vo.no}"
        }
    }

    // ajax를 이용한 댓글 등록, 수정, 삭제, 목록
    $(function (){
        // 목록
        function replyList(){
            $.ajax({
                url:"<%=request.getContextPath()%>/boardReply/list",
                data: {no : ${vo.no}},
                type: "GET",
                success : function (result) {
                    console.log(result);
                    var tag = ""; // 댓글 목록 태그 + 수정 삭제
                    $(result).each(function(i, rVO){
                        tag += "<li><div><b>"+ rVO.userid +"</b>(" + rVO.writedate +")";
                        if('${logId}' === rVO.userid){
                            // 변수로 취급해서 ''처리 해주어서 String 데이터로 만들어 주어야 함
                            tag += "<input type='button' value='Edit'/>";
                            tag += "<input type='button' value='Del' title='" + rVO.replyno + "'/>";
                            // 댓글 내용
                            tag += "<p class='reply'>"+rVO.coment+"</p></div>";

                            // 수정폼 -> 댓글 번호 ,댓글 내용이 적혀 잇음
                            tag += "<div style='display: none'><form method='post'>";
                            tag += "<input type='hidden' name='no' value='"+ rVO.no +"'>";
                            tag += "<input type='hidden' name='replyno' value='" + rVO.replyno + "'>"
                            tag += "<textarea name='coment' style='width: 400px;height: 80px'> " + rVO.coment + " </textarea>";
                            tag += "<input type='submit' value='댓글수정하기'>"
                            tag += "</div></form>";

                        } else {
                            tag += "<p>"+rVO.coment+"</p></div>";
                        }
                        tag += "</li>"
                    });
                    // document.getElementById("replyList").innerHTML = tag;
                    $("#replyList").html(tag);
                },error : function (e) {
                    console.log(e.responseText)
                }

            });
        }
        // 등록
        $("#replyForm").submit(function(){
            //form태그의 action을 중지한다.
            event.preventDefault();

            //coment 입력 확인
            if($("#coment").val() == ""){
                alert("댓글을 입력후 등록하세요");
                return false;
            }

            // form의 데이터를 query로 만들기
            var param = $(this).serialize();// 쿼리로 만들어줌
                   // = "no=" + $("#no").val() + "&coment=" + $("#coment").val();

            $.ajax({
                url : "<%=request.getContextPath()%>/boardReply/write",
                data:param,
                type:"POST",
                success:function(result){
                    console.log(result);
                    if(result == 0){
                        alert("댓글 작성이 실패하였습니다");
                    } else {
                        replyList();
                    }
                    $("#coment").val("");
                }, error:function(e){
                    console.log(e.responseText);
                }
            });
        });
        // 수정
        $(document).on('click', '#replyList input[value=Edit]', function () {
            $(this).parent().css('display', 'none');// 부모 숨기기 : 댓글 내용
            $(this).parent().next().css('display', 'block');
        });
        $(document).on('submit', '#replyList form', function () {
            event.preventDefault();
            var params = $(this).serialize();
            $.ajax({
                url : "<%=request.getContextPath()%>/boardReply/editOk",
                data:params,
                type:"POST",
                success:function(result){
                    if(result == 0){
                        alert("댓글 수정이 실패하였습니다.");
                    } else {
                        replyList();
                    }
                    console.log(result);
                }, error:function(e){
                    console.log(e.responseText);
                }
            });
        });
        // 삭제
             $(document).on('click','#replyList input[value=Del]',function(){
            if(confirm("삭제하시겠습니까?")){
               //삭제할 레코드 번호
               var replyno = $(this).attr("title");
               
               $.ajax({
                 url : "${pageContext.servletContext.contextPath}/boardReply/delete",
                 data : {
                    replyno:replayno
                 },
                 type:"GET",
                 success:function(result){
                    replyList(); //댓글목록 다시 뿌리기
                 },error:function(e){
                    console.log(e.responseText);
                 }
                 
               });
            }
        });


        /*목록 함수 호출*/
        replyList();
    })
</script>
<!-- <link rel="stylesheet" href="/hchnd/resources/community/css/commustyle.css" type="text/css"/> -->
<link rel="stylesheet" href="/hchnd/resources/community/css/post.css" type="text/css"/>
<!--배너 관련 코드-->
<link  href="https://cdnjs.cloudflare.com/ajax/libs/fotorama/4.6.4/fotorama.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/fotorama/4.6.4/fotorama.js"></script>
<!-- Banner -->
<div id="banner">
	<!--<b>NOTHING WILL WORK UNLESS<br/>YOU DO.</b>-->
    <div id="container">
    	<div class="main_visual">
        	<center>
            	<div class="fotorama" data-nav="false" data-width="800" data-height="200" data-max-width="100%" data-click='false' data-swipe='false'
            data-loop="true" data-autoplay="12000" data-stopautoplayontouch="false">
            		<div data-img="/hchnd/resources/community/img/AA.jpg"><a href="/" class="item" ></a></div>
                	<div data-img="/hchnd/resources/community/img/myproteinGYM.png"><a href="/" class="item" ></a></div>
                 </div>
            </center> 
        </div>
    </div>
</div>   


<main>
	<div class="left-content">
		<li id="top"><b>자유 게시판</b></li> 
		<div>
			<li class="writer">${vo.userid}</li>		
			<li class="information">${vo.writedate} | 👍 n | ✨ n | 👀 ${vo.hit} </li>	
			<li class="title">${vo.subject}</li>
			<li class="content">${vo.content }</li>		
		</div>
		
		<div class = "contentedit">
			<a href="/hchnd/community/list?nowpage=${pVO.nowPage}<c:if test="${pVO.searchWord!=null }">&searchKey=${pVO.searchKey}&searcWord=${pVO.searchWord }</c:if>">목록</a>
			<!-- 현재 글 작성자와 로그인 아이디가 같을 때만 가능 -->
			<c:if test="${vo.userid==logId }">
			<a href="/hchnd/community/edit?no=${vo.no}">수정</a>
			<a href="javascript:boardDel()">삭제</a>
			</c:if>
		</div>
		
		<div class="container">
       		<div class="post-box">      			
       			<!-- 로그인 상태일 때 글쓰기 -->
				<c:if test="${logStatus=='Y' }">
					<form method = "post" id="replyForm">
						<input type="hidden" name="no" value="${vo.no }">
		           		<textarea name="coment" id="coment" rows="8" cols="100" placeholder="댓글을 입력해주세요."></textarea>
		           		<button class="comment-button"><b>댓글<br>등록</b></button>
	           		</form>
	           	</c:if>
	           		
	           	<!-- 댓글목록 -->				
				<ul id="replyList" style="padding-left:0px;">
					<li>
						<div>
							<b>dorothy922</b>(2023-10-10 12:12:23)
							<input type="button" value="Edit"/>
							<input type="button" value="Del"/>
							<p>댓글 공부중...</p>
							
						</div>	
					</li>
				</ul>
        	</div>       		      		
    	</div>
	</div>
	
	<div class="right-content">
		<li id="hot"><b>인기글 +</b></li><hr>
		<li>운동 루틴 추천</li>
		<li>닭가슴살 맛있게 먹는 법</li>
		<li>헬창 옷장 구경하실?</li>
		<li>팔씨름 레전드</li>
		<li>형님들 3대 몇 치세요?</li>
		<hr><br/>
		<li><b>오.운.완 인증 +</b></li>
		<hr>
		<img src="/hchnd/resources/community/img/todayHealth.png">
		<img src="/hchnd/resources/community/img/todayHealth.png">
		<img src="/hchnd/resources/community/img/todayHealth.png">
		<img src="/hchnd/resources/community/img/todayHealth.png">
		<img src="/hchnd/resources/community/img/todayHealth.png">
		<img src="/hchnd/resources/community/img/todayHealth.png"> 
		<hr>
		<img src="/hchnd/resources/community/img/protein.jpg" style="width: 220px; height: 220px; margin-top:40px;">
	</div><br/>	
</main>