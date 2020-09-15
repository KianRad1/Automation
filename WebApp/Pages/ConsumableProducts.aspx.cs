using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApp.Classes.Pages.Product;
using Utilities;
using WebApp.Classes.Base;

namespace WebApp.Pages
{
    public partial class ConsumableProducts : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var actions = new List<WebComponent.ComboBox.Actions>();
            actions.Add(new WebComponent.ComboBox.Actions() { gid = "3BCAB3FD-00B6-43F6-BEA3-DC4693693DC6", Title = "ویرایش" });
            //actions.Add(new WebComponent.ComboBox.Actions() { gid = "8ABC571B-815C-4D7E-8EE3-2D5F95041CD4", Title = "برداشت از انبار" });
            //actions.Add(new WebComponent.ComboBox.Actions() { gid = "118968BF-6B1F-48E7-BD29-72CE03386920", Title = "اضافه به انبار" });
            cmbAction.SetActions(actions);
        }
        #region WebMethods
        [WebMethod]
        public static string[] GetTableRows()
        {
            try
            {

                var ProductInfo = Business.FacadeAutomation.GetConsumableProductsBusiness().GetAllList();

                var json = JsonConvert.SerializeObject(ProductInfo);

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

                var productInfo = Business.FacadeAutomation.GetConsumableProductsBusiness().GetByID(Info);
                if (productInfo == null)
                    throw new Exception("وسیله یافت نشد");

                var json = JsonConvert.SerializeObject(productInfo);

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
                var Product = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<ConsumableProductInfo>(Info);

                if (Product.ProductName.IsNullOrEmpty() || Product.ProductUnit.IsNullOrEmpty())
                    throw new Exception("تمام موارد را پر کنید نشده است");

                var ProductInfo = Business.FacadeAutomation.GetConsumableProductsBusiness().GetByID(Product.ID.ToLong());
                if (ProductInfo == null)
                    ProductInfo = new Models.Generated.AutomationDB.Automation.ConsumableProduct();
                ProductInfo.ProductName = Product.ProductName;
                ProductInfo.RemainingCount = Product.RemainingCount;
                ProductInfo.ProductUnit = Product.ProductUnit;
                ProductInfo.DangerRange = Product.DangerRange;
                ProductInfo.Save();

                return new string[2] { "1", "Success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        [WebMethod]
        public static string[] SaveAddProduct(string Info)
        {
            try
            {
                var Product = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<AddandRemoveCount>(Info);

                if (Product.ChangeCount < 1)
                    throw new Exception("مقدار اضافه شدن به انبار باید بیشتر از صفر باشد");

                var ProductInfo = Business.FacadeAutomation.GetConsumableProductsBusiness().GetByID(Product.ID.ToLong());
                if (ProductInfo == null)
                    throw new Exception("وسیله مصرفی پیدا نشد");

                ProductInfo.RemainingCount += Product.ChangeCount;
                ProductInfo.Save();

                return new string[2] { "1", "Success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        [WebMethod]
        public static string[] SaveRemoveProduct(string Info)
        {
            try
            {
                var Product = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<AddandRemoveCount>(Info);

                if (Product.ChangeCount < 1)
                    throw new Exception("مقدار برداشت از انبار باید بیشتر از صفر باشد");

                var ProductInfo = Business.FacadeAutomation.GetConsumableProductsBusiness().GetByID(Product.ID.ToLong());
                if (ProductInfo == null)
                    throw new Exception("وسیله مصرفی پیدا نشد");

                ProductInfo.RemainingCount -= Product.ChangeCount;
                ProductInfo.Save();

                return new string[2] { "1", "Success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        #endregion
    }
}