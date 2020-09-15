using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Models.Generated.AutomationDB.Automation;
using Utilities;
using System.Web.Services;
using WebApp.Classes.Pages.Login;

namespace WebApp.Pages
{
    public partial class Login : System.Web.UI.Page
    {
        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            HttpContext.Current.Session["USER_ID"] = null;
        }

        #endregion
        #region WebMethods

        [WebMethod]
        public static string[] Check(string Info)
        {
            try
            {
                var User = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<CheckLogin>(Info);

                if (User.UserName.ToString() == null && User.Password.ToString() == null)
                    throw new Exception("تمام موارد را پر کنید");

                var UserInfo = Business.FacadeAutomation.GetUserBusiness().GetByUserName(User.UserName);
                var CheckWithDomain = System.Configuration.ConfigurationManager.AppSettings.Get("CheckUserFromDC").ToStringx();
                if (CheckWithDomain.ToBoolean() == true)
                {
                    if (DC.ActiveDirectoryBusiness.CheckUserFromDC)
                    {
                        var dc = new DC.ActiveDirectoryBusiness();
                        var isUserAuthenticate = dc.IsAuthenticateUser(User.UserName.ToStringx(), User.Password.ToStringx());
                        if (!isUserAuthenticate)
                            throw new Exception("نام کاربری یا رمز عبور اشتباه است");
                    }

                    if (UserInfo == null)
                    {
                        UserInfo = new Models.Generated.AutomationDB.Automation.User();
                        UserInfo.Username = User.UserName.ToStringx();
                        UserInfo.IsActive = true;
                        UserInfo.Save();
                    }
                }
                else
                {
                    if(UserInfo == null)
                        throw new Exception("نام کاربری صحیح نمی باشد");
                    if (UserInfo.Password != (User.Password + UserInfo.Salt).ToSHA256())
                        throw new Exception("رمز عبور صحیح نمی باشد");
                }


                HttpContext.Current.Session["USER_ID"] = UserInfo.ID;

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
