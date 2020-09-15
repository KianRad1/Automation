using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApp.Classes.Base;

namespace WebApp.Pages
{
    public partial class ProductsReport : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        #region WebMethods
        [WebMethod]
        public static string[] GetTableRows()
        {
            try
            {

                var ProductInfo = Business.FacadeAutomation.GetVwUserProductDetailBusiness().GetAllList();


                var json = JsonConvert.SerializeObject(ProductInfo);

                return new string[2] { "1", json };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }

        //[WebMethod]
        //public static string[] GetInfo(int Info)
        //{
        //    try
        //    {

        //        var productInfo = Business.FacadeAutomation.GetProductBusiness().GetByID(Info);
        //        if (productInfo == null)
        //            throw new Exception("وسیله یافت نشد");

        //        var json = JsonConvert.SerializeObject(productInfo);

        //        return new string[2] { "1", json };
        //    }
        //    catch (Exception ex)
        //    {
        //        return new string[2] { "0", ex.Message };
        //    }

        //}
       
        #endregion
    }
}