using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApp.Classes.Base;
using WebApp.Classes.Pages.SubmitRequest;
using Utilities;

namespace WebApp.Pages
{
    public partial class SubmitRequest : BasePage
    {
        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            var actions = new List<WebComponent.ComboBox.Actions>();
            actions.Add(new WebComponent.ComboBox.Actions() { gid = "3BCAB3FD-00B6-43F6-BEA3-DC4693693DC6", Title = "ویرایش" });
            cmbAction.SetActions(actions);

            hdfUser.Set("Level", CurrentUser.Level);
            hdfUser.Set("RoleGroup", CurrentUser.RoleGroupID);
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
        public static string[] AddParameter(int Info)
        {
            try
            {
                var ParameterInfo = Business.FacadeAutomation.GetVwParamentInfoBusiness().GetByReqModelId(Info);
                if (ParameterInfo == null)
                    throw new Exception("Parameter Not Found");
                ParameterInfo.Select(r => new { r.ParameterID, r.ParameterType });

                var json = JsonConvert.SerializeObject(ParameterInfo);

                return new string[2] { "1", json };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }

        [WebMethod]
        public static string[] GetInfo(int Info)
        {
            try
            {
                var RequestInfo = Business.FacadeAutomation.GetVwRequestFullInofrmationBusiness().GetByRequestID(Info);
                if (RequestInfo == null)
                    throw new Exception("Request Not Found");

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
                var SubmitRequest = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<SubmitRequestInfo>(Info);
                var Biz = Business.FacadeAutomation.GetRequestDocumentBusiness();
                if (SubmitRequest.RequestModelID == 0)
                    throw new Exception("نوع درخواست مشخص نشده است");

                var RequestModel = Business.FacadeAutomation.GetRequestModelBusiness().GetByID(SubmitRequest.RequestModelID);
                if (RequestModel == null)
                    throw new Exception("نوع درخواست پیدا نشد");

                foreach (var item in SubmitRequest.ParamList)
                {
                    var parameterexists = Business.FacadeAutomation.GetParameterBusiness().GetById(item.ParameterID);
                    if (parameterexists == null)
                        throw new Exception("پارامتر مورد نظر یافت نشد");
                }

                var Request = Biz.GetByID(SubmitRequest.ReqID.ToLong());
                if (Request == null)
                {
                    Request = new Models.Generated.AutomationDB.Automation.RequestDocument();
                    Request.CreatedOn = DateTime.Now;
                }

                if (!string.IsNullOrEmpty(SubmitRequest.description))
                    Request.description = SubmitRequest.description;

                Request.StatusID = 1;
                Request.TypeID = RequestModel.ID;
                Request.CreatedBy = CurrentUser.Username;
                Request.UserID = CurrentUser.ID;

                Request.Save();


                foreach (var item in SubmitRequest.ParamList)
                {
                    var Parameters = new Models.Generated.AutomationDB.Automation.ParameterDetail();
                    Parameters.ParameterID = item.ParameterID;
                    Parameters.RequestDocumentID = Request.ID;
                    Parameters.Value = item.ParameterValue;
                    Parameters.Save();
                }




                return new string[2] { "1", "Success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        [WebMethod]
        public static string[] SendRequest(string Info)
        {
            try
            {
                var SendRequest = Business.FacadeAutomation.GetRequestDocumentBusiness().GetByID(Info.ToInt());
                if (SendRequest == null)
                    throw new Exception("درخواست پیدا نشد");

                var RequestLevelinfo = Business.FacadeAutomation.GetVwRequestTypeDetailBusiness().GetByTypeID(SendRequest.TypeID).Find(r => r.Priority == 1);
                if (RequestLevelinfo == null)
                    throw new Exception("مراحل درخواست پیدا نشد");

                if (SendRequest.LevelPriority != null || SendRequest.StatusID != 1)
                    throw new Exception("درخواست قبلا ارسال شده است");

                if (RequestLevelinfo.LevelID != null && RequestLevelinfo.RoleGroupID != null) //کارشناس / فنی
                {
                    SendRequest.CurrentLevel = RequestLevelinfo.LevelID;
                    SendRequest.CurrentRoleGroup = RequestLevelinfo.RoleGroupID;
                }
                else if (RequestLevelinfo.LevelID == null && RequestLevelinfo.RoleGroupID != null)// بخش فنی/بدون سطح
                {
                    SendRequest.CurrentLevel = 4; //می دهد به مدیر همان بخش
                    SendRequest.CurrentRoleGroup = RequestLevelinfo.RoleGroupID;
                }
                else if (RequestLevelinfo.LevelID != null && RequestLevelinfo.RoleGroupID == null)// کارشناس/بدون بخش
                {
                    SendRequest.CurrentLevel = RequestLevelinfo.LevelID;
                    SendRequest.CurrentRoleGroup = CurrentUser.RoleGroupID; // به کارشناس بخش خود شخص می دهد
                }

                SendRequest.StatusID = 2;
                SendRequest.LevelPriority = RequestLevelinfo.Priority;
                SendRequest.Sent = true;
                SendRequest.Save();

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
                var Biz = Business.FacadeAutomation.GetVwRequestFullInofrmationBusiness();
                var Entity = Biz.GetAll(300);
                Entity.And(Models.Generated.AutomationDB.Automation.VwRequestFullInofrmation.Columns.UserID, CurrentUser.ID);

                if (!txtSearchCreatedBy.Text.IsNullOrEmpty())
                    Entity.And(Models.Generated.AutomationDB.Automation.VwRequestFullInofrmation.Columns.CreatedBy, Business.CompareFilter.Like, txtSearchCreatedBy.Text);

                if (!txtSearchCreatedFrom.Text.IsNullOrEmpty())
                    Entity.And(Models.Generated.AutomationDB.Automation.VwRequestFullInofrmation.Columns.CreatedOn, Business.CompareFilter.GreaterThanOrEqual, txtSearchCreatedFrom.Text);
                if (!txtSearchCreatedTo.Text.IsNullOrEmpty())
                    Entity.And(Models.Generated.AutomationDB.Automation.VwRequestFullInofrmation.Columns.CreatedOn, Business.CompareFilter.LessThanOrEqual, txtSearchCreatedTo.Text);

                if (!(cmbSearchReqModel.Value.ToInt() == 0))
                    Entity.And(Models.Generated.AutomationDB.Automation.VwRequestFullInofrmation.Columns.RequestModelID, cmbSearchReqModel.Value);

                if (!(cmbSearchStatus.Value.ToInt() == 0))
                    Entity.And(Models.Generated.AutomationDB.Automation.VwRequestFullInofrmation.Columns.StatusID, cmbSearchStatus.Value);
                if (!(cmbSearchCurrentLevel.Value.ToInt() == 0))
                    Entity.And(Models.Generated.AutomationDB.Automation.VwRequestFullInofrmation.Columns.CurrentLevel, cmbSearchCurrentLevel.Value);
                if (!(cmbSearchRoleGroup.Value.ToInt() == 0))
                    Entity.And(Models.Generated.AutomationDB.Automation.VwRequestFullInofrmation.Columns.CurrentRoleGroup, cmbSearchRoleGroup.Value);

                Entity.OrderBy(Models.Generated.AutomationDB.Automation.VwRequestFullInofrmation.Columns.CreatedOn, "DESC");
                gridView.DataSource = Biz.Fetch(Entity);
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
            catch (Exception)
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
            catch (Exception)
            {

                throw;
            }
        }
        protected void gridView_HtmlRowPrepared(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != DevExpress.Web.ASPxGridView.GridViewRowType.Data)
                return;

            if (e.GetValue("StatusID").ToInt() == 4)
                e.Row.BackColor = System.Drawing.Color.FromArgb(164, 232, 169);
            else if (e.GetValue("StatusID").ToInt() == 5)
                e.Row.BackColor = System.Drawing.Color.FromArgb(255, 166, 166);
            else
                e.Row.BackColor = System.Drawing.Color.FromArgb(255, 255, 255);

        }
        #endregion


    }
}