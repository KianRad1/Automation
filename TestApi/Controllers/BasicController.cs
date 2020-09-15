using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PetaPocoDataLayer;

namespace TestApi.Controllers
{
    public class BasicController
    {
        [HttpPost]
        public Users GetUserInfo(long id)
        {
            var userDetails = Business.FacadeAutomation.GetUserBusiness().GetAll();
                    userDetails.And(Models.Generated.AutomationDB.Automation.User.Columns.Username, Business.CompareFilter.Like, txtSearchUsername.Text);

        }
    }
}