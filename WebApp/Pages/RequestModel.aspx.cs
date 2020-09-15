using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApp.Classes.Base;
using WebApp.Classes.Pages.RequestModel;
using Utilities;

namespace WebApp.Pages
{
    public partial class RequestModel : BasePage
    {
        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            var actions = new List<WebComponent.ComboBox.Actions>();
            actions.Add(new WebComponent.ComboBox.Actions() { gid = "3BCAB3FD-00B6-43F6-BEA3-DC4693693DC6", Title = "ویرایش" });
            actions.Add(new WebComponent.ComboBox.Actions() { gid = "1A02762A-987C-4D24-B328-B14ED7A94BFD", Title = "تخصیص پارامتر" });

            cmbAction.SetActions(actions);

            actions = new List<WebComponent.ComboBox.Actions>();
            actions.Add(new WebComponent.ComboBox.Actions() { gid = "549D1BB7-0F97-411C-BA68-F55F504FDDCB", Title = "ویرایش" });
            cmbFeatureActions.SetActions(actions);
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
                var Biz = Business.FacadeAutomation.GetRequestModelBusiness();
                var Entity = Biz.GetAll(300);

                if (!txtSearchRoleModel.Text.IsNullOrEmpty())
                    Entity.And(Models.Generated.AutomationDB.Automation.RequestModel.Columns.Title, Business.CompareFilter.Like, txtSearchRoleModel.Text);
                Entity.OrderBy(Models.Generated.AutomationDB.Automation.RequestModel.Columns.ID, "ASC");
                gridView.DataSource = Biz.Fetch(Entity).ToList();
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
                var ReqInfo = Business.FacadeAutomation.GetRequestModelBusiness().GetByID(Info);
                if (ReqInfo == null)
                    throw new Exception("RequestModle Not Found");

                var json = JsonConvert.SerializeObject(ReqInfo);

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
                var RequestModel = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<RequestModelInfo>(Info);
                var Biz = Business.FacadeAutomation.GetRequestModelBusiness();
                if (string.IsNullOrEmpty(RequestModel.Title.ToString()))
                    throw new Exception("عنوان درخواست وارد نشده است");

                var RequestInfo = Biz.GetByID(RequestModel.ID);

                if (RequestInfo == null)
                    RequestInfo = new Models.Generated.AutomationDB.Automation.RequestModel();

                RequestInfo.Title = RequestModel.Title;
                RequestInfo.Save();

                return new string[2] { "1", "Success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        #endregion
        #region Grid
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
        #endregion
        #region ParamWebMethods
        [WebMethod]
        public static string[] GetFeatureGroup(long rowId)
        {
            try
            {
                var parameters = Business.FacadeAutomation.GetParameterBusiness().GetById(rowId);

                if (parameters == null)
                    throw new Exception("Parameter Not Found");

                var json = JsonConvert.SerializeObject(parameters);

                return new string[2] { "1", json };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.ToString() };
            }
        }

        [WebMethod]
        public static string[] SaveFeatureGroup(string featuregroup)
        {
            try
            {
                var Parameter = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<ParameterInfo>(featuregroup);

                var Biz = Business.FacadeAutomation.GetParameterBusiness();
                if(Parameter.ReqId == 0)
                    throw new Exception("نوع درخواست وارد شده صحیح نمی باشد");
                if (string.IsNullOrEmpty(Parameter.faTitle.ToString()))
                    throw new Exception("عنوان فارسی درخواست وارد نشده است");
                if (string.IsNullOrEmpty(Parameter.enTitle.ToString()))
                    throw new Exception("عنوان لاتین درخواست وارد نشده است");
                if (Parameter.ParameterTypeID == 0)
                    throw new Exception("نوع پارامتر مشخص نشده است");

                var ParameterType = Business.FacadeAutomation.GetParameterTypeBusiness().GetById(Parameter.ParameterTypeID);
                if (ParameterType == null)
                    throw new Exception("نوع پارامتر وارد شده صحیح نمی باشد");

                var Entity = Biz.GetById(Parameter.ID.ToLong());
                if (Entity == null)
                    Entity = new Models.Generated.AutomationDB.Automation.Parameter();

                Entity.faTitle = Parameter.faTitle;
                Entity.enTitle = Parameter.enTitle;
                Entity.ParameterTypeID = Parameter.ParameterTypeID;
                Entity.RequestModelID = Parameter.ReqId;
                Entity.Save();

                return new string[2] { "1", "Success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.ToString() };
            }
        }
        #endregion
        #region ParamGrid
        protected void grid_CustomCallback(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs e)
        {
            try
            {
                var ReqModelID = ReqID.Get("ID").ToLong();
                var Biz = Business.FacadeAutomation.GetParameterBusiness();
                var Entity = Biz.GetAll(300);
                Entity.And(Models.Generated.AutomationDB.Automation.Parameter.Columns.RequestModelID, ReqModelID);
                Entity.OrderBy(Models.Generated.AutomationDB.Automation.Parameter.Columns.ID, "ASC");
                grid.DataSource = Biz.Fetch(Entity).ToList();
                grid.DataBind();
            }
            catch
            {

                throw;
            }
        }
        protected void grid_BeforeColumnSortingGrouping(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewBeforeColumnGroupingSortingEventArgs e)
        {

        }

        protected void grid_PageIndexChanged(object sender, EventArgs e)
        {

        }
        #endregion
    }
}