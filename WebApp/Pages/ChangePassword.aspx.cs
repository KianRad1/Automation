using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Utilities;
using WebApp.Classes.Base;
using WebApp.Classes.Pages.ChangePassword;

namespace WebApp.Pages
{
    public partial class ChangePassword : BasePage
    {
        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
        }
        #endregion
        #region WebMethods

        [WebMethod]
        public static string[] SaveInfo(string Info)
        {
            try
            {
                var User = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<WebApp.Classes.Pages.ChangePassword.ChangePassword>(Info);

                if (User.CurrentPassword.ToString() == null || User.NewPassword.ToString() == null || User.CheckPassword.ToString() == null)
                    throw new Exception("Entet All Fields");

                if (User.NewPassword.ToString() == User.CurrentPassword.ToString())
                    throw new Exception("Old Password and New Password Are Same");

                if (User.NewPassword.ToString() != User.CheckPassword.ToString())
                    throw new Exception("Passwords Doesnt Match");


                var HashCurrentPass = (User.CurrentPassword + CurrentUser.Salt).ToSHA256();
                if (HashCurrentPass != CurrentUser.Password)
                    throw new Exception("Current Password is Wrong");

                var userinfo = Business.FacadeAutomation.GetUserBusiness().GetByID(CurrentUser.ID);
                userinfo.Password = (User.NewPassword + CurrentUser.Salt).ToSHA256();
                userinfo.Save();

                return new string[2] { "1", "Success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        #endregion
    }
}