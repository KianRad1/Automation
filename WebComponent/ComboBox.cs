using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.UI.HtmlControls;
using DevExpress.Web.ASPxEditors;
using System.Web.UI.WebControls;

namespace WebComponent
{
    public class ComboBox : ASPxComboBox
    {

        public ComboBox()
        {
            //this.BackColor = System.Drawing.Color.ForestGreen;
            this.Font.Name = "IRANSansWeb";
            this.Height = 30;
            this.Border.BorderWidth = 1;
            this.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            this.HorizontalAlign = HorizontalAlign.Center;
            this.CssFilePath = "StyleSheet.css";
            this.CssClass = "combocustom";
        }

        public class Actions
        {
            public string gid { set; get; }
            public string Title { set; get; }
            private string _SecurityTitle;
            public string SecurityTitle
            {
                set { this._SecurityTitle = value; }
                get
                {
                    return string.IsNullOrEmpty(_SecurityTitle) ? this.Title : _SecurityTitle;
                }
            }
        }
        public string gid
        {
            get;
            set;
        }
        public void SetActions(System.Collections.Generic.List<Actions> t)
        {
            this.ValueField = "gid";
            this.TextField = "Title";
            this.DataSource = t;
            this.DataBind();
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);

            ListEditItem li = new ListEditItem();
            li.Text = "انتخاب";
            li.Value = null;
            this.Items.Insert(0, li);
        }
    }
}
