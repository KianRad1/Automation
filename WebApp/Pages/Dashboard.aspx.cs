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

namespace WebApp.Pages
{
    public partial class Dashboard : BasePage
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            var actions = new List<WebComponent.ComboBox.Actions>();
            actions.Add(new WebComponent.ComboBox.Actions() { gid = "3BCAB3FD-00B6-43F6-BEA3-DC4693693DC6", Title = "بررسی درخواست" });
            actions.Add(new WebComponent.ComboBox.Actions() { gid = "5D18A142-3091-4F8A-AD50-CD02D275EA1E", Title = "جزییات درخواست" });

            cmbAction.SetActions(actions);
        }
        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                base.OnPreRender(e);
                Search();
                ReportSearch();
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        #region DetailPopUp WebMethods
        [WebMethod]
        public static string[] GetDetail(long rowId)
        {
            try
            {
                var ReqDetail = Business.FacadeAutomation.GetVwParameterValueBusiness().GetByRequestDocID(rowId);

                if (ReqDetail == null)
                    throw new Exception("جزییات درخواست یافت نشد");

                var json = JsonConvert.SerializeObject(ReqDetail);

                return new string[2] { "1", json };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.ToString()};
            }
        }
        #endregion


        #region WebMethods
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
        public static string[] Confirm(string Info)
        {
            try
            {
                //var RequestInfo = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<ReqOperation>(Info);
                //var AcceptedRequest = Business.FacadeAutomation.GetRequestDocumentBusiness().GetByID(RequestInfo.ReqID);
                //if (AcceptedRequest == null)
                //    throw new Exception("درخواست پیدا نشد");

                //if (!(AcceptedRequest.StatusID == Constants.Status.InProgress.ToLong() || AcceptedRequest.StatusID == Constants.Status.Sent.ToLong()))
                //    throw new Exception("درخواست در مرحله بررسی نیست");

                //var ReqTypeInfo = Business.FacadeAutomation.GetVwRequestTypeDetailBusiness().GetByTypeID(AcceptedRequest.TypeID);
                //if (ReqTypeInfo == null)
                //    throw new Exception("ترتیب مراحل درخواست پیدا نشد");

                //var NextPriority = ReqTypeInfo.Find(r => r.Priority == AcceptedRequest.LevelPriority + 1);

                //if (NextPriority == null)
                //{
                //    AcceptedRequest.StatusID = Constants.Status.Accepted.ToLong();
                //    AcceptedRequest.LevelPriority = null;
                //    AcceptedRequest.CurrentLevel = null;
                //    AcceptedRequest.CurrentRoleGroup = null;
                //}
                //else
                //{


                //    if (NextPriority.LevelID != null && NextPriority.RoleGroupID != null) //کارشناس / فنی
                //    {
                //        AcceptedRequest.CurrentLevel = NextPriority.LevelID;
                //        AcceptedRequest.CurrentRoleGroup = NextPriority.RoleGroupID;
                //    }
                //    else if (NextPriority.LevelID == null && NextPriority.RoleGroupID != null)// بخش فنی/بدون سطح
                //    {
                //        AcceptedRequest.CurrentLevel = 4; //می دهد به مدیر همان بخش
                //        AcceptedRequest.CurrentRoleGroup = NextPriority.RoleGroupID;
                //    }
                //    else if (NextPriority.LevelID != null && NextPriority.RoleGroupID == null)// کارشناس/بدون بخش
                //    {
                //        AcceptedRequest.CurrentLevel = NextPriority.LevelID;
                //        AcceptedRequest.CurrentRoleGroup = CurrentUser.RoleGroupID; // به کارشناس بخش خود شخص می دهد
                //    }





                //    AcceptedRequest.StatusID = Constants.Status.InProgress.ToInt();
                //    AcceptedRequest.LevelPriority = NextPriority.Priority;
                //}
                //AcceptedRequest.Save();

                //var AcceptedReqComment = new Models.Generated.AutomationDB.Automation.RequestComment();
                //if (RequestInfo.description != null)
                //    AcceptedReqComment.Comment = RequestInfo.description;
                //AcceptedReqComment.RequestID = AcceptedRequest.ID;
                //AcceptedReqComment.UserID = CurrentUser.ID;
                //AcceptedReqComment.UserName = CurrentUser.Username;
                //AcceptedReqComment.CreatedOn = DateTime.Now;
                //AcceptedReqComment.Save();

                return new string[2] { "1", "Success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        [WebMethod]
        public static string[] Reject(string Info)
        {
            try
            {
                //var RequestInfo = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<ReqOperation>(Info);

                //if (RequestInfo.description == null)
                //    throw new Exception("توضیحات رد درخواست وارد نشده است");
                //var RejectRequest = Business.FacadeAutomation.GetRequestDocumentBusiness().GetByID(RequestInfo.ReqID);
                //if (RejectRequest == null)
                //    throw new Exception("درخواست پیدا نشد");

                //if (!(RejectRequest.StatusID == Constants.Status.InProgress.ToLong() || RejectRequest.StatusID == Constants.Status.Sent.ToLong()))
                //    throw new Exception("درخواست در مرحله بررسی نیست");

                //var ReqTypeInfo = Business.FacadeAutomation.GetVwRequestTypeDetailBusiness().GetByTypeID(RejectRequest.TypeID);
                //if (ReqTypeInfo == null)
                //    throw new Exception("ترتیب مراحل درخواست پیدا نشد");

                //RejectRequest.StatusID = Constants.Status.Rejected.ToInt();
                //RejectRequest.CurrentLevel = null;
                //RejectRequest.CurrentRoleGroup = null;
                //RejectRequest.LevelPriority = null;
                //RejectRequest.Save();

                //var ReqComment = new Models.Generated.AutomationDB.Automation.RequestComment();
                //ReqComment.Comment = RequestInfo.description;
                //ReqComment.RequestID = RejectRequest.ID;
                //ReqComment.UserID = CurrentUser.ID;
                //ReqComment.UserName = CurrentUser.Username;
                //ReqComment.CreatedOn = DateTime.Now;
                //ReqComment.Save();

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
                if (CurrentUser.IsManager == null || CurrentUser.IsManager == false)
                {
                    Entity.And(Models.Generated.AutomationDB.Automation.VwRequestFullInofrmation.Columns.CurrentLevel, CurrentUser.Level);
                    Entity.And(Models.Generated.AutomationDB.Automation.VwRequestFullInofrmation.Columns.CurrentRoleGroup, CurrentUser.RoleGroupID);
                }
                else
                {
                    Entity.And(Models.Generated.AutomationDB.Automation.VwRequestFullInofrmation.Columns.StatusID, Business.CompareFilter.NotIn, Constants.Status.Created);
                }
                Entity.OrderBy(Models.Generated.AutomationDB.Automation.VwRequestFullInofrmation.Columns.CreatedOn, "DESC");
                gridView.DataSource = Biz.Fetch(Entity);
                gridView.DataBind();
            }
            catch
            {
                throw;
            }
        }
        public void ReportSearch()
        {
            try
            {
                var BizComment = Business.FacadeAutomation.GetRequestCommentBusiness();
                var EntityComment = BizComment.GetAll(300);
                EntityComment.And(Models.Generated.AutomationDB.Automation.RequestComment.Columns.UserID, CurrentUser.ID);
                var FinishedRequests = BizComment.Fetch(EntityComment).Select(r => r.RequestID).ToList();
                if (FinishedRequests.Count != 0)
                {
                    var Biz = Business.FacadeAutomation.GetVwRequestFullInofrmationBusiness();
                    var q = Biz.GetAll(300);
                    q.And(Models.Generated.AutomationDB.Automation.VwRequestFullInofrmation.Columns.RequestID, Business.CompareFilter.In, FinishedRequests);
                    gridViewReport.DataSource = Biz.Fetch(q);
                    gridViewReport.DataBind();
                }
            }
            catch
            {
                throw;
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
            catch (Exception)
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
        protected void gridView_HtmlRowPrepared(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != DevExpress.Web.ASPxGridView.GridViewRowType.Data)
                return;

            if (e.GetValue("StatusID").ToInt() == 4)
                e.Row.BackColor = System.Drawing.Color.FromArgb(164, 232, 169);
            else if (e.GetValue("StatusID").ToInt() == 5)
                e.Row.BackColor = System.Drawing.Color.FromArgb(255, 166, 166);

        }


        #endregion



        #region ReportGrid
        protected void gridViewReport_CustomCallback(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs e)
        {
            try
            {
                ReportSearch();
            }
            catch (Exception)
            {
                throw;
            }
        }

        protected void gridViewReport_BeforeColumnSortingGrouping(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewBeforeColumnGroupingSortingEventArgs e)
        {
            try
            {
                ReportSearch();
            }
            catch (Exception)
            {
                throw;
            }
        }

        protected void gridViewReport_HtmlRowPrepared(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != DevExpress.Web.ASPxGridView.GridViewRowType.Data)
                return;

            if (e.GetValue("StatusID").ToInt() == 4)
                e.Row.BackColor = System.Drawing.Color.FromArgb(164, 232, 169);
            else if (e.GetValue("StatusID").ToInt() == 5)
                e.Row.BackColor = System.Drawing.Color.FromArgb(255, 166, 166);
        }
        #endregion
    }
}