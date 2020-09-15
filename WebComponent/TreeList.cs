using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DevExpress.Web.ASPxTreeList;

namespace WebComponent
{
    public class TreeList : ASPxTreeList
    {
        public TreeList()
        {
               this.Font.Name = "IRANSansWeb";
            this.Border.BorderStyle = System.Web.UI.WebControls.BorderStyle.Groove;
            this.Styles.Header.BackColor = Color.FromArgb(58, 96, 146);
            this.Styles.Header.ForeColor = Color.White;
        }
    }
}
