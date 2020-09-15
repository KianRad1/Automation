using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Models.Generated.AutomationDB.Automation;
using Newtonsoft.Json;
using Utilities;
using System.Web.UI;

namespace WebApp.Classes.Base
{
    public class BasePage : System.Web.UI.Page
    {
        private bool? _NeedLogin;
        private bool? _IsDefault;

        public bool NeedLogin
        {
            get
            {
                if (!_NeedLogin.HasValue)
                    return true;
                return _NeedLogin.Value;
            }
            set
            {
                _NeedLogin = value;
            }
        }
        public bool IsDefault
        {
            get
            {
                if (!_IsDefault.HasValue)
                    return false;
                return _IsDefault.Value;
            }
            set
            {
                _IsDefault = value;
            }
        }
        public string gref { get; set; }
        public string gid { get; set; }

        public static User CurrentUser
        {
            get
            {
                if (HttpContext.Current.Session == null || HttpContext.Current.Session["USER_ID"] == null)
                    return null;
                var UserID = HttpContext.Current.Session["USER_ID"].ToLong();
                return Business.FacadeAutomation.GetUserBusiness().GetByID(UserID);
            }
            set
            {
                HttpContext.Current.Session["USER_ID"] = value.ID;
            }
        }

        protected string GetImageName(object isSent)
        {
            try
            {
                if (isSent.ToBoolean())
                    return Constants.Images.Enable;
                else
                    return Constants.Images.Disable;
            }
            catch
            {
                throw;
            }
        }
        protected override void OnLoad(EventArgs e)
        {
            
            if (NeedLogin && CurrentUser == null)
            {
                HttpContext.Current.Response.Redirect("~/Pages/Login.aspx");
                return;
            }

            if (NeedLogin && CurrentUser != null && !IsDefault)
            {
                if (CurrentUser.IsManager == null)
                {
                    if (string.IsNullOrEmpty(this.gid))
                        throw new Exception("The Page Must Have GID");

                    var UserRolePrivilegeInfo = Business.FacadeAutomation.GetVwUserPrivilegeRoleBusiness().GetByUserIDAndGid(CurrentUser.ID, this.gid.ToGuid());
                    if (UserRolePrivilegeInfo == null)
                    {
                        ScriptManager.RegisterStartupScript(Page, Page.GetType(), Guid.NewGuid().ToString(), "ShowFailure()", true);
                        HttpContext.Current.Response.Redirect("~/Pages/Default.aspx");
                        return;
                    }
                }
            }
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), Guid.NewGuid().ToString(), "AddNameToAutomation('" + CurrentUser.Username + "');", true);
            base.OnLoad(e);

            if (CurrentUser.IsManager == false || CurrentUser.IsManager == null)
            {
                var UserRoleList = Business.FacadeAutomation.GetVwUserPrivilegeRoleBusiness().PrivilegeRoles.Where(r => r.UserID == CurrentUser.ID).Select(r => r.gid.ToString()).ToList();
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), Guid.NewGuid().ToString(), "showAccess('" + JsonConvert.SerializeObject(UserRoleList) + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), Guid.NewGuid().ToString(), "managerAccess()", true);
            }
        }
    }
}