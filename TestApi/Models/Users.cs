using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TestApi.Models
{
    public class Users
    {
        public long ID { get; set; }
        public string Username { get; set; }
        public string MyProperty { get; set; }
        public string Family { get; set; }
        public string Mobile { get; set; }
    }
}