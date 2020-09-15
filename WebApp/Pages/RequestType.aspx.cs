using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using Newtonsoft.Json;
using Utilities;
using WebApp.Classes.Base;
using WebApp.Classes.Pages.RequestType;

namespace WebApp.Pages
{
    public partial class ResquestType : BasePage
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
        #region WebMethods
        [WebMethod]
        public static string[] GetInfo(int Info)
        {
            try
            {
                var RequestInfo = Business.FacadeAutomation.GetVwRequestTypeDetailBusiness().GetByTypeID(Info);
                if (RequestInfo == null)
                    throw new Exception("نوع درخواست پیدا نشد");

                var json = JsonConvert.SerializeObject(RequestInfo);

                return new string[2] { "1", json };
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
                var Req = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<RequestTypeInfo>(Info);
                if (Req.Items == null)
                    throw new Exception("ترتیب درخواست وارد نشده است");
                if (Req.Importance == 0)
                    throw new Exception("اهمیت درخواست وارد نشده است");
                if (Req.RequestModelID == 0)
                    throw new Exception("نوع درخواست وارد نشده است");
                if (Business.FacadeAutomation.GetRequestModelBusiness().GetByID(Req.RequestModelID) == null)
                    throw new Exception("نوع درخواست صحیح نمی باشد");

                Business.FacadeAutomation.GetSPBusiness().SP_DeleteOldTypeDetails(Req.TypeID);
                var NewRequestType = Business.FacadeAutomation.GetRequestTypeBusiness().GetByID(Req.TypeID);
                if (NewRequestType == null)
                {
                    NewRequestType = new Models.Generated.AutomationDB.Automation.RequestType();
                }
                NewRequestType.RequestModelID = Req.RequestModelID;
                NewRequestType.Importance = Req.Importance;
                NewRequestType.Save();

                for (int i = 0; i < Req.Items.Length; i++)
                {
                    var NewRequest = new Models.Generated.AutomationDB.Automation.RequestTypeDetail();
                    if (!(i == 0 && Req.Items[i] == "*"))
                    {
                        var RoleGroupID = Req.Items[i].Split(',')[0].ToLong();
                        var LevelID = Req.Items[i].Split(',')[1].ToLong();

                        if (RoleGroupID != 0)
                            NewRequest.RoleGroupID = RoleGroupID;
                        if (LevelID != 0)
                            NewRequest.LevelID = LevelID;
                    }
                    NewRequest.RequestTypeID = NewRequestType.ID;
                    NewRequest.Priority = i;
                    NewRequest.Save();
                }

                return new string[2] { "1", "Success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        #endregion
        #region GridView

        public void Search()
        {
            try
            {
                var Biz = Business.FacadeAutomation.GetRequestTypeBusiness();
                var Entity = Biz.GetAll(300);
                if (!(cmbSearchReqTypeTitle.Value.ToInt() == 0))
                    Entity.And(Models.Generated.AutomationDB.Automation.RequestType.Columns.RequestModelID, cmbSearchReqTypeTitle.Value);
                if (!txtSearchReqTypePriority.Text.IsNullOrEmpty())
                    Entity.And(Models.Generated.AutomationDB.Automation.RequestType.Columns.Importance, txtSearchReqTypePriority.Text);
                Entity.OrderBy(Models.Generated.AutomationDB.Automation.RequestType.Columns.ID, "ASC");
                gridView.DataSource = Biz.Fetch(Entity).ToList();
                gridView.DataBind();
            }
            catch
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
        #endregion

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