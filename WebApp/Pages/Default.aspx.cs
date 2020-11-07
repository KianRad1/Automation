using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApp.Classes.Base;
using WebApp.Classes.Pages.Privilage;
using Utilities;

namespace WebApp.Pages
{
    public partial class Default : BasePage
    {
        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {

            string Error = Request.QueryString["Error"];
            if (!string.IsNullOrEmpty(Error))
            {
                throw new Exception("Access Deny");
            }

            var UserInfo = Business.FacadeAutomation.GetUserBusiness().GetByID(CurrentUser.ID);
            if (UserInfo == null)
                throw new Exception("User Not Found");

            var VersionChanges = Business.FacadeAutomation.GetVersionChangesLogBusiness().GetLatestVersionChanges();
            if (VersionChanges.Count > 0)
            {
                for (int i = 0; i < VersionChanges.Count; i++)
                {
                    if (!(VersionChanges[i].VersionNo.IsNullOrEmpty() || VersionChanges[i].ChangesLog.IsNullOrEmpty()))
                    {
                        VersionChanges[i].ChangesLog = VersionChanges[i].ChangesLog.Replace("*", "<br /><br />");
                        if (i == 0)
                        {
                            VersionDiv.InnerHtml += "<div class='versionno latestversion' onclick='ShowVersionLog(this)'>" + VersionChanges[i].VersionNo + "\n (نسخه فعلی)</div><div class='versionlog'>" + VersionChanges[i].ChangesLog + "</div>";
                        }
                        else
                        {
                            VersionDiv.InnerHtml += "<div class='versionno' onclick='ShowVersionLog(this)'>" + VersionChanges[i].VersionNo + "</div><div class='versionlog'>" + VersionChanges[i].ChangesLog + "</div>";
                        }
                    }
                }
            }

            //lblName.Text= UserInfo.Name;
            //lblFamily.Text= UserInfo.Family;
            //lblUsername.Text = UserInfo.Username;
            //lblAddress.Text = UserInfo.Address;
            //lblEmail.Text = UserInfo.Email;
            //lblMobile.Text = UserInfo.Mobile;


            if (CurrentUser.Level == null || CurrentUser.RoleGroupID == null || CurrentUser.Name.IsNullOrEmpty() || CurrentUser.Family.IsNullOrEmpty())
            {
                hdfUser.Set("UserIsNull", true);
            }
        }

        #endregion

        #region WebMethod

        [WebMethod]
        public static string[] CheckPrivilage(string Info)
        {
            try
            {
                var PrivilegeInfo = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<List<Privilege>>(Info);

                string Message = "";
                bool IsNew = false;
                bool IsUpdate = false;

                foreach (var item in PrivilegeInfo)
                {
                    var OldPrivilege = Business.FacadeAutomation.GetPrivilegeBusiness().Privileges.FirstOrDefault(r => r.gid == item.gid.ToGuid());
                    if (OldPrivilege == null)
                    {
                        //Update And New
                        var MainPrivilege = Business.FacadeAutomation.GetPrivilegeBusiness().GetByGrefAndTitle(item.gref.ToNullableGuid(), item.title);
                        if (MainPrivilege == null)
                        {
                            var NewPrivilege = new Models.Generated.AutomationDB.Automation.Privilege()
                            {
                                gid = item.gid.ToGuid(),
                                gref = item.gref.ToNullableGuid(),
                                Title = item.title
                            };
                            NewPrivilege.Save();

                            IsNew = true;
                        }
                        else
                        {
                            MainPrivilege.gid = item.gid.ToGuid();
                            MainPrivilege.gref = item.gref.ToNullableGuid();
                            MainPrivilege.Title = item.title;
                            MainPrivilege.Save();

                            IsUpdate = true;
                        }

                    }
                    else
                    {
                        if (item.gref.ToGuid() != OldPrivilege.gref.ToGuid() || OldPrivilege.Title != item.title)
                        {
                            var MainPrivilege = Business.FacadeAutomation.GetPrivilegeBusiness().GetByGid(item.gid);
                            if (MainPrivilege == null)
                                throw new Exception("Privilege Not Found");

                            MainPrivilege.gid = item.gid.ToGuid();
                            MainPrivilege.gref = item.gref.ToNullableGuid();
                            MainPrivilege.Title = item.title;
                            MainPrivilege.Save();

                            IsUpdate = true;
                        }

                    }
                }

                if (IsUpdate || IsNew)
                {
                    Business.FacadeAutomation.GetPrivilegeBusiness().ResetPrivileges();
                    Business.FacadeAutomation.GetVwUserPrivilegeRoleBusiness().ResetUserRolePrivileges();
                    Message = "دسترسی ها به روز شد";
                }

                if (BasePage.CurrentUser.IsManager != null)
                    return new string[2] { "1", Message };

                return new string[2] { "1", "success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }

        //[WebMethod]
        //public static string[] CheckUserPrivilege(string )
        //{
        //    try
        //    {
        //        var UserRolePrivileges = Business.FacadeAutomation.GetVwUserPrivilegeRoleBusiness().PrivilegeRoles.Where(r => r.UserID == CurrentUser.ID);

        //        var json = JsonConvert.SerializeObject(UserRolePrivileges);


        //        return new string[2] { "1", json };
        //    }
        //    catch (Exception ex)
        //    {

        //        throw;
        //    }
        //}
        #endregion
    }
}