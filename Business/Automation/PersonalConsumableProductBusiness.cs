using Models.Generated.AutomationDB.Automation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Automation
{
    public class PersonalConsumableProductBusiness : AutomationBaseBusiness<PersonalConsumableProduct>
    {
        public PersonalConsumableProduct GetByID(long userproductid)
        {
            var q = this.GetAll(1);
            q.And(PersonalConsumableProduct.Columns.ID, userproductid);

            return this.Fetch(q).FirstOrDefault();
        }
    }
}
