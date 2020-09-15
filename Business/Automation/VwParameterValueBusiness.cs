using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class VwParameterValueBusiness : AutomationBaseBusiness<VwParameterValue>
    {
        public List<VwParameterValue> GetByRequestDocID(long ReqDocID)
        {
            var q = this.GetAll();
            q.And(VwParameterValue.Columns.RequestDocumentID, ReqDocID);
            q.OrderBy(VwParameterValue.Columns.ID, "ASC");

            return this.Fetch(q);
        }
    }
}
