using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChartTest
{
    public partial class Report : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetReportChart(string country,DateTime orderfromDate, DateTime ordertoDate)
        {
            string constr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                //string query = string.Format("select shipcity, count(orderid) from orders where shipcountry = '{0}' group by shipcity", country);
                string query = string.Format("select ShipCity, count(OrderID) from Orders where ShipCountry = '{0}' and OrderDate BETWEEN '{1}' and '{2}' Group By ShipCity",country,orderfromDate, ordertoDate);
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = query;
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = con;
                    con.Open();
                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append("[");
                        while (sdr.Read())
                        {

                            sb.Append("{");
                            System.Threading.Thread.Sleep(50);
                            //string color = String.Format("#{0:X6}", new Random().Next(0x1000000));
                            string color = String.Format("#{0:X6}", new Random().Next(0x1000000));
                            sb.Append(string.Format("text :'{0}', value:{1}, color: '{2}'", sdr[0], sdr[1], color));
                            sb.Append("},");
                        }
                        sb = sb.Remove(sb.Length - 1, 1);
                        sb.Append("]");
                        con.Close();
                        return sb.ToString();
                    }
                }
            }
        }

        protected void rblChartType_SelectedIndexChanged(object sender, EventArgs e)
        {
            string country = ddlCountries.SelectedItem.Text;
            DateTime fromdate = DateTime.Parse(txt_fromDate.Text);
            DateTime todate = DateTime.Parse(txt_toDate.Text);

            if (rblChartType.SelectedItem.Text == "List")
            {
                SqlConnection cn = new SqlConnection(@"Data Source=.;Initial Catalog=northwind;Integrated Security=True");
                string sql = string.Format("select OrderID,ShipCity, OrderDate,ShipName,ShipCountry, count(OrderID) from Orders where ShipCountry = '{0}' and OrderDate BETWEEN '{1}' and '{2}' Group By ShipCity,OrderID,OrderDate,ShipName,ShipCountry", country, fromdate, todate);
                //string sql = "select ShipCity, count(OrderID) from Orders where ShipCountry = '{0}' and OrderDate BETWEEN '{1}' and '{2}' Group By ShipCity", country, orderfromDate, ordertoDate;
                SqlCommand cmd = new SqlCommand(sql, cn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                lvReport.DataSource = dt;
                lvReport.DataBind();                
            }
        }
    }
}