using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.Classes.Pages.Users
{
    public class UserInfo
    {
        public long? ID { get; set; }
        public string UserName { get; set; }
        public string Name { get; set; }
        public string Family { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public string Mobile { get; set; }
        public long? Level { get; set; }
        public int? RoleID { get; set; }
        public int? RoleGroupID { get; set; }
    }
}