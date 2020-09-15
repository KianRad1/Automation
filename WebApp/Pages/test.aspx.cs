using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApp.Classes.Base;

namespace WebApp.Pages
{
    public partial class test : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static void TestF()
        {
            string d = ";";
            d = "tt";
        }
    }
}