<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
body {
	font-family: 'Malgun Gothic', sans-serif;
	max-width: 600px;
	margin: 80px auto;
	padding: 0 20px;
}

h2 {
	text-align: center;
	margin-bottom: 40px;
}

.form-group {
	margin-bottom: 20px;
}

input[type="text"], select, textarea {
	width: 100%;
	padding: 10px;
	font-size: 14px;
	border: 1px solid #ccc;
	border-radius: 8px;
	box-sizing: border-box;
}

textarea {
	resize: vertical;
	height: 200px;
}

button {
	background-color: #333;
	color: white;
	border: none;
	padding: 10px 18px;
	border-radius: 8px;
	cursor: pointer;
	float: right;
}

button:hover {
	background-color: #555;
}

.clear {
	clear: both;
}
</style>
</head>
<body>

	<h2>📌 게시글 작성</h2>

	<!-- ✅ enctype은 여전히 필요 -->
	<form id="postForm" enctype="multipart/form-data">
		<div class="form-group">
			<input type="text" name="title" placeholder="제목을 입력하세요" required>
		</div>

		<div class="form-group">
			<select name="category">
				<option value="공부">공부</option>
				<option value="자유">자유</option>
			</select>
		</div>

		<div class="form-group">
			<textarea name="pContent" placeholder="내용을 입력하세요" required></textarea>
		</div>

		<div class="form-group">
			<input type="file" name="uploadFile" accept="image/*,video/*"><br>
			<br>
		</div>

		<button type="submit">등록</button>
		<div class="clear"></div>
	</form>

	<!-- ✅ AJAX + FormData 방식 -->
	<script>
		$("#postForm").on("submit", function(e) {
			e.preventDefault();

			const formData = new FormData(this);

			$.ajax({
				url : "updatePost.do",
				method : "POST",
				data : formData,
				processData : false,
				contentType : false,
				success : function() {
					alert("등록 성공!");
					location.href = "CommunityListController";
				},
				error : function() {
					alert("등록 실패 😢");
				}
			});
		});
	</script>

</body>
</html>