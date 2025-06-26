<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/my_post_comment.css?v=1.0" />

<div class="section-title">📄 내가 쓴 글</div>

<div class="post-wrapper">
	<c:forEach var="post" items="${postList}">
		<div class="post-box">
			<a href="ViewPostController?postId=${post.postId}" class="post-title">${post.title}</a>
			<div class="post-meta">
				${post.userId} |
				<fmt:formatDate value="${post.createdAt}" pattern="yyyy-MM-dd HH:mm" />
			</div>
		</div>
	</c:forEach>

	<c:if test="${empty postList}">
		<div class="post-box">작성한 글이 없습니다.</div>
	</c:if>
</div>

<!-- ✅ 페이지네이션 -->
<div class="pagination">
	<c:if test="${currentPage > 1}">
		<a href="javascript:void(0)" class="page-btn"
			onclick="loadMyPosts(${currentPage - 1})">&laquo; 이전</a>
	</c:if>

	<c:forEach var="i" begin="1" end="${totalPages}">
		<a href="javascript:void(0)" onclick="loadMyPosts(${i})"
			class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
	</c:forEach>

	<c:if test="${currentPage < totalPages}">
		<a href="javascript:void(0)" class="page-btn"
			onclick="loadMyPosts(${currentPage + 1})">다음 &raquo;</a>
	</c:if>
</div>
