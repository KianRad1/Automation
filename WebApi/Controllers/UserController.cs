using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using WebApi.Models.User;

namespace WebApi.Controllers
{
    public class UserController : ApiController
    {
        [System.Web.Mvc.HttpGet]
        public IEnumerable<UserModel> GetAllcarDetails()
        {
            UserModel ST = new UserModel();
            UserModel ST1 = new UserModel();
            List<UserModel> li = new List<UserModel>();

            ST.ID = 1;
            ST.Username = "User1";
            ST.Password = "12345";
            ST.Address = "Homeee";

            ST1.ID = 2;
            ST1.Username = "User2";
            ST1.Password = "12345";
            ST1.Address = "Homeee";

            li.Add(ST);
            li.Add(ST1);
            return li;
        }
    }
}
