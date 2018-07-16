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
using iTextSharp.text.pdf;
using System.IO;
using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using System.Net.Mail;
using System.Net;

namespace ChartTest
{
    public partial class Report : System.Web.UI.Page
    {
        private string StrFileName { get; set; }
    
        protected void Page_Load(object sender, EventArgs e)
        {
            if (rblChartType.SelectedItem.Text == "Bar")
            {
                theDiv.Visible = false;
                btn_show_hide.Visible = false;
            }

            if (rblChartType.SelectedItem.Text == "List")
            {
                theDiv.Visible = true;
                btn_show_hide.Visible = true;
            }            
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
            DataTable dt = new DataTable();
            if (rblChartType.SelectedItem.Text == "List")
            {
                SqlConnection cn = new SqlConnection(@"Data Source=.;Initial Catalog=northwind;Integrated Security=True");
                string sql = string.Format("select OrderID,ShipCity, OrderDate,ShipName,ShipCountry, count(OrderID) from Orders where ShipCountry = '{0}' and OrderDate BETWEEN '{1}' and '{2}' Group By ShipCity,OrderID,OrderDate,ShipName,ShipCountry", country, fromdate, todate);                
                SqlCommand cmd = new SqlCommand(sql, cn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);

                da.Fill(dt);
                lvReport.DataSource = dt;
                lvReport.DataBind();
            }
        }        

        protected void butExportPDF_Click(object sender, EventArgs e)
        {
            DataTable dt = CreateTableSQL();

            dt.Columns.RemoveAt(5);
           
            if (dt.Rows.Count > 0)
            {
                PdfPTable pdfTable = new PdfPTable(5);

                pdfTable.WidthPercentage = 100;
                pdfTable.HorizontalAlignment = iTextSharp.text.Element.ALIGN_LEFT;
                pdfTable.DefaultCell.BorderWidth = 1;

                int[] widths = new int[] { 10, 15, 30, 30, 10};
                pdfTable.SetWidths(widths);

                StringBuilder strbldr = new StringBuilder();

                //Declare Header 
                PdfPCell cell = new PdfPCell(new iTextSharp.text.Phrase("Order"));
                cell.Colspan = 5;
                cell.FixedHeight = 70;
                cell.HorizontalAlignment = 1;
                cell.VerticalAlignment = 5;

                pdfTable.AddCell(cell);

                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    PdfPCell cell_order = new PdfPCell(new iTextSharp.text.Phrase(dt.Columns[j].ColumnName.ToString()));
                    cell_order.PaddingLeft = 5;
                    pdfTable.AddCell(cell_order);
                }

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    for (int k = 0; k < dt.Columns.Count; k++)
                    {
                        PdfPCell cell_CCAName_Value = new PdfPCell(new iTextSharp.text.Phrase(dt.Rows[i][k].ToString()));
                        cell_CCAName_Value.PaddingLeft = 5;
                        pdfTable.AddCell(cell_CCAName_Value);
                    }
                }

                string html = string.Empty;
                html += "<p style='font-family:verdana; font-size:23px; color:#5d7b9d'></p>";

                StrFileName = String.Empty;
                StrFileName = DateTime.Now.ToString("yyyyMMddHHmmss_") + "Order.pdf";
                if (Session["Downloadlink"] != null)
                {
                    Session["Downloadlink"]= null;
                }
                    Session["Downloadlink"] = StrFileName;

                //var output = new FileStream(Path.Combine("C:/AD/ChartTest/ChartTest/pdfFile", StrFileName), FileMode.Create);
                //var output = new FileStream(Server.MapPath("~/pdfFile", StrFileName), FileMode.Create);
                //Response.AddHeader("Content-Disposition", "attachment; filename=" + imgURLtoDownload);

                //String imgURLtoDownload = "~/pdfFile/"+ StrFileName;
                
                using (StringWriter sw = new StringWriter())
                {
                    using (HtmlTextWriter hw = new HtmlTextWriter(sw))
                    {
                        StringReader sr = new StringReader(html);
                        Document pdfDoc = new Document(PageSize.A2, 10f, 10f, 10f, 0f);
                        HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
                        PdfWriter.GetInstance(pdfDoc, Response.OutputStream);
                        WebClient req = new WebClient();

                        pdfDoc.Open();
                        htmlparser.Parse(sr);
                        pdfDoc.Add(pdfTable);
                        pdfDoc.Close();
                        Response.ContentType = "application/pdf";
                        Response.AddHeader("content-disposition", string.Format("attachment; filename={0}", StrFileName));
                        Response.Cache.SetCacheability(HttpCacheability.NoCache);
                        Response.Write(pdfDoc);
                        Response.End();

                    }
                }
            }
        }
        private DataTable CreateTableSQL()
        {
            string country = ddlCountries.SelectedItem.Text;
            DateTime fromdate = DateTime.Parse(txt_fromDate.Text);
            DateTime todate = DateTime.Parse(txt_toDate.Text);
            DataTable dt = new DataTable();
            if (rblChartType.SelectedItem.Text == "List")
            {
                SqlConnection cn = new SqlConnection(@"Data Source=.;Initial Catalog=northwind;Integrated Security=True");
                string sql = string.Format("select OrderID,ShipCity, OrderDate,ShipName,ShipCountry, count(OrderID) from Orders where ShipCountry = '{0}' and OrderDate BETWEEN '{1}' and '{2}' Group By ShipCity,OrderID,OrderDate,ShipName,ShipCountry", country, fromdate, todate);               
                SqlCommand cmd = new SqlCommand(sql, cn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
      
                da.Fill(dt);
                lvReport.DataSource = dt;
                lvReport.DataBind();
            }

            return dt;

        }

        protected void Btn_SendMail_Click(object sender, EventArgs e)
        {
            MailMessage msg = new MailMessage();
            msg.From = new MailAddress("noelsa46@gmail.com");
            msg.To.Add("dnnoelsue90@gmail.com");
            msg.Subject = "Auto Sending Information";
            msg.Body = "Test Content with NUS mail";
            if (Session["Downloadlink"] != null)
            {
                Attachment at = new Attachment(Server.MapPath("~/pdfFile/" + Session["Downloadlink"].ToString()));

                msg.Attachments.Add(at);
            }
            msg.Priority = MailPriority.High;

            SmtpClient client = new SmtpClient();
            client.UseDefaultCredentials = false;
            client.Credentials = new NetworkCredential("noelsa46@gmail.com", "noelsa462018");
            client.Host = "smtp.gmail.com";
            //client.Host = "smtp.office365.com";
            client.Port = 587;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.EnableSsl = true;
            client.Send(msg);
        }
    }
}