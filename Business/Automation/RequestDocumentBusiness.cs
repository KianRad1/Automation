using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class RequestDocumentBusiness : AutomationBaseBusiness<RequestDocument>
    {
        public RequestDocument GetByID(long ID)
        {
            var q = this.GetAll(1);
            q.And(RequestDocument.Columns.ID, ID);
            return this.Fetch(q).FirstOrDefault();
        }
    }
}
