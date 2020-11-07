using QRCoder;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using IronBarCode;
using Utilities;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Drawing.Imaging;

namespace Test
{
    class Program
    {
        static void Main(string[] args)
        {
            var QRData = "شرکت اینتک واحد " + "فنی" + " " + "سبحان" + " " + "کیان راد" + System.Environment.NewLine + " تاریخ تحویل : " + DateTime.Now + System.Environment.NewLine + " وسیله : " + "کیبورد " + System.Environment.NewLine + " مدل و سریال : " + "A4Tech" + "TESTSERIALNO";
            QRCodeGenerator qrGenerator = new QRCodeGenerator();
            QRCodeData qrCodeData = qrGenerator.CreateQrCode(QRData, QRCodeGenerator.ECCLevel.Q);
            //AsciiQRCode qrCode = new AsciiQRCode(qrCodeData);
            QRCode qrCode = new QRCode(qrCodeData);
            Bitmap qrCodeImage = qrCode.GetGraphic(2);

            //var rectf = new RectangleF(40, 128, 10, 10); //rectf for My Text
            //using (Graphics g = Graphics.FromImage(qrCodeImage))
            //{
            //    g.DrawRectangle(new Pen(Color.Red, 1), 40, 128, 10, 10);
            //    g.SmoothingMode = SmoothingMode.AntiAlias;
            //    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
            //    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
            //    StringFormat sf = new StringFormat();
            //    sf.Alignment = StringAlignment.Center;
            //    sf.LineAlignment = StringAlignment.Center;
            //    g.DrawString("Hello", new Font("Tahoma", 4, FontStyle.Bold), Brushes.Black, rectf, sf);
            //}
            Image txtImage = DrawText("P10011-فنی", new Font("Tahoma", 15), Color.Black, Color.White);

            Image Allimg = new Bitmap(146, 182);
            Graphics g = Graphics.FromImage(Allimg);
            g.DrawImage(qrCodeImage, 0, 0);
            g.DrawImage(txtImage, 0, 140);


            //Console.WriteLine(txtImage.GetType());
            if (Directory.Exists(@"C:/inetpub/wwwroot/AutomationV2/Publish/Images"))
                Allimg.Save("C:/inetpub/wwwroot/AutomationV2/Publish/Images/Desktop.png", ImageFormat.Png);

            Console.ReadKey();
        }
        private static Image DrawText(String text, Font font, Color textColor, Color backColor)
        {
            Image img = new Bitmap(1, 1);
            Graphics drawing = Graphics.FromImage(img);

            SizeF textSize = drawing.MeasureString(text, font);

            img.Dispose();
            drawing.Dispose();

            img = new Bitmap(146, 42);

            drawing = Graphics.FromImage(img);

            drawing.Clear(backColor);

            Brush textBrush = new SolidBrush(textColor);

            drawing.DrawString(text, font, textBrush, 0, 0);

            drawing.Save();

            textBrush.Dispose();
            drawing.Dispose();

            return img;

        }
    }
}
