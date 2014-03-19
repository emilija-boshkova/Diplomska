<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Test.aspx.cs" Inherits="DiplomskaSmartCity.Test" %>

<!DOCTYPE html>

<html>
<head>
    <title>Скопје - Паметен Град</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <style type="text/css">
        #map-canvas
        {
            width: 710px;
            height: 300px;
            /*position: fixed !important;*/
        }

        #header
        {
            height: 70px;
            background-color: aliceblue;
            padding-top: 50px;
        }

        #title
        {
            font-size: 30px;
            color: GrayText;
        }

        #gvAir
        {
            margin-right: 20px;
        }

        #gvSkopjePat
        {
            width: 600px;
        }

        .aw-widget-current-inner
        {
            margin-bottom: 15px;
        }

        #legenda_air
        {
            border-width: thin;
            border-color: black;
            border-style: solid;
        }

        .desc > div
        {
            float: left;
        }

        #air-portlet-body
        {
            height: 300px;
        }

        ul
        {
            width: 100%;
            list-style: none;
        }

            ul li
            {
                float: inherit;
            }



        @media (max-width:500px)
        {
            ul
            {
                width: 100%;
            }

                ul li
                {
                    display: block;
                    font-size: xx-small;
                    float: left;
                }

            #air-portlet-body
            {
                height: 400px;
            }
        }

        @media (max-width:490px)
        {

            #air-portlet-body
            {
                height: 500px;
            }
        }
    </style>
    <link href="../../../fonts.googleapis.com/css_94eb25de.css" rel="stylesheet" type="text/css" />
    <link href="./assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="./assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="./assets/plugins/uniform/css/uniform.default.css" rel="stylesheet" type="text/css" />
    <!-- END GLOBAL MANDATORY STYLES -->
    <!-- BEGIN PAGE LEVEL PLUGIN STYLES -->
    <link href="./assets/plugins/gritter/css/jquery.gritter.css" rel="stylesheet" type="text/css" />
    <link href="./assets/plugins/bootstrap-daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
    <link href="./assets/plugins/fullcalendar/fullcalendar/fullcalendar.css" rel="stylesheet" type="text/css" />
    <link href="./assets/plugins/jqvmap/jqvmap/jqvmap.css" rel="stylesheet" type="text/css" />
    <link href="./assets/plugins/jquery-easy-pie-chart/jquery.easy-pie-chart.css" rel="stylesheet" type="text/css" />
    <!-- END PAGE LEVEL PLUGIN STYLES -->
    <!-- BEGIN THEME STYLES -->
    <link href="./assets/css/style-metronic.css" rel="stylesheet" type="text/css" />
    <link href="./assets/css/style.css" rel="stylesheet" type="text/css" />
    <link href="./assets/css/style-responsive.css" rel="stylesheet" type="text/css" />
    <link href="./assets/css/plugins.css" rel="stylesheet" type="text/css" />
    <link href="./assets/css/pages/tasks.css" rel="stylesheet" type="text/css" />
    <link href="./assets/css/themes/default.css" rel="stylesheet" type="text/css" id="style_color" />
    <link href="./assets/css/print.css" rel="stylesheet" type="text/css" media="print" />
    <link href="./assets/css/custom.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript"
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAKVFU26j-NNGxbbVd9XJWG7xD2esfw-uA&sensor=false">
    </script>
    <script type="text/javascript" src="http://oap.accuweather.com/launch.js"></script>
    <script type="text/javascript" src="http://localhost:50941/Handler.ashx?proxy"></script>
    <script>
        (function () {
            var flickerAPI = "http://api.flickr.com/services/feeds/photos_public.gne?jsoncallback=?";
            $.getJSON(flickerAPI, {
                tags: "mount rainier",
                tagmode: "any",
                format: "json"
            })
              .done(function (data) {
                  $.each(data.items, function (i, item) {
                      $("<img>").attr("src", item.media.m).appendTo("#images");
                      if (i === 3) {
                          return false;
                      }
                  });
              });
        })();
    </script>
    <script type="text/javascript">
        var map;
        var map_markers = [];
        function initialize() {
            if (map_markers.length > 0)
                clearMap();
            //var s = new Handler();
             

            var mapOptions = {
                center: new google.maps.LatLng(41.996528, 21.428576),
                zoom: 12
            };
            var infoWindow = new google.maps.InfoWindow();
            map = new google.maps.Map(document.getElementById("map-canvas"),
               mapOptions);
            //for (i = 0; i < markers.length; i++) {
            //    var data = markers[i];
            //    var image = "../images/crimemap/drugo.png";
            //    if (data.shto == "насилство")
            //        image = "../images/crimemap/boks.png";
            //    else if (data.shto == "оружје")
            //        image = "../images/crimemap/pistol.png";
            //    else if (data.shto == "кражба")
            //        image = "../images/crimemap/kradec.png";
            //    else if (data.shto == "документи")
            //        image = "../images/crimemap/dokumenti.png";
            //    else if (data.shto == "дрога")
            //        image = "../images/crimemap/droga.png";
            //    else if (data.shto == "сообраќај")
            //        image = "../images/crimemap/kola.png";
            //    else
            //        image = "../images/crimemap/drugo.png";
            //    var myLatlng = new google.maps.LatLng(data.lat, data.lng);
            //    var marker = new google.maps.Marker({
            //        position: myLatlng,
            //        map: map,
            //        title: data.shto,
            //        icon: image
            //    });
            //    (function (marker, data) {

            //        // Attaching a click event to the current marker
            //        google.maps.event.addListener(marker, "click", function (e) {
            //            infoWindow.setContent(data.opis);
            //            infoWindow.open(map, marker);
            //        });
            //    })(marker, data);
            //    map_markers.push(marker);
            //}
        }
        google.maps.event.addDomListener(window, 'load', initialize);

        function clearMap() {
            for (var i = 0; i < map_markers.length; i++) {
                map_markers[i].setMap(null);
            }
            map_markers = [];
        }
        google.maps.event.addListenerOnce(map, 'tilesloaded', function(){
            //this part runs when the mapobject is created and rendered
            google.maps.event.addListenerOnce(map, 'tilesloaded', function(){
                var markers = JSON.parse(<%AsyncMap();%>);
                for (i = 0; i < markers.length; i++) {
                    var data = markers[i];
                    var image = "../images/crimemap/drugo.png";
                    if (data.shto == "насилство")
                        image = "../images/crimemap/boks.png";
                    else if (data.shto == "оружје")
                        image = "../images/crimemap/pistol.png";
                    else if (data.shto == "кражба")
                        image = "../images/crimemap/kradec.png";
                    else if (data.shto == "документи")
                        image = "../images/crimemap/dokumenti.png";
                    else if (data.shto == "дрога")
                        image = "../images/crimemap/droga.png";
                    else if (data.shto == "сообраќај")
                        image = "../images/crimemap/kola.png";
                    else
                        image = "../images/crimemap/drugo.png";
                    var myLatlng = new google.maps.LatLng(data.lat, data.lng);
                    var marker = new google.maps.Marker({
                        position: myLatlng,
                        map: map,
                        title: data.shto,
                        icon: image
                    });
                    (function (marker, data) {

                        // Attaching a click event to the current marker
                        google.maps.event.addListener(marker, "click", function (e) {
                            infoWindow.setContent(data.opis);
                            infoWindow.open(map, marker);
                        });
                    })(marker, data);
                    map_markers.push(marker);
                }
            });
        });

    </script>
</head>
<body>
    <form id="Form1" runat="server">
        <div id="header">
            <label id="title"><b><i>СКОПЈЕ - ПАМЕТЕН ГРАД</i></b></label>
        </div>
        <div class="row">
            <div class="col-md-6 col-sm-6">
                <div class="portlet box blue">
                    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />
                    <asp:UpdatePanel runat="server" ID="UpdatePnlAir" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="portlet-title">
                                <div class="caption">
                                    <i class="fa fa-bell-o"></i>Загадување на воздухот
                                </div>
                                <div class="actions">
                                    <div class="btn-group">
                                        <%--<a class="btn btn-sm default" href="#" data-close-others="true">Filter By
                                        </a>--%>
                                        <asp:LinkButton CssClass="btn btn-sm default" ID="lbRefreshAir" runat="server" OnClick="lbRefreshAir_Click" Text="Освежи" />
                                    </div>
                                </div>
                            </div>
                            <%--                            <label>Загадување на воздухот</label>
                            <asp:LinkButton ID="lbRefreshAir" runat="server" OnClick="lbRefreshAir_Click" Text="Освежи" />--%>
                            <div id="air-portlet-body" class="portlet-body">
                                <div class="cont-col2">
                                    <div class="desc">
                                        <asp:GridView ID="gvAir" runat="server" AutoGenerateColumns="False">
                                            <Columns>
                                                <asp:BoundField DataField="Stanica" HeaderText="Станица"></asp:BoundField>
                                                <asp:ImageField DataImageUrlField="CO" HeaderText="CO"></asp:ImageField>
                                                <asp:ImageField DataImageUrlField="NO2" HeaderText="NO2"></asp:ImageField>
                                                <asp:ImageField DataImageUrlField="O3" HeaderText="O3"></asp:ImageField>
                                                <asp:ImageField DataImageUrlField="PM25" HeaderText="PM25"></asp:ImageField>
                                                <asp:ImageField DataImageUrlField="PM10" HeaderText="PM10"></asp:ImageField>
                                                <asp:ImageField DataImageUrlField="SO2" HeaderText="SO2"></asp:ImageField>
                                            </Columns>
                                        </asp:GridView>
                                        <div id="legenda_air">
                                            <b>Индекс на загадување</b>

                                            <ul>


                                                <li>
                                                    <p>
                                                        <img src="images/air_quality/VeryHigh.jpg" /><label>Многу високо</label>
                                                    </p>
                                                </li>


                                                <li>
                                                    <p>
                                                        <img src="images/air_quality/High.jpg" /><label>Високо</label>
                                                    </p>
                                                </li>


                                                <li>
                                                    <p>
                                                        <img src="images/air_quality/Medium.jpg" /><label>Средно</label>
                                                    </p>
                                                </li>


                                                <li>
                                                    <p>
                                                        <img src="images/air_quality/Low.jpg" /><label>Ниско</label>
                                                    </p>
                                                </li>


                                                <li>
                                                    <p>
                                                        <img src="images/air_quality/VeryLow.jpg" /><label>Многу ниско</label>
                                                    </p>
                                                </li>


                                                <li>
                                                    <p>
                                                        <img src="images/air_quality/Missing.jpg" /><label>Нема податоци</label>
                                                    </p>
                                                </li>

                                                <li>
                                                    <p>
                                                        <img src="images/air_quality/NSM.jpg" /><label>Не се мери</label>
                                                    </p>
                                                </li>
                                            </ul>

                                        </div>
                                    </div>
                                </div>
                            </div>

                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="lbRefreshAir" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
            <div class="col-md-6 col-sm-6">
                <div class="portlet box blue">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-bell-o"></i>Време
                        </div>
                    </div>
                    <a href="http://www.accuweather.com/mk/mk/skopje/227397/weather-forecast/227397" class="aw-widget-legal"></a>
                    <div id="Div1" class="aw-widget-current" data-locationkey="" data-unit="c" data-language="mk" data-useip="true" data-uid="awcc1393454863548"></div>
                </div>
            </div>
        </div>
        <div>
            <div>
                <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Conditional">
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <label>Активности на патиштата</label>
                                    <asp:LinkButton ID="lbPatishta" runat="server" OnClick="lbPatishta_Click" Text="Освежи" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label runat="server" ID="lblPatError" Visible="false"></asp:Label>
                                </td>
                            </tr>
                        </table>
                        <div style="width: 620px; height: 250px; overflow: auto">
                            <asp:GridView ID="gvSkopjePat" runat="server" AutoGenerateColumns="False">
                                <HeaderStyle BackColor="Tan" Font-Bold="True" />
                                <Columns>
                                    <asp:BoundField DataField="Nr" HeaderText="#"></asp:BoundField>
                                    <asp:BoundField DataField="Street" HeaderText="Улица"></asp:BoundField>
                                    <asp:BoundField DataField="Activity" HeaderText="Активност"></asp:BoundField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="lbPatishta" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>

            </div>
            <div id="panel_crime" style="float: left; height: 70%; margin-left: -50px">
                <p>
                    <label>Мапа на криминалот</label>
                    <label onclick="clearMap()">Освежи</label>
                </p>

                <asp:UpdatePanel runat="server" ID="pnlMap" UpdateMode="Always">
                    <ContentTemplate>
                        <div id="map-canvas" />
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </form>
</body>
</html>
