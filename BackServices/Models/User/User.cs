using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BackServices.Models
{
    public class User
    {
        public long ID { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public string Address { get; set; }
    }
}