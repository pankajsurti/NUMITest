<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="NUMITest.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Home</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        .container { max-width: 600px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .welcome { color: #333; }
        .btn-logout { padding: 8px 16px; background-color: #dc3545; color: white; text-decoration: none; border-radius: 4px; }
        .btn-logout:hover { background-color: #c82333; }
        .content { padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h1 class="welcome">Welcome, <asp:Label ID="lblUsername" runat="server"></asp:Label>!</h1>
                <a href="Logout.aspx" class="btn-logout">Logout</a>
            </div>
            <div class="content">
                <h2>Home Page</h2>
                <p>You are successfully authenticated and viewing the protected content.</p>
                <p>This page requires authentication to access.</p>
            </div>
        </div>
    </form>
</body>
</html>
