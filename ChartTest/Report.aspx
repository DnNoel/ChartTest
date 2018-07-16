<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Report.aspx.cs" Inherits="ChartTest.Report" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        body {
            font-family: Arial;
            font-size: 10pt;
        }
    </style>
</head>
<body>

    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.js" type="text/javascript"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.min.js" type="text/javascript"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.js" type="text/javascript"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.min.js" type="text/javascript"></script>
    <script  charset="utf8" src="//cdn.datatables.net/1.10.19/js/jquery.dataTables.js" type="text/javascript"></script>
    <link rel="stylesheet"  href="//cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" />
    <form id="form1" runat="server">
        <script type="text/javascript">
            $(function () {
                LoadChart();
                $("[id*=ddlCountries]").bind("change", function () {
                    LoadChart();
                });
                $("[id*=rblChartType] input").bind("click", function () {
                    LoadChart();
                });
                $("[id*=fromDate]").bind("change", function () {
                    LoadChart();
                });
                $("[id*=toDate]").bind("change", function () {
                    LoadChart();
                });
            });
            function LoadChart() {
                var chartType = parseInt($("[id*=rblChartType] input:checked").val());
                $.ajax({
                    type: "POST",
                    url: "Report.aspx/GetReportChart",
                    data: "{country: '" + $("[id*=ddlCountries]").val() + "',orderfromDate: '" + $("[id*=fromDate]").val() + "',ordertoDate: '" + $("[id*=toDate]").val() + "'}",
                    //labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (r) {
                        $("#dvChart").html("");
                        $("#dvLegend").html("");
                        var data = eval(r.d);
                        var aLabels = [];
                        var aValues = [];
                        var aColor = [];
                        var aDatasets1 = eval(r.d);

                        var DS1_BAR_COLOUR = 'rgba(248, 142, 40, 1)';
                        var DS2_BAR_COLOUR = 'rgba(41, 128, 185)';

                        for (var i = 0; i < data.length; i++) {                           
                            aLabels.push(data[i].text);
                            aValues.push(data[i].value);
                            aColor.push(data[i].color);
                        };
                        
                        var barOptions = {
                            legend: {
                                  labels: {
                                    generateLabels: function(chart) {
                                      labels = Chart.defaults.global.legend.labels.generateLabels(chart);
                                      labels[0].fillStyle = DS1_BAR_COLOUR;
                                      labels[1].fillStyle = DS2_BAR_COLOUR;
                                      return labels;
                                    }
                                  }
                                },
                            responsive: true,
                            maintainAspectRatio: true,
                            scales: {
                                yAxes: [{
                                    gridLines: {
                                        display: true
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Millions'
                                    },
                                    ticks: {
                                        beginAtZero: true
                                    }
                                }],
                                xAxes: [{
                                    gridLines: {
                                        display: true
                                    }
                                }],
                                
                            }
                        };

                        var data1 = {
                            labels: aLabels,                            
                            datasets: [{
                                label: "DEPT A",
                                data: aValues,
                                backgroundColor: DS1_BAR_COLOUR
                            },{
                                label: "DEPT B",
                                data: [2.5,1.5],
                                backgroundColor: DS2_BAR_COLOUR
                            }]
                        };

                        var el = document.createElement('canvas');
                        $("#dvChart")[0].appendChild(el);

                        //Fix for IE 8
                        if ($.browser.msie && $.browser.version == "8.0") {
                            G_vmlCanvasManager.initElement(el);
                        }
                        var ctx = el.getContext('2d');

                        var userStrengthsChart;

                        switch (chartType) {
                            case 1:
                                userStrengthsChart = new Chart(ctx, { type: 'bar', data: data1, options: barOptions })
                                break;  
                            //case 2:
                            //    userStrengthsChart = new Chart(ctx, { type: 'line', data: data1, options: barOptions })
                            //    break;   
                        }

                        for (var i = 0; i < data.length; i++) {
                            var div = $("<div />");
                            div.css("margin-bottom", "10px");
                            div.html("<span style = 'display:inline-block;height:10px;width:10px;background-color:" + data[i].color + "'></span> " + data[i].text);
                            $("#dvLegend").append(div);
                        }
                    },
                    failure: function (response) {
                        alert('There was an error.');
                    }
                });
            }
        </script>
        <script>
            $(document).ready( function () {
                $('#myTable').DataTable();
            } );
        </script>        

        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>Category:
                <asp:DropDownList ID="ddlCountries" runat="server">
                    <asp:ListItem Text="USA" Value="USA" />
                    <asp:ListItem Text="Germany" Value="Germany" />
                    <asp:ListItem Text="France" Value="France" />
                    <asp:ListItem Text="Brazil" Value="Brazil" />
                    <asp:ListItem Text="Venezuela" Value="Venezuela" />
                </asp:DropDownList>
                Select Date :
                    <asp:TextBox ID="txt_fromDate" Text="1996-07-22" runat="server"></asp:TextBox>
                    <asp:TextBox ID="txt_toDate" Text="1996-08-22" runat="server"></asp:TextBox>
                <asp:RadioButtonList ID="rblChartType" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblChartType_SelectedIndexChanged" AutoPostBack="true">
                    <asp:ListItem Text="Bar" Value="1" Selected="True" />
                    <asp:ListItem Text="List" />
                </asp:RadioButtonList>
                <div runat="server" id="btn_show_hide">
                    <asp:Button ID="btnExport" runat="server" Text="Export_PDF" OnClick="butExportPDF_Click" />
                    <asp:Button ID="Btn_SendMail" runat="server" onclick="Btn_SendMail_Click" Text="Send Email" />
                </div>
                </td>
            </tr>            
        </table>
        <div id="dvChart"></div>
        <div runat="server" id="theDiv">                   
                <span>Report Lists</span>
                <asp:ListView ID="lvReport" runat="server"  ItemPlaceholderID="itemPlaceHolder1"  >
                <LayoutTemplate>  
                    <table border="1" id="myTable" class="display">  
                        <thead>
                            <tr>  
                                <th>OrderID</th>  
                                <th>Ship City</th>  
                                <th>OrderDate</th>  
                                <th>ShipName</th>  
                                <th>ShipCountry</th>
                            </tr> 
                        </thead> 
                        <tbody>
                        <asp:PlaceHolder runat="server" ID="itemPlaceHolder1"></asp:PlaceHolder>  
                        </tbody>
                    </table>  
                </LayoutTemplate>  
                 
                <ItemTemplate>  
                    <tr>
                        <td>  
                        <%# Eval("OrderID") %>  
                    </td>  
                    <td>  
                        <%# Eval("ShipCity") %>  
                    </td>  
                    <td>  
                        <%# Eval("OrderDate") %>  
                    </td>  
                    <td>  
                        <%# Eval("ShipName") %>  
                    </td>  
                    <td>  
                        <%# Eval("ShipCountry") %>  
                    </td>
                    </tr>
                    
                </ItemTemplate>  
            </asp:ListView>             
        </div>
    </form>
</body>
</html>
