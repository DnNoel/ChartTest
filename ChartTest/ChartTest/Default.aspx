<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ChartTest.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="Label1" runat="server" Text="Token :"></asp:Label>
            &nbsp;<asp:Label ID="Label2" runat="server" Text=" "></asp:Label>
            </br>
            <asp:Button ID="Button1" runat="server" Text="GetToken" OnClick="Button1_Click" />
        </div>
    </form>
</body>
</html>
