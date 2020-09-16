using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.Classes.Pages.Product
{
    public class ProductInfo
    {
        public long? ID { get; set; }
        public long ProductTypeID { get; set; }
        public long ProductBrandID { get; set; }
        public string ProductModel { get; set; }
        public string SerialNo { get; set; }
        public string Description { get; set; }
        public long Status { get; set; }
    }
    public class UserProductInfo
    {
        public long? ID { get; set; }
        public long UserID { get; set; }
        public long ProductID { get; set; }
    }
    public class ConsumableProductInfo
    {
        public long? ID { get; set; }
        public string ProductName { get; set; }
        public long RemainingCount { get; set; }
        public string ProductUnit { get; set; }
        public long DangerRange { get; set; }
    }
    public class AddandRemoveCount
    {
        public long? ID { get; set; }
        public long ChangeCount { get; set; }
    }
    public class ProductTypeInfo
    {
        public long? ID { get; set; }
        public string ProductName { get; set; }
        public long ProductClassificationID { get; set; }
    }
    public class ProductBrandInfo
    {
        public long? ID { get; set; }
        public long ProductTypeID { get; set; }
        public string ProductBrand { get; set; }
    }
}
