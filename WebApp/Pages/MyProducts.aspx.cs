using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApp.Classes.Base;
using Utilities;

namespace WebApp.Pages
{
    public partial class MyProducts : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var actions = new List<WebComponent.ComboBox.Actions>();
            actions.Add(new WebComponent.ComboBox.Actions() { gid = "3BCAB3FD-00B6-43F6-BEA3-DC4693693DC6", Title = "اعلام خرابی" });
            cmbAction.SetActions(actions);
        }

        #region WebMethods
        [WebMethod]
        public static string[] GetTableRows()
        {
            try
            {

                var ProductInfo = Business.FacadeAutomation.GetVwUserProductDetailBusiness().GetAllList();
                var Biz = Business.FacadeAutomation.GetVwUserProductDetailBusiness();
                var Entity = Biz.GetAll(300);
                Entity.And(Models.Generated.AutomationDB.Automation.VwUserProductDetail.Columns.UserID, CurrentUser.ID);
                Entity.OrderBy(Models.Generated.AutomationDB.Automation.VwUserProductDetail.Columns.ID, "DESC");

                var json = JsonConvert.SerializeObject(Biz.Fetch(Entity).ToList());

                return new string[2] { "1", json };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        [WebMethod]
        public static string[] RepairProduct(string prid)
        {
            try
            {
                var Productinfo = Business.FacadeAutomation.GetPersonalProductsBusiness().GetByID(prid.ToLong());
                if (Productinfo == null)
                    throw new Exception("وسیله مورد نظر پیدا نشد");
                var Product = Business.FacadeAutomation.GetProductBusiness().GetByID(Productinfo.ProductID.ToLong());
                Product.Status = 2;
                Product.Save();

                return new string[2] { "1", "success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        #endregion
    }
}