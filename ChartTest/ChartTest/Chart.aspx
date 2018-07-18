<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Chart.aspx.cs" Inherits="ChartTest.Chart" %>

<%--<!DOCTYPE html>--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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
    <%--  <script src="//cdn.jsdelivr.net/excanvas/r3/excanvas.js" type="text/javascript"></script>
    <script src="//cdn.jsdelivr.net/chart.js/0.2/Chart.js" type="text/javascript"></script>--%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.js" type="text/javascript"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.min.js" type="text/javascript"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.js" type="text/javascript"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.min.js" type="text/javascript"></script>
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
            });
            function LoadChart() {
                var chartType = parseInt($("[id*=rblChartType] input:checked").val());
                $.ajax({
                    type: "POST",
                    url: "Chart.aspx/GetChart",
                    data: "{country: '" + $("[id*=ddlCountries]").val() + "'}",
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

                        for (var i = 0; i < data.length; i++) {
                            aLabels.push(data[i].text);
                            aValues.push(data[i].value);
                            aColor.push(data[i].color);
                        };

                       // alert(aLabels);
                        //alert(aValues);
                        var barOptions = {
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
                                    }
                                }],
                                xAxes: [{
                                    gridLines: {
                                        display: true
                                    }
                                }]
                            }
                        };
                        var data1 = {
                            labels: aLabels,
                            datasets: [{
                               // label: '# of Votes',
                                data: aValues,
                                backgroundColor: aColor,
                                //backgroundColor: [
                                //    'rgba(255, 99, 132, 0.2)',
                                //    'rgba(54, 162, 235, 0.2)',
                                //    'rgba(255, 206, 86, 0.2)',
                                //    'rgba(75, 192, 192, 0.2)',
                                //    'rgba(153, 102, 255, 0.2)',
                                //    'rgba(255, 159, 64, 0.2)'
                                //],
                                borderColor: aColor,
                                //borderColor: [
                                //    'rgba(255,99,132,1)',
                                //    'rgba(54, 162, 235, 1)',
                                //    'rgba(255, 206, 86, 1)',
                                //    'rgba(75, 192, 192, 1)',
                                //    'rgba(153, 102, 255, 1)',
                                //    'rgba(255, 159, 64, 1)',
                                //    'rgba(255, 99, 132, 0.2)',
                                //    'rgba(54, 162, 235, 0.2)',
                                //    'rgba(255, 206, 86, 0.2)',
                                //    'rgba(75, 192, 192, 0.2)',
                                //    'rgba(153, 102, 255, 0.2)',
                                //    'rgba(255, 159, 64, 0.2)'
                                //],
                                borderWidth: 1
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
                                //userStrengthsChart = new Chart(ctx).Pie(data);
                                userStrengthsChart = new Chart(ctx, { type: 'pie', data: data1 })
                                break;
                            case 2:
                                //userStrengthsChart = new Chart(ctx).Doughnut(data);
                                userStrengthsChart = new Chart(ctx, { type: 'doughnut', data: data1})
                                break;
                            case 3:
                                //  userStrengthsChart = new Chart(ctx).Bar(data1);
                                userStrengthsChart = new Chart(ctx, { type: 'bar', data: data1, options: barOptions })
                                break;
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
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>Country:
                <asp:DropDownList ID="ddlCountries" runat="server">
                    <asp:ListItem Text="USA" Value="USA" />
                    <asp:ListItem Text="Germany" Value="Germany" />
                    <asp:ListItem Text="France" Value="France" />
                    <asp:ListItem Text="Brazil" Value="Brazil" />
                </asp:DropDownList>
                    <asp:RadioButtonList ID="rblChartType" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Text="Pie" Value="1" Selected="True" />
                        <asp:ListItem Text="Doughnut" Value="2" />
                        <asp:ListItem Text="Bar" Value="3" />
                    </asp:RadioButtonList>
                </td>
            </tr>
           <%-- <tr>
                <td></td>
                <td>
                    <div id="dvLegend">
                    </div>
                </td>
            </tr>--%>
        </table>
        <div id="dvChart">
        </div>
    </form>
</body>
</html>
