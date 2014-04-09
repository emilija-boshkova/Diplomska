using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Serialization;
using System.Xml.XPath;
using Newtonsoft.Json;


namespace DiplomskaSmartCity
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetAirInfo();
                GetSkopjeUliciAktivnosti();
                GetWaterInfo();
            }
        }

        //protected string CrimeMapData()//(object sender, EventArgs e)
        //{
        //    //requesting the particular web page
        //   // Uri myuri = new Uri("http://crimemap.finki.ukim.mk/model/xmldump.php");
        //   // var httpRequest = (HttpWebRequest)WebRequest.Create(myuri);

        //    //geting the response from the request url
        //    //var response = (HttpWebResponse)httpRequest.GetResponse();

        //    //create a stream to hold the contents of the response (in this case it is the contents of the XML file
        //    //var receiveStream = response.GetResponseStream();


        //    XmlDocument doc = new XmlDocument();
        //    string pathToFiles = Server.MapPath("/crimemap");

        //    doc.Load(pathToFiles+"\\crimemap.xml");
        //    string xmlcontents = doc.InnerXml;

        //     byte[] byteArray = Encoding.UTF8.GetBytes( xmlcontents );
        //    MemoryStream stream = new MemoryStream( byteArray ); 
 
        //    // convert stream to string
        //    StreamReader reader = new StreamReader( stream );
           
        //    XmlSerializer serializer = new XmlSerializer(typeof(nastani));
        //    nastani result = (nastani)serializer.Deserialize(reader);

        //   // result.NastaniField = result.NastaniField.Where(c => c.grad == "Скопје" && c.datum.Contains("." + DateTime.Now.Date.Year.ToString())).ToArray();
        //    //close the stream
        //    //receiveStream.Close();

        //    //Label1.Text = result.NastaniField[0].opis;
        //    string json = JsonConvert.SerializeObject(result.NastaniField);
        //    return json;

        //}

        protected void GetAirInfo()
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
            try
            {
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
            }
            catch
            {
                lblInfoAir.Visible = true;
            }
        }

        protected void lbRefreshAir_Click(object sender, EventArgs e)
        {
            GetAirInfo();
        }

        protected void GetSkopjeUliciAktivnosti()
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
            }
            catch
            {
                try
                {
                    string message = doc.DocumentNode.SelectSingleNode("//p[@class='cal_message']").InnerText;
                    lblInfoRoad.Text = message;
                    lblInfoRoad.ForeColor = System.Drawing.Color.Black;
                    lblInfoRoad.Visible = true;
                }
                catch
                {
                    lblInfoRoad.Text = "Податоците се моментално недостапни.";
                    lblInfoRoad.ForeColor = System.Drawing.Color.Red;
                    lblInfoRoad.Visible = true;
                }
            }
        }

        protected void lbPatishta_Click(object sender, EventArgs e)
        {
            GetSkopjeUliciAktivnosti();
        }

        protected void GetWaterInfo()
        {
            string url = "https://www.vodovod-skopje.com.mk/";
            try
            {
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
                HtmlAgilityPack.HtmlNode node = doc.DocumentNode.SelectSingleNode("//div[@id='divMarquee']");

                if (node != null)
                {
                    ltrWater.Text = node.InnerHtml.Replace("<marquee","<div");
                }
                else
                {
                    ltrWater.Text = @"<h4>Нема известувања</h4>";
                }
            }
            catch
            {
                ltrWater.Text = @"<h4>Нема известувања</h4>";
            }
        }
        protected void lbWater_Click(object sender, EventArgs e)
        {
            GetWaterInfo();
        }
    }
}