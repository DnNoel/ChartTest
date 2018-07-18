<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default2.aspx.cs" Inherits="ChartTest.Default2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script
        src="https://code.jquery.com/jquery-3.3.1.min.js"
        integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
        crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" />
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="Label1" runat="server" Text="Token :"></asp:Label>
            &nbsp;<asp:Label ID="Label2" runat="server" Text=" "></asp:Label>
        </div>
        <br />
        <div>
            <asp:Button ID="Button1" runat="server" Text="Get Books" OnClick="Button1_Click" />
            <br />
            <br />
            <asp:ListView runat="server" ID="lvbooks">
                <LayoutTemplate>
                    <table class="table table-hover display" id="books">
                        <thead>
                            <tr>
                                <th class="danger">Book ID</th>
                                <th class="danger">Book Title</th>
                                <th class="danger">Category Name</th>
                                <th class="danger">ISBN</th>
                                <th class="danger">Author</th>
                                <th class="danger">Stock</th>
                                <th class="danger">Unit Price</th>
                            </tr>
                            <tbody>
                                <asp:PlaceHolder ID="itemPlaceHolder" runat="server" />
                            </tbody>
                        </thead>
                    </table>
           
                </LayoutTemplate>
                <ItemTemplate>
                    <tr>
                        <td class="active"><%#Eval("BookID")%></td>
                        <td class="active"><%#Eval("Title")%></td>
                        <td class="active"><%#Eval("CategoryName")%></td>
                        <td class="active"><%#Eval("ISBN")%></td>
                        <td class="active"><%#Eval("Author")%></td>
                        <td class="active"><%#Eval("Stock")%></td>
                        <td class="active"><%#:String.Format("{0:c}",Eval("Price"))%></td>
                    </tr>

                </ItemTemplate>
            </asp:ListView>
        </div>
    </form>
    <script>
        $(document).ready(function () {
            $('#books').DataTable();
        });
    </script>
</body>
</html>
