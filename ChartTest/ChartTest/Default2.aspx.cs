using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChartTest
{
    public partial class Default2 : System.Web.UI.Page
    {
        static string access_token;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Label2.Text = Session["Token"].ToString();
                access_token = Session["Token"].ToString();
            }



        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            lvbooks.DataSource = BusinessLogic.BusinessLogic.getBookList(access_token);
            lvbooks.DataBind();
        }
    }
}