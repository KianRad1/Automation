using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DevExpress.Web.ASPxEditors;

namespace WebComponent
{
    public class ListBox : ASPxListBox
    {
        public ListBox()
        {
            this.Border.BorderColor = Color.FromArgb(58, 96, 146);
            this.Font.Name = "IRANSansWeb";
            this.Width = 200;
            this.Height = 200;
            this.ItemStyle.Font.Name = "IRANSansWeb"; ;
            this.ItemStyle.Font.Size = 10;
        }
    }
}
