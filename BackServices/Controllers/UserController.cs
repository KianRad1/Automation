using BackServices.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;

namespace BackServices.Controllers
{
    public class UserController : Controller
    {
        public ActionResult User()
        {
            return View("Index");
        }

        [HttpGet]
        public IEnumerable<User> GetAllUserDetail()
        {
            User St1 = new User();
            User St2 = new User();
            List<User> li = new List<User>();

            St1.ID = 1;
            St1.Username = "User1";
            St1.Password = "1234";
            St1.Address = "Teh";

            St2.ID = 2;
            St2.Username = "User2";
            St2.Password = "1234";
            St2.Address = "Esf";

            li.Add(St1);
            li.Add(St2);

            return li;
        }

        [HttpGet]
        public IEnumerable<User> GetByID(int ID)
        {
            User St1 = new User();
            User St2 = new User();
            List<User> li = new List<User>();
            if(ID == 1)
            {
                St1.ID = 1;
                St1.Username = "User1";
                St1.Password = "1234";
                St1.Address = "Teh";
                li.Add(St1);
            }
            else
            {
                St2.ID = 2;
                St2.Username = "User2";
                St2.Password = "1234";
                St2.Address = "Esf";
                li.Add(St2);
            }
            return li;
        }



    }
}