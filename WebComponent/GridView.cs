using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DevExpress.Web.ASPxGridView;

namespace WebComponent
{
    public class GridView : ASPxGridView
    {
        public Dictionary<string, string> RelatedColumns = new Dictionary<string, string>();


        private const string RegexPatern = "[\\w](;[\\w])*";

        private string[] defaultColors = new string[] { "#FFFFFF", "#F0F0FF", "#EEFFFF", "#FFFFD6", "#FFDBDB", "#F7F3EB", "#FFF0E6", "#EEFFEE", "#F3F7F9", "#EBEBF7" };

       
        public bool ShowScrollBar
        {
            get
            {
                return this.Settings.ShowHorizontalScrollBar;
            }
            set
            {
                this.Settings.ShowHorizontalScrollBar = value;
            }
        }

        public GridView()
        {
            this.ViewStateMode = System.Web.UI.ViewStateMode.Enabled;
            this.AutoGenerateColumns = false;

            this.Settings.ShowGroupPanel = false;
            this.Settings.ShowFooter = true;
            this.SettingsBehavior.ColumnResizeMode = DevExpress.Web.ASPxClasses.ColumnResizeMode.NextColumn;
            this.SettingsBehavior.AllowSort = true;
            this.SettingsBehavior.AllowSelectByRowClick = true;
            this.SettingsBehavior.AllowMultiSelection = true;
            this.SettingsBehavior.AllowGroup = true;

            this.SettingsPager.Mode = GridViewPagerMode.ShowPager;
            this.SettingsCustomizationWindow.Enabled = true;
           
            this.Settings.ShowFooter = true;
            this.Settings.ShowFilterBar = GridViewStatusBarMode.Hidden;

            this.Settings.ShowTitlePanel = true;
            this.EnableCallBacks = true;
            this.SettingsLoadingPanel.Mode = GridViewLoadingPanelMode.ShowAsPopup;
            this.SettingsLoadingPanel.ShowImage = true;
            this.SettingsLoadingPanel.ImagePosition = DevExpress.Web.ASPxClasses.ImagePosition.Right;

            this.SettingsPager.ShowDefaultImages = false;
            this.SettingsPager.LastPageButton.Visible = true;
            this.SettingsPager.FirstPageButton.Visible = true;
            this.SettingsPager.FirstPageButton.Visible = false;
            this.SettingsPager.LastPageButton.Visible = false;
            this.PageSize = 20;
            this.SettingsPager.AlwaysShowPager = true;
            this.SettingsPager.Visible = true;
            this.SettingsPager.Mode = GridViewPagerMode.ShowPager;
            this.Styles.AlternatingRow.Enabled = DevExpress.Utils.DefaultBoolean.True;
            this.Font.Name = "IRANSansWeb";
            this.Styles.PagerBottomPanel.BackColor = Color.White;
            this.Styles.Header.BackColor = Color.FromArgb(58, 96, 146);
            this.Styles.Header.ForeColor = Color.White;
            this.Border.BorderColor = Color.FromArgb(58, 96, 146);
            this.Styles.TitlePanel.CssClass = "GridHidePanels";
            this.Styles.Footer.CssClass = "GridHidePanels";
            this.Styles.Cell.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;
            this.Styles.Header.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;
        }
        
    }
}
