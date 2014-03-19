using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Serialization;
using Newtonsoft.Json;

namespace DiplomskaSmartCity
{
    public partial class Test : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetAirInfo();
                GetSkopjeUliciAktivnosti();
            }
        }

        protected delegate string AsyncMethodCaller();


        protected string AsyncMap()
        {
            AsyncMethodCaller caller = new AsyncMethodCaller(CrimeMapData);
            IAsyncResult result = caller.BeginInvoke(null, null);
            Thread.Sleep(0);
            string returnValue = caller.EndInvoke(result);
            return returnValue;
            
        }

        protected void AsyncAir()
        {
            AsyncMethodCaller caller = new AsyncMethodCaller(GetAirInfo);
            IAsyncResult result = caller.BeginInvoke(null, null);
            Thread.Sleep(0);
            string returnValue = caller.EndInvoke(result);

        }

        protected void AsyncUliciAktivnosti()
        {
            AsyncMethodCaller caller = new AsyncMethodCaller(GetSkopjeUliciAktivnosti);
            IAsyncResult result = caller.BeginInvoke(null, null);
            Thread.Sleep(0);
            string returnValue = caller.EndInvoke(result);

        }

        protected string CrimeMapData()//(object sender, EventArgs e)
        {
            //requesting the particular web page
            Uri myuri = new Uri("http://crimemap.finki.ukim.mk/model/xmldump.php");
            var httpRequest = (HttpWebRequest)WebRequest.Create(myuri);

            //geting the response from the request url
            var response = (HttpWebResponse)httpRequest.GetResponse();

            //create a stream to hold the contents of the response (in this case it is the contents of the XML file
            var receiveStream = response.GetResponseStream();


            XmlSerializer serializer = new XmlSerializer(typeof(nastani));
            nastani result = (nastani)serializer.Deserialize(receiveStream);

            result.NastaniField = result.NastaniField.Where(c => c.grad == "Скопје" && c.datum.Contains("." + DateTime.Now.Date.Year.ToString())).ToArray();
            //close the stream
            receiveStream.Close();

            //Label1.Text = result.NastaniField[0].opis;
            string json = JsonConvert.SerializeObject(result.NastaniField);

            XmlDocument doc = JsonConvert.DeserializeXmlNode("{\"nastan\":" + json + "}", "nastan");

            StringWriter stringWriter = new StringWriter();
            XmlTextWriter xmlTextWriter = new XmlTextWriter(stringWriter);

            doc.WriteTo(xmlTextWriter);

            FileStream fs1 = new FileStream("E:\\test.txt", FileMode.OpenOrCreate, FileAccess.Write);
            StreamWriter writer = new StreamWriter(fs1);
            writer.Write(stringWriter.ToString());
            writer.Close();

            return json;

        }

        protected string GetAirInfo()
        {
            DataTable dt = new DataTable();
            // define the table's schema
            dt.Columns.Add(new DataColumn("Stanica", typeof(string)));
            dt.Columns.Add(new DataColumn("CO", typeof(string)));
            dt.Columns.Add(new DataColumn("NO2", typeof(string)));
            dt.Columns.Add(new DataColumn("O3", typeof(string)));
            dt.Columns.Add(new DataColumn("PM25", typeof(string)));
            dt.Columns.Add(new DataColumn("PM10", typeof(string)));
            dt.Columns.Add(new DataColumn("SO2", typeof(string)));

            string url = "http://airquality.moepp.gov.mk/Images/AQNow.html";
            HttpWebRequest webrequest = (HttpWebRequest)WebRequest.Create(url);
            webrequest.Method = "GET";
            HttpWebResponse webResponse = (HttpWebResponse)webrequest.GetResponse();
            string sourceCode;
            using (StreamReader responseStream = new StreamReader(webResponse.GetResponseStream()))
            {
                sourceCode = responseStream.ReadToEnd().Trim();
            }

            HtmlAgilityPack.HtmlDocument doc = new HtmlAgilityPack.HtmlDocument();
            doc.LoadHtml(sourceCode);
            List<string> links = new List<string>();
            HtmlAgilityPack.HtmlNode node = doc.DocumentNode.SelectSingleNode("//td[@class='nobg']//table");
            if (node != null)
            {
                int count = 0;
                foreach (HtmlAgilityPack.HtmlNode nd in node.SelectNodes("//tr[position()>1]"))
                {
                    HtmlAgilityPack.HtmlNode d = nd.SelectSingleNode("//td/a");

                    DataRow dr = dt.NewRow();
                    if (nd.SelectSingleNode("td/a") == null)
                        continue;
                    if (nd.SelectSingleNode("td/a").Attributes["href"].Value.Contains("Centar")
                        || nd.SelectSingleNode("td/a").Attributes["href"].Value.Contains("Karpos")
                        || nd.SelectSingleNode("td/a").Attributes["href"].Value.Contains("Lisice")
                        || nd.SelectSingleNode("td/a").Attributes["href"].Value.Contains("Gazi%20Baba")
                        || nd.SelectSingleNode("td/a").Attributes["href"].Value.Contains("Rektorat")
                        || nd.SelectSingleNode("td/a").Attributes["href"].Value.Contains("Miladinovci")
                        || nd.SelectSingleNode("td/a").Attributes["href"].Value.Contains("Mrsevci"))
                        dr["Stanica"] = nd.SelectSingleNode("td/a").InnerText;

                    if (!String.IsNullOrEmpty(dr["Stanica"].ToString()))
                    {
                        dr["CO"] = nd.SelectSingleNode("td[2]").InnerText == "HCM" ? "../images/air_quality/NSM.jpg" : "../images/air_quality/" + nd.SelectSingleNode("td[2]/img").Attributes["src"].Value;
                        dr["NO2"] = nd.SelectSingleNode("td[3]").InnerText == "HCM" ? "../images/air_quality/NSM.jpg" : "../images/air_quality/" + nd.SelectSingleNode("td[3]/img").Attributes["src"].Value;
                        dr["O3"] = nd.SelectSingleNode("td[4]").InnerText == "HCM" ? "../images/air_quality/NSM.jpg" : "../images/air_quality/" + nd.SelectSingleNode("td[4]/img").Attributes["src"].Value;
                        dr["PM25"] = nd.SelectSingleNode("td[5]").InnerText == "HCM" ? "../images/air_quality/NSM.jpg" : "../images/air_quality/" + nd.SelectSingleNode("td[5]/img").Attributes["src"].Value;
                        dr["PM10"] = nd.SelectSingleNode("td[6]").InnerText == "HCM" ? "../images/air_quality/NSM.jpg" : "../images/air_quality/" + nd.SelectSingleNode("td[6]/img").Attributes["src"].Value;
                        dr["SO2"] = nd.SelectSingleNode("td[7]").InnerText == "HCM" ? "../images/air_quality/NSM.jpg" : "../images/air_quality/" + nd.SelectSingleNode("td[7]/img").Attributes["src"].Value;
                        dt.Rows.Add(dr);
                        count++;
                    }
                    if (count == 7)
                        break;

                }
            }
            gvAir.DataSource = dt;
            gvAir.DataBind();
            return dt.Rows.Count.ToString();
        }

        protected void lbRefreshAir_Click(object sender, EventArgs e)
        {
            AsyncAir();
        }

        protected string GetSkopjeUliciAktivnosti()
        {
            HtmlAgilityPack.HtmlDocument doc = new HtmlAgilityPack.HtmlDocument();
            //Uri urlAddress = new Uri("http://www.uip.gov.mk/index.php?option=com_jcalpro&Itemid=149&extmode=view&extid=622");
            Uri urlAddress = new Uri("http://www.uip.gov.mk/index.php?option=com_jcalpro&extmode=day&Itemid=149");
            try
            {

                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(urlAddress);

                // Get response  
                using (HttpWebResponse response = request.GetResponse() as HttpWebResponse)
                {
                    StreamReader reader = new StreamReader(response.GetResponseStream());

                    Stream receiveStream = response.GetResponseStream();

                    string rez = reader.ReadToEnd();
                    doc.LoadHtml(rez);
                    reader.Close();
                }
                string partofurl = doc.DocumentNode.SelectSingleNode("//div[@class='eventdesc']/a").Attributes["href"].Value;

                urlAddress = new Uri("http://www.uip.gov.mk" + partofurl);

                request = (HttpWebRequest)WebRequest.Create(urlAddress);

                // Get response  
                using (HttpWebResponse response = request.GetResponse() as HttpWebResponse)
                {
                    StreamReader reader = new StreamReader(response.GetResponseStream());

                    Stream receiveStream = response.GetResponseStream();

                    string rez = reader.ReadToEnd();
                    doc.LoadHtml(rez);
                    reader.Close();
                }

                DataTable dt = new DataTable();
                dt.Columns.Add(new DataColumn("Nr", typeof(string)));
                dt.Columns.Add(new DataColumn("Street", typeof(string)));
                dt.Columns.Add(new DataColumn("Activity", typeof(string)));

                HtmlAgilityPack.HtmlNode node = doc.DocumentNode.SelectSingleNode("//div[@class='eventdesclarge']");

                foreach (HtmlAgilityPack.HtmlNode n in node.SelectNodes("table//tr[position()>1]"))
                {
                    DataRow r = dt.NewRow();
                    r["Nr"] = n.SelectSingleNode("td[1]/p").InnerText;
                    r["Street"] = n.SelectSingleNode("td[2]/p").InnerText;
                    r["Activity"] = n.SelectSingleNode("td[3]/p").InnerText;

                    dt.Rows.Add(r);
                }
                gvSkopjePat.DataSource = dt;
                gvSkopjePat.DataBind();
                return dt.Rows.Count.ToString();
            }
            catch
            {
                lblPatError.Visible = true;
                lblPatError.Text = "Податоците се моментално недостапни";
                lblPatError.ForeColor = System.Drawing.Color.Red;
                return null;
            }

        }

        protected void lbPatishta_Click(object sender, EventArgs e)
        {
            AsyncUliciAktivnosti();
        }

       
    }

    public static class util
{
        public static string CrimeMapData()//(object sender, EventArgs e)
        {
            //requesting the particular web page
            Uri myuri = new Uri("http://crimemap.finki.ukim.mk/model/xmldump.php");
            var httpRequest = (HttpWebRequest)WebRequest.Create(myuri);

            //geting the response from the request url
            var response = (HttpWebResponse)httpRequest.GetResponse();

            //create a stream to hold the contents of the response (in this case it is the contents of the XML file
            var receiveStream = response.GetResponseStream();


            XmlSerializer serializer = new XmlSerializer(typeof(nastani));
            nastani result = (nastani)serializer.Deserialize(receiveStream);

            result.NastaniField = result.NastaniField.Where(c => c.grad == "Скопје" && c.datum == DateTime.Now.Date.ToString("dd.MM.yyyy.")).ToArray(); 
                //&& c.datum.Contains("." + DateTime.Now.Date.Year.ToString())).ToArray();
            //close the stream
            receiveStream.Close();

            //Label1.Text = result.NastaniField[0].opis;
            string json = JsonConvert.SerializeObject(result.NastaniField);
            return json;

        }

        public delegate string AsyncMethodCaller();

        public static string AsyncMap()
        {
            AsyncMethodCaller caller = new AsyncMethodCaller(CrimeMapData);
            IAsyncResult result = caller.BeginInvoke(null, null);
            Thread.Sleep(0);
            string returnValue = caller.EndInvoke(result);
            return returnValue;

        }

}
}