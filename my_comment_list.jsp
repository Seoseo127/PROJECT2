<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/my_post_comment.css?v=1.0" />

<div class="section-title">💬 내가 쓴 댓글</div>

<div class="post-wrapper">
	<c:forEach var="comment" items="${commentList}">
		<div class="post-box">
			<a href="ViewPostController?postId=${comment.postId}"
				class="post-title"> ${comment.postTitle} </a>
			<div class="post-meta">
				${comment.userId} |
				<fmt:formatDate value="${comment.createdAt}"
					pattern="yyyy-MM-dd HH:mm" />
			</div>
			<div class="post-content">${comment.cContent}</div>
		</div>
	</c:forEach>

	<c:if test="${empty commentList}">
		<div class="post-box">작성한 댓글이 없습니다.</div>
	</c:if>
</div>

<!-- 페이징 -->
<div class="pagination">
	<!-- 페이지 버튼 -->
	<div class="pagination">
		<c:if test="${currentPage > 1}">
			<a href="javascript:void(0)" class="page-btn"
				onclick="loadMyComments(${currentPage - 1})">&laquo; 이전</a>
		</c:if>

		<c:forEach var="i" begin="1" end="${totalPages}">
			<a href="javascript:void(0)" onclick="loadMyComments(${i})"
				class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
		</c:forEach>

		<c:if test="${currentPage < totalPages}">
			<a href="javascript:void(0)" class="page-btn"
				onclick="loadMyComments(${currentPage + 1})">다음 &raquo;</a>
		</c:if>
	</div>
</div>