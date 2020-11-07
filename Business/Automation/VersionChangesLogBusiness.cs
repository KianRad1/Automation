using Models.Generated.AutomationDB.Automation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace Business.Automation
{
    public class VersionChangesLogBusiness : AutomationBaseBusiness<VersionChangesLog>
    {
        public List<VersionChangesLog> GetLatestVersionChanges()
        {
            var q = this.GetAll(10);
            q.OrderBy(VersionChangesLog.Columns.ID, "DESC");

            return this.Fetch(q).ToList();
        }
        public string GetLastVersion()
        {
            var q = this.GetAll(1);
            q.OrderBy(VersionChangesLog.Columns.ID, "DESC");
            string version = "1.0.0";
            var LatestVersion = this.Fetch(q).FirstOrDefault(); //Check LatestVersion is not null
            if (!LatestVersion.VersionNo.IsNullOrEmpty())
                version = LatestVersion.VersionNo;
            return version;
        }
    }
}
