using ChartTest.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChartTest
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string username = "admin@test.com";
            string password = "Password@2018";
            User user = new User();
            user = BusinessLogic.BusinessLogic.GetToken(username, password);
            string Token = user.access_token;
            Label2.Text = Token;

            if (Token != null)
            {
                Session["Token"] = Token;
                Response.Redirect("Default2.aspx");
            }
        }
    }
}