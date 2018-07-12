<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BarChart.aspx.cs" Inherits="ChartTest.BarChart" %>

<!DOCTYPE html>

<html>
    <canvas id="mybarChart1"></canvas>
    <body>
        <script type="text/javascript">
            $.getJSON("barchart.jason", function (data)
                    {
                        alert("here");
                        var ctx = document.getElementById("mybarChart1");
                        var myChart = new Chart(ctx, {
                            type: 'bar',
                            data: data,
                            options: {
                                scales: {
                                    yAxes: [{
                                        ticks: {
                                            beginAtZero: true
                                        }
                                    }]
                                }
                            }
                        });
                    });
        </script>
    </body>
</html>


