using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DevExpress.Web.ASPxEditors;

namespace WebComponent
{
    public class Button : ASPxButton
    {
        public Button()
        {
            this.Font.Name = "IRANSansWeb";
            this.AutoPostBack = false;
            this.CssFilePath = "StyleSheet.css";
            this.CssPostfix = "custom";
        }
      
    }
}
