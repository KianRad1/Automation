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
using WebApp.Classes.Pages.RoleGroup;

namespace WebApp.Pages
{
    public partial class RoleGroup : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var actions = new List<WebComponent.ComboBox.Actions>();
            actions.Add(new WebComponent.ComboBox.Actions() { gid = "3BCAB3FD-00B6-43F6-BEA3-DC4693693DC6", Title = "ویرایش" });
            cmbAction.SetActions(actions);
        }

        [WebMethod]
        public static string[] GetInfo(int Info)
        {
            try
            {
                var RoleGroupInfo = Business.FacadeAutomation.GetRoleGroupBusiness().GetByRoleGroupID(Info);
                if (RoleGroupInfo == null)
                    throw new Exception("RoleGroup Not Found");

                var json = JsonConvert.SerializeObject(RoleGroupInfo);

                return new string[2] { "1", json };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        [WebMethod]
        public static string[] SaveRoleGroup(string Info)
        {
            try
            {
                var RoleGroupInfo = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<RoleGroupModel>(Info);
                if (RoleGroupInfo.Title == null)
                    throw new Exception("عنوان گروه نقش وارد نشده است");
                var RoleGroup = Business.FacadeAutomation.GetRoleGroupBusiness().GetByRoleGroupID(RoleGroupInfo.ID);
                if(RoleGroup == null)
                {
                    RoleGroup = new Models.Generated.AutomationDB.Automation.RoleGroup();
                }
                if (RoleGroupInfo.ParentID != 0)
                    RoleGroup.ParentID = RoleGroupInfo.ParentID;
                RoleGroup.Title = RoleGroupInfo.Title;
                RoleGroup.Save();
                return new string[2] { "1", "Success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }
        }
        protected void treeList_CustomCallback(object sender, DevExpress.Web.ASPxTreeList.TreeListCustomCallbackEventArgs e)
        {
            try
            {
                treeList.UnselectAll();
            }
            catch (Exception ex)
            {
                throw;
            }
        }

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
    }
}