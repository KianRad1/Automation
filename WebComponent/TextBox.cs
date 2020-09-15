using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.UI.WebControls;
using DevExpress.Web.ASPxEditors;

namespace WebComponent
{
    public class TextBox : ASPxTextBox
    {
        public TextBox()
        {
            this.Height = 30;
            this.Font.Name = "IRANSansWeb";
            //this.CssFilePath = "StyleSheet.css";
            //this.CssPostfix = "custom";
        }
    }
}
