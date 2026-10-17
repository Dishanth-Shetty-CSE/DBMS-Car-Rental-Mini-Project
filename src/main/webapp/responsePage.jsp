<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>System Notification - DriveLux</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link rel="stylesheet" href="css/style.css">
</head>
<body style="background: #f8fafc; display: flex; align-items: center; justify-content: center; min-height: 100vh;">

<script>
    var status = "<%= request.getParameter("status") != null ? request.getParameter("status") : "info" %>";
    var message = "<%= request.getParameter("message") != null ? request.getParameter("message") : "Processing request..." %>";

    Swal.fire({
        icon: status === "success" ? "success" : (status === "error" ? "error" : "info"),
        title: status === "success" ? "Action Successful!" : "Notice",
        text: message,
        confirmButtonColor: "#2563eb",
        confirmButtonText: "Continue"
    }).then(() => {
        window.location.href = "customer-dashboard.jsp";
    });
</script>

</body>
</html>
