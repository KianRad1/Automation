using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var LatestVersion = Business.FacadeAutomation.GetVersionChangesLogBusiness().GetLastVersion();
            LatestVersionNo.InnerText += LatestVersion;
        }
    }
}