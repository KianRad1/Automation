using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using WebApp.Classes.Pages.Users;
using Newtonsoft.Json;
using Utilities;
using WebApp.Classes.Base;

namespace WebApp.Pages
{
    public partial class Users : BasePage
    {
        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            var actions = new List<WebComponent.ComboBox.Actions>();
            actions.Add(new WebComponent.ComboBox.Actions() { gid = "3BCAB3FD-00B6-43F6-BEA3-DC4693693DC6", Title = "ویرایش" });
            cmbAction.SetActions(actions);
        }
        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                base.OnPreRender(e);
                Search();

            }
            catch (Exception ex)
            {
                throw;
            }
        }
        #endregion
        #region Methods
        public void Search()
        {
            try
            {
                var Biz = Business.FacadeAutomation.GetUserBusiness();
                var Entity = Biz.GetAll(300);

                if (!txtSearchUsername.Text.IsNullOrEmpty())
                    Entity.And(Models.Generated.AutomationDB.Automation.User.Columns.Username, Business.CompareFilter.Like, txtSearchUsername.Text);
                if (!txtSearchName.Text.IsNullOrEmpty())
                    Entity.And(Models.Generated.AutomationDB.Automation.User.Columns.Name, Business.CompareFilter.Like, txtSearchName.Text);
                if (!txtSearchFamily.Text.IsNullOrEmpty())
                    Entity.And(Models.Generated.AutomationDB.Automation.User.Columns.Family, Business.CompareFilter.Like, txtSearchFamily.Text);
                if (!txtSearchEmail.Text.IsNullOrEmpty())
                    Entity.And(Models.Generated.AutomationDB.Automation.User.Columns.Email, Business.CompareFilter.Like, txtSearchEmail.Text);
                if (!txtSearchAddress.Text.IsNullOrEmpty())
                    Entity.And(Models.Generated.AutomationDB.Automation.User.Columns.Address, Business.CompareFilter.Like, txtSearchAddress.Text);
                if (!txtSearchMobile.Text.IsNullOrEmpty())
                    Entity.And(Models.Generated.AutomationDB.Automation.User.Columns.Mobile, Business.CompareFilter.Like, txtSearchMobile.Text);

                var DBUsers = Biz.Fetch(Entity).ToList();
                var dc = new DC.ActiveDirectoryBusiness();
                var DomianUserList = dc.GetDomainUsers();

                foreach (var item in DomianUserList)
                {
                    var UserExistInDB = DBUsers.FirstOrDefault(r => r.Username == item);
                    if (UserExistInDB == null)
                    {
                        Models.Generated.AutomationDB.Automation.User NewUser = new Models.Generated.AutomationDB.Automation.User
                        {
                            ID = 0,
                            Username = item,
                            IsActive = true
                        };
                        DBUsers.Add(NewUser);
                    }
                }


                Entity.OrderBy(Models.Generated.AutomationDB.Automation.User.Columns.ID, "ASC");
                gridView.DataSource = DBUsers;
                gridView.DataBind();
            }
            catch
            {

                throw;
            }
        }
        #endregion
        #region WebMethods
        [WebMethod]
        public static string[] GetInfo(int Info)
        {
            try
            {
                var UserInfo = Business.FacadeAutomation.GetUserBusiness().GetByID(Info);
                //if (UserInfo == null)
                //    throw new Exception("User Not Found");
                string RoleID = null;
                if (UserInfo != null)
                {
                    var UserRole = Business.FacadeAutomation.GetUserRoleBusiness().GetByUserID(UserInfo.ID);
                    if (UserRole != null)
                        RoleID = UserRole.RoleID.ToString();
                }
                var json = JsonConvert.SerializeObject(UserInfo);

                return new string[3] { "1", json, RoleID };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        [WebMethod]
        public static string[] SaveInfo(string Info)
        {
            try
            {
                var User = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<UserInfo>(Info);

                if (string.IsNullOrEmpty(User.UserName.ToString()))
                    throw new Exception("Enter All Requierd Fields");
                if (User.RoleGroupID == 0)
                    throw new Exception("Enter RoleGroup");

                var UserInfo = Business.FacadeAutomation.GetUserBusiness().GetByID(User.ID.ToLong());
                if (UserInfo == null)
                    UserInfo = new Models.Generated.AutomationDB.Automation.User();

                var level = Business.FacadeAutomation.GetLevelBusiness().GetByID(User.Level.Value);
                if (level == null)
                    throw new Exception("Enter Level Correctly");

                var RoleGroup = Business.FacadeAutomation.GetRoleGroupBusiness().GetByRoleGroupID(User.RoleGroupID.ToLong());
                if (RoleGroup == null)
                    throw new Exception("Enter RoleGroup Correctly");

                if (!User.RoleID.HasValue || User.RoleID.Value == 0)
                    throw new Exception("Enter Role Correctly");
                else
                {
                    var RoleInfo = Business.FacadeAutomation.GetRoleBusiness().GetByRoleID(User.RoleID.Value);
                    if (RoleInfo == null)
                        throw new Exception("Role Not Found");
                }

                if (UserInfo.ID == 0)
                {
                    if (string.IsNullOrEmpty(User.UserName.ToString()))
                        throw new Exception("Enter All Requierd Fields");
                    UserInfo.Username = User.UserName;
                }

                UserInfo.Username = User.UserName;
                if (level != null)
                    UserInfo.Level = level.ID;
                if (User.Name != null)
                    UserInfo.Name = User.Name;
                if (User.Family != null)
                    UserInfo.Family = User.Family;
                UserInfo.Email = User.Email;
                UserInfo.Address = User.Address;
                UserInfo.Mobile = User.Mobile;
                UserInfo.RoleGroupID = User.RoleGroupID;
                UserInfo.IsActive = true;
                UserInfo.Save();

                Business.FacadeAutomation.GetSPBusiness().SP_DeleteOldRoles(UserInfo.ID);
                var UserRole = new Models.Generated.AutomationDB.Automation.UserRole()
                {
                    RoleID = User.RoleID.Value,
                    UserID = UserInfo.ID
                };
                UserRole.Save();
                Business.FacadeAutomation.GetVwUserPrivilegeRoleBusiness().ResetUserRolePrivileges();

                return new string[2] { "1", "Success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        #endregion
        #region GridView
        protected void gridView_CustomCallback(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs e)
        {
            try
            {
                Search();
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        protected void gridView_PageIndexChanged(object sender, EventArgs e)
        {
            try
            {
                Search();
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        protected void gridView_BeforeColumnSortingGrouping(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewBeforeColumnGroupingSortingEventArgs e)
        {
            try
            {
                Search();
            }
            catch (Exception)
            {

                throw;
            }
        }

        #endregion
        #region TreeList
        protected void newTreeList_CustomCallback(object sender, DevExpress.Web.ASPxTreeList.TreeListCustomCallbackEventArgs e)
        {
            try
            {
                newTreeList.UnselectAll();
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        #endregion


    }
}