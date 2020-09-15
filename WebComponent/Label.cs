using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DevExpress.Web.ASPxEditors;

namespace WebComponent
{
    public class Label : ASPxLabel
    {
        public Label()
        {
            this.Font.Name = "IRANSansWeb";
            this.Font.Size = 9;
        }
    }
}
