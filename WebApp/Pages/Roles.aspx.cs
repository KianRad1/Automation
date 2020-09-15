using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApp.Classes.Pages.Roles;
using Utilities;
using System.Collections;
using WebApp.Classes.Base;
using Newtonsoft.Json;

namespace WebApp.Pages
{
    public partial class Roles : BasePage
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
        #region TreeList
        protected void treeList_CustomCallback(object sender, DevExpress.Web.ASPxTreeList.TreeListCustomCallbackEventArgs e)
        {
            try
            {
                treeList.UnselectAll();

                var id = ((WebComponent.HiddenField)Page.Master.FindControl("hdfAction")).Get("ID").ToLong();

                if (id == 0)
                    return;

                var role = Business.FacadeAutomation.GetRoleBusiness().GetByRoleID(id.ToInt());
                var privilegeIds = Business.FacadeAutomation.GetRolePrivilegeBusiness().GetByRoleID(role.ID).Select(r => r.PrivilegeID).ToList();
                var gids = Business.FacadeAutomation.GetPrivilegeBusiness().Privileges.FindAll(r => privilegeIds.Contains(r.ID)).Select(r => r.gid).ToList();
                foreach (var item in gids)
                {
                    try
                    {
                        var node = treeList.FindNodeByKeyValue(item.ToString().Replace("-", string.Empty));
                        if (node == null)
                            continue;
                        node.Selected = true;
                    }
                    catch
                    {
                    }
                }
            }
            catch (Exception ex)
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
                var RoleInfo = Business.FacadeAutomation.GetRoleBusiness().GetByRoleID(Info);
                if (RoleInfo == null)
                    throw new Exception("Role Not Found");

                var json = JsonConvert.SerializeObject(RoleInfo);

                return new string[2] { "1", json };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        [WebMethod]
        public static string[] SaveRoles(string Info)
        {
            try
            {
                var RolesInfo = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<RoleModel>(Info);
                var Role = Business.FacadeAutomation.GetRoleBusiness().GetByRoleID(RolesInfo.RoleID);

                if (Role == null)
                {
                    Role = new Models.Generated.AutomationDB.Automation.Role();
                }
                else
                {
                    Business.FacadeAutomation.GetSPBusiness().SP_DeleteOldPrivilege(Role.ID);
                }

                Role.RoleName = RolesInfo.Title;
                Role.RoleLevel = RolesInfo.RoleLevel;
                Role.Save();

                var RolePrivilege = new List<Models.Generated.AutomationDB.Automation.RolePrivilege>();

                foreach (var item in RolesInfo.SelectedNodes)
                {
                    var ParrentPrivilege = new Models.Generated.AutomationDB.Automation.Privilege();
                    if (item.gref != null)
                    {
                        do
                        {
                            ParrentPrivilege = Business.FacadeAutomation.GetPrivilegeBusiness().Privileges.FirstOrDefault(r => r.gid == item.gref);

                            if (RolePrivilege.FirstOrDefault(r => r.PrivilegeID == ParrentPrivilege.ID) == null)
                            {
                                RolePrivilege.Add(new Models.Generated.AutomationDB.Automation.RolePrivilege()
                                {
                                    PrivilegeID = ParrentPrivilege.ID,
                                    RoleId = Role.ID
                                });
                            }
                        } while (ParrentPrivilege.gref != null);
                    }

                    if (RolePrivilege.FirstOrDefault(r => r.PrivilegeID == item.ID) == null)
                    {
                        RolePrivilege.Add(new Models.Generated.AutomationDB.Automation.RolePrivilege()
                        {
                            PrivilegeID = item.ID,
                            RoleId = Role.ID
                        });
                    }
                }

                foreach (var item in RolePrivilege)
                {
                    item.Insert();
                }
                Business.FacadeAutomation.GetPrivilegeBusiness().ResetPrivileges();
                Business.FacadeAutomation.GetVwUserPrivilegeRoleBusiness().ResetUserRolePrivileges();
                return new string[2] { "1", "Success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        #endregion
        #region Methods
        public void Search()
        {
            try
            {
                var Biz = Business.FacadeAutomation.GetRoleBusiness();
                var Entity = Biz.GetAll(300);
                if (!txtSearchRoleTitle.Text.IsNullOrEmpty())
                    Entity.And(Models.Generated.AutomationDB.Automation.Role.Columns.RoleName, Business.CompareFilter.Like, txtSearchRoleTitle.Text);
                if (!txtSearchRolePriority.Text.IsNullOrEmpty())
                    Entity.And(Models.Generated.AutomationDB.Automation.Role.Columns.RoleLevel, txtSearchRolePriority.Text);
                Entity.OrderBy(Models.Generated.AutomationDB.Automation.Role.Columns.ID, "ASC");
                gridView.DataSource = Biz.Fetch(Entity).ToList();
                gridView.DataBind();
            }
            catch
            {

                throw;
            }
        }
        #endregion
        #region GridView
        protected void gridView_BeforeColumnSortingGrouping(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewBeforeColumnGroupingSortingEventArgs e)
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
        #endregion
    }
}