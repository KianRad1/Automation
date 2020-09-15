using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApp.Classes.Base;
using WebApp.Classes.Pages.Levels;
using Utilities;

namespace WebApp.Pages
{
    public partial class Levels : BasePage
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
                var LevelInfo = Business.FacadeAutomation.GetLevelBusiness().GetByID(Info);
                if (LevelInfo == null)
                    throw new Exception("Level Not Found");

                var json = JsonConvert.SerializeObject(LevelInfo);

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
                var Level = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<LevelsInfo>(Info);
                var Biz = Business.FacadeAutomation.GetLevelBusiness();
                if (string.IsNullOrEmpty(Level.Title.ToString()))
                    throw new Exception("سطح دسترسی وارد نشده است");

                if ((Biz.GetByTitle(Level.Title) != null))
                    throw new Exception("سطح دسترسی وارد شده تکراری است");

                var LevelInfo = Biz.GetByID(Level.ID);

                if (LevelInfo == null)
                    LevelInfo = new Models.Generated.AutomationDB.Automation.Level();

                LevelInfo.Title = Level.Title;
                LevelInfo.Save();

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
                var Biz = Business.FacadeAutomation.GetLevelBusiness();
                var Entity = Biz.GetAll(300);

                if (!txtSearchLevel.Text.IsNullOrEmpty())
                    Entity.And(Models.Generated.AutomationDB.Automation.Level.Columns.Title, Business.CompareFilter.Like, txtSearchLevel.Text);
                Entity.OrderBy(Models.Generated.AutomationDB.Automation.Level.Columns.ID, "ASC");
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
        #endregion
    }
}