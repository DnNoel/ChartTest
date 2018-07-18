<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="ChartTest.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:ListView runat="server" ID="lvorder">
        <LayoutTemplate>
            <table class="table text-info">
                <thead>
                    <th class="active">Book ID</th>
                    <th class="active">Book Title</th>
                    <th class="active">Quantity</th>
                    <th class="active">Unit Price</th>

                    <tr>
                        <asp:PlaceHolder ID="itemPlaceHolder" runat="server" />
                    </tr>
                </thead>
            </table>
            <%-- <div class="pagination" style="padding-left: 40%; padding-top: -10%">
                                        <asp:DataPager runat="server" ID="orderpager" PagedControlID="lvorder" class="btn-group btn-group-sm" PageSize="10">
                                            <Fields>
                                                <asp:NextPreviousPagerField PreviousPageText="<" ShowPreviousPageButton="true"
                                                    ShowFirstPageButton="true" ShowNextPageButton="false" FirstPageText="|<" ShowLastPageButton="false"
                                                    ButtonCssClass="btn btn-default" RenderNonBreakingSpacesBetweenControls="false" RenderDisabledButtonsAsLabels="false" />
                                                <asp:NumericPagerField ButtonType="Link" CurrentPageLabelCssClass="btn btn-success disabled" RenderNonBreakingSpacesBetweenControls="false"
                                                    NumericButtonCssClass="btn btn-default" ButtonCount="10" NextPageText="..." NextPreviousButtonCssClass="btn btn-default" />
                                                <asp:NextPreviousPagerField NextPageText=">" LastPageText=">|" ShowNextPageButton="true"
                                                    ShowLastPageButton="true" ShowPreviousPageButton="false" ShowFirstPageButton="false"
                                                    ButtonCssClass="btn btn-default" RenderNonBreakingSpacesBetweenControls="false" RenderDisabledButtonsAsLabels="false" />
                                            </Fields>
                                        </asp:DataPager>
                                    </div>--%>
        </LayoutTemplate>
        <ItemTemplate>
            <tbody>
                <td class="active"><%#Eval("bkID")%></td>
                <td class="active"><%#Eval("bkTitle")%></td>
                <td class="active"><%#Eval("orderQty")%></td>
                <td class="active"><%#:String.Format("{0:c}",Eval("unitPrice"))%></td>


            </tbody>
        </ItemTemplate>
    </asp:ListView>
        </div>
    </form>
</body>
</html>
