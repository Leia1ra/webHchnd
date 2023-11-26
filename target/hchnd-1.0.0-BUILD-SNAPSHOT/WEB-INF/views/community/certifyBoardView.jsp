<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<head>
	<!-- include libraries(jQuery, bootstrap) -->
	<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>

	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/community/css/certifyBaordViewStyle.css" type="text/css"/>
	<script src="<%=request.getContextPath()%>/resources/main/account.js"></script>
	<script>
		function boardDel() {
			if(confirm("글을 정말로 삭제하시겠습니까?")){
				location.href = "<%=request.getContextPath()%>/community/certifyDelete?no=${vo.no}&category=${vo.category}&imageName=${vo.imageName}"
			}
		}
		// ajax를 이용한 댓글 등록, 수정, 삭제, 목록
		$(function (){
			function heartPrint() {
				$.ajax({
					url:"<%=request.getContextPath()%>/community/heartCount",
					data: {
						articleNo :${vo.no},
						keyNo: '${vo.category}'
					}, type:"GET",
					success:function(result){
						console.log(result);
						document.getElementById("heartCount").innerHTML = "👍 : " + result;
						// $("#heartCount").html(result);
					}, error:function(e){
						console.log(e.responseText);
					}
				});
			}
			function heartState(){
				// var param = $(this).serialize();
				$.ajax({
					url:"<%=request.getContextPath()%>/community/heartState",
					data: {
						articleNo : ${vo.no},
						UID : '${logId}',
						keyNo : '${vo.category}'
					},
					type:"POST",
					success:function(result){
						let hbtn = document.getElementById("heartBtn")
						if(result){ // 아닌상태
							console.log("취소함");
							hbtn.style.border="1px solid white";
						} else { // 눌러진 상태
							console.log("눌러짐");
							hbtn.style.border="2px solid #FF9F29";
						}
					}, error:function(e){
						console.log(e.responseText);
					}
				});
			}
			// 좋아요 기능
			$("#heart").submit(function(){
				//form태그의 action을 중지한다.
				event.preventDefault();

				// form의 데이터를 query로 만들기
				var param = $(this).serialize();// 쿼리로 만들어줌
				// = "no=" + $("#no").val() + "&coment=" + $("#coment").val();

				$.ajax({
					url : "<%=request.getContextPath()%>/community/heart",
					data:param,
					type:"POST",
					success:function(result){
						if(result){
							heartState();
							heartPrint();
						} else {
							heartState();
							heartPrint();
						}
					}, error:function(e){
						console.log(e.responseText);
					}
				});
			});
			heartState();
			heartPrint();
		})
	</script>
</head>
<section id="container" onclick="hideAccount('${logStatus}')">
	<header id="MainHeader">
		<h2>${vo.categoryName}!</h2>
		<span></span>
	</header>
	<article id="mainArticle">
		<div id="writeForm">
			<div id="lside">
				<h3>인증 사진</h3>
				<img src="<%=request.getContextPath()%>/img/certifyBoard/${vo.imageName}" id="preview">
				<!--<input type="hidden" name="profileImgName" value="">-->
			</div>

			<div id="rside">
				<div id="viewInfo">
					<div id="pimgsize">
						<img src="<%=request.getContextPath()%>/img/userProfile/${writer.profileImgName}">
					</div>
					<div id="writerInfo">
						<span>작성자 : ${writer.nickname}</span>
						<div>
							<span>${vo.writeDate}</span> |
							<span>👀 : ${vo.hit}</span> |
							<span id="heartCount">👍 : </span> |
						</div>
					</div>
					<c:if test="${logStatus == 'Y'}">
						<form method="post" id="heart">
							<input type="hidden" name="articleNo" value="${vo.no}">
							<input type="hidden" name="UID" value="${logId}">
							<input type="hidden" name="keyNo" value="${vo.category}">
							<button id="heartBtn">👍</button>
						</form>
					</c:if>
				</div>
				<h2>${vo.subject}</h2>
				<div id="content">${vo.content}</div>
				<div id="certify-editable">
					<a href="<%=request.getContextPath()%>/board/list?nowPage=${pVO.nowPage}">목록</a>
					<c:if test="${logId == vo.UID}">
						<a href="<%=request.getContextPath()%>/community/certifyEdit?no=${vo.no}&category=${vo.category}">수정</a>
						<a href="<%=request.getContextPath()%>/community/certifyDelete?no=${vo.no}&category=${vo.category}&imageName=${vo.imageName}"
						   onclick="boardDel()">삭제</a>
					</c:if>
				</div>
			</div>
		</div>
	</article>
</section>

