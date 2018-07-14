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
    public partial class Chart : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetChart(string country)
        {
            string constr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                string query = string.Format("select shipcity, count(orderid) from orders where shipcountry = '{0}' group by shipcity", country);
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
                            string color = String.Format("#{0:X6}", new Random().Next(0x1000000));
                            sb.Append(string.Format("text :'{0}', value:{1}, color: '{2}'", sdr[0], sdr[1], color));
                            //sb.Append(string.Format("text :'{0}', value:{1}, color: '{2}', label: '{3}',value:{4}", sdr[0], sdr[1], color, color, sdr[1]));
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
    }
}