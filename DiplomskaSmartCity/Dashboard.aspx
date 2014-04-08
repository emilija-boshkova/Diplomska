<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="DiplomskaSmartCity.Dashboard" %>

<!DOCTYPE html>

<html>
<head>
    <title>Скопје - Паметен Град</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
   <%-- <style type="text/css">
        #header
        {
            height: 100px;
            background-color: #fafafa;
            padding-top: 30px;
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
            padding-left: 70px;
        }

        .desc > div
        {
            float: left;
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
        .input-group
        {
            width:100%;
            margin-top:5px;
        }
        #map_legend
        {
            width: 100%;
            list-style: none;
            float: left;
            margin-left: -50px;
        }

            #map_legend li label
            {
                font-size: x-small !important;
            }

            #map_legend img
            {
                width: 45px;
            }

        .aw-alert-info, .aw-six-hours,
        .aw-more-block,
        .aw-more-sep-3,
        .aw-more-sep-2,
        .aw-more-inner,
        .aw-six-hours-inner
        {
            display: none;
        }

        .row
        {
            margin-left:0px !important;
            margin-right:0px !important;
        }


        @media (max-width:1130px)
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

            #legenda_air
            {
                width: 100%;
                padding-left: 10px;
            }

            header
            {
                height: 150px;
            }

            #air-table
            {
                overflow: auto;
            }
            /*#air-portlet-body
            {
                height: 400px;
            }*/
        }

        @media (max-width:490px)
        {

            /*#air-portlet-body
            {
                height: 500px;
            }*/
        }

        .blockMsg
        {
            background-color:transparent !important;
            border:none !important;
        }
    </style>--%>
    <link href="./assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="./assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="./assets/plugins/uniform/css/uniform.default.css" rel="stylesheet" type="text/css" />
    <link href="./assets/css/style-metronic.css" rel="stylesheet" type="text/css" />
    <link href="./assets/css/style.css" rel="stylesheet" type="text/css" />
    <link href="./assets/css/style-responsive.css" rel="stylesheet" type="text/css" />
    <link href="./assets/css/plugins.css" rel="stylesheet" type="text/css" />
    <link href="./assets/css/themes/default.css" rel="stylesheet" type="text/css" id="style_color" />
    <link href="dashboard.css" rel="stylesheet" type="text/css" />
    <script src="./assets/plugins/jquery-1.10.2.min.js" type="text/javascript"></script>
    <script src="./assets/plugins/jquery-migrate-1.2.1.min.js" type="text/javascript"></script>
    <!-- IMPORTANT! Load jquery-ui-1.10.3.custom.min.js before bootstrap.min.js to fix bootstrap tooltip conflict with jquery ui tooltip -->
    <script src="./assets/plugins/jquery-ui/jquery-ui-1.10.3.custom.min.js" type="text/javascript"></script>
    <script src="./assets/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="./assets/plugins/bootstrap-hover-dropdown/bootstrap-hover-dropdown.min.js" type="text/javascript"></script>
    <script src="./assets/plugins/jquery-slimscroll/jquery.slimscroll.min.js" type="text/javascript"></script>
    <script src="./assets/plugins/jquery.blockui.min.js" type="text/javascript"></script>
    <script src="./assets/plugins/jquery.cokie.min.js" type="text/javascript"></script>
    <script src="./assets/plugins/uniform/jquery.uniform.min.js" type="text/javascript"></script>
    <script src="./assets/scripts/core/app.js" type="text/javascript"></script>
    <script src="./assets/scripts/custom/index.js" type="text/javascript"></script>
    <script src="./assets/scripts/custom/tasks.js" type="text/javascript"></script>
    <script src="jquery.blockUI.js"></script>
    
    <script type="text/javascript"
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAKVFU26j-NNGxbbVd9XJWG7xD2esfw-uA&sensor=false">
    </script>
    
    <script type="text/javascript">
        var map;
        var map_markers = [];
        //function initialize()
        //{
        //    if (map_markers.length > 0)
        //        clearMap();
        //    var markers = JSON.parse('CrimeMapData()');
        //    var mapOptions = {
        //        center: new google.maps.LatLng(41.996528, 21.428576),
        //        zoom: 12
        //    };
        //    var infoWindow = new google.maps.InfoWindow();
        //    map = new google.maps.Map(document.getElementById("map-canvas"),
        //       mapOptions);
        //    for (i = 0; i < markers.length; i++) {
        //        var data = markers[i];
        //        var image = "../images/crimemap/pin-other-55.png";
        //        if (data.shto == "насилство")
        //            image = "../images/crimemap/pin-violence-50.png";
        //        else if (data.shto == "оружје")
        //            image = "../images/crimemap/pin-gun-55.png";
        //        else if (data.shto == "кражба")
        //            image = "../images/crimemap/pin-thief-55.png";
        //        else if (data.shto == "документи")
        //            image = "../images/crimemap/pin-papers-55.png";
        //        else if (data.shto == "дрога")
        //            image = "../images/crimemap/pin-spric-55.png";
        //        else if (data.shto == "сообраќај")
        //            image = "../images/crimemap/pin-car-55.png";
        //        else
        //            image = "../images/crimemap/pin-other-55.png";
        //        var myLatlng = new google.maps.LatLng(data.lat, data.lng);
        //        var marker = new google.maps.Marker({
        //            position: myLatlng,
        //            map: map,
        //            title: data.shto,
        //            icon: image
        //        });
        //        (function (marker, data) {

        //            // Attaching a click event to the current marker
        //            google.maps.event.addListener(marker, "click", function (e) {
        //                infoWindow.setContent(data.opis);
        //                infoWindow.open(map, marker);
        //            });
        //        })(marker, data);
        //        map_markers.push(marker);
        //    }
        //}
        //google.maps.event.addDomListener(window, 'load', initialize);

        //function clearMap() {
        //    $('#crime_map').block({
        //        message: "<img src='images/loader.gif'/>"
        //    });
        //    for (var i = 0; i < map_markers.length; i++) {
        //        map_markers[i].setMap(null);
        //    }
        //    map_markers = [];
        //    initialize();
        //    $('#crime_map').unblock(); 
        //}
        function BlockAir() {
            $('#UpdatePnlAir').block({
                message: "<img src='images/loader.gif'/>"
            });
        }

        function BlockRoads() {
            $('#UpdatePnlRoads').block({
                message: "<img src='images/loader.gif'/>"
            });
        }

        function BlockWater() {
            $('#UpdatePnlWater').block({
                message: "<img src='images/loader.gif'/>"
            });
        }

        
    </script>
</head>
<body>
    <form id="Form1" runat="server">
        <div id="title_div" class="row">
            <div class="col-md-12">
                <div class="pull-left">
                    <img src="images/finki-logo.png" />
                </div>
                <div class="page-title" style="margin-top: 35px">
                    <label id="title"><b><i>СКОПЈЕ - ПАМЕТЕН ГРАД</i></b></label>

                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6 col-sm-6">
                <div class="portlet box green">
                    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />
                    <asp:UpdatePanel runat="server" ID="UpdatePnlAir" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="portlet-title">
                                <div class="caption">
                                    <i class="fa fa-cloud"></i>Загадување на воздухот
                                </div>
                                <div class="actions">
                                    <div class="btn-group">
                                        <%--<a class="btn btn-sm default" href="#" data-close-others="true">Filter By
                                        </a>--%>
                                        <asp:LinkButton CssClass="btn btn-sm default" ID="lbRefreshAir" runat="server" OnClick="lbRefreshAir_Click" Text="Освежи" OnClientClick="BlockAir()" />
                                    </div>
                                </div>
                            </div>
                            <%--                            <label>Загадување на воздухот</label>
                            <asp:LinkButton ID="lbRefreshAir" runat="server" OnClick="lbRefreshAir_Click" Text="Освежи" />--%>
                            <div id="air-portlet-body" class="portlet-body">
                                <div class="cont-col2">
                                    <div class="row">
                                        <div class="col-md-6 col-sm-6">
                                            <div class="cont-col2" id="air-table">
                                                <asp:Label ID="lblInfoAir" Visible="false" Font-Size="Medium" runat="server" Text="Податоците се моментално недостапни." ForeColor="Red"></asp:Label><br />
                                                <asp:GridView CssClass="table table-striped table-bordered" ID="gvAir" runat="server" AutoGenerateColumns="False">
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
                                            </div>
                                        </div>
                                        <div id="legenda_air" class="col-md-6 col-sm-6">
                                            <div class="cont-col2">
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
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="lbRefreshAir" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
            <div class="col-md-6 col-sm-6">
                <div class="portlet box grey">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-sun-o"></i>Време
                        </div>
                    </div>
                    <div id="weather-portlet-body" class="portlet-body">
                        <div class="cont-col2">
                            <a href="http://www.accuweather.com/mk/mk/skopje/227397/current-weather/227397" class="aw-widget-legal">
                                <!--
By accessing and/or using this code snippet, you agree to AccuWeather’s terms and conditions (in English) which can be found at http://www.accuweather.com/en/free-weather-widgets/terms and AccuWeather’s Privacy Statement (in English) which can be found at http://www.accuweather.com/en/privacy.
-->
                            </a>
                            <div id="awtd1394142601301" class="aw-widget-36hour" data-locationkey="227397" data-unit="c" data-language="mk" data-useip="false" data-uid="awtd1394142601301" data-editlocation="false"></div>
                            <script type="text/javascript" src="http://oap.accuweather.com/launch.js"></script>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6 col-sm-6">
                <div class="portlet box purple">
                    <asp:UpdatePanel runat="server" ID="UpdatePnlRoads" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="portlet-title">
                                <div class="caption">
                                    <i class="fa fa-road"></i>Активности на патиштата
                                </div>
                                <div class="actions">
                                    <div class="btn-group">
                                        <%--<a class="btn btn-sm default" href="#" data-close-others="true">Filter By
                                        </a>--%>
                                        <asp:LinkButton CssClass="btn btn-sm default" ID="lbPatishta" runat="server" OnClick="lbPatishta_Click" OnClientClick="BlockRoads()" Text="Освежи" />
                                    </div>
                                </div>
                            </div>
                            <div id="road-portlet-body" class="portlet-body">
                                <div class="cont-col2">
                                    <asp:Label ID="lblInfoRoad" runat="server" Font-Size="Medium"></asp:Label><br />
                                    <div class="table-scrollable">
                                        <asp:GridView CssClass="table table-striped table-bordered" ID="gvSkopjePat" runat="server" AutoGenerateColumns="False">
                                            <HeaderStyle BackColor="Tan" Font-Bold="True" />
                                            <Columns>
                                                <asp:BoundField DataField="Nr" HeaderText="#"></asp:BoundField>
                                                <asp:BoundField DataField="Street" HeaderText="Локација"></asp:BoundField>
                                                <asp:BoundField DataField="Activity" HeaderText="Активност"></asp:BoundField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>

                                </div>
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="lbPatishta" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
            <div class="col-md-6 col-sm-6">
                <div class="portlet box blue">
                    <asp:UpdatePanel runat="server" ID="UpdatePnlWater" UpdateMode="Conditional">
                        <ContentTemplate>
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-tint"></i>Водовод
                        </div>
                        <div class="actions">
                            <div class="btn-group">
                                <asp:LinkButton CssClass="btn btn-sm default" runat="server" ID="lbWater" OnClick="lbWater_Click" OnClientClick="BlockWater()" Text="Освежи" />
                                
                            </div>
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="cont-col2">
                            <asp:Panel runat="server" ID="pnlWater" ScrollBars="Auto">
                            <asp:Literal runat="server" ID="ltrWater"></asp:Literal>
                            </asp:Panel>
                        </div>
                        
                    </div>
                            </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="lbWater" EventName="Click" />
                        </Triggers>
                        </asp:UpdatePanel>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
               <div id="crime_map" class="portlet box red">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-map-marker"></i>Мапа на криминалот
                        </div>
                        <div class="actions">
                            <div class="btn-group">
                                <%--<a class="btn btn-sm default" href="#" data-close-others="true">Filter By
                                        </a>--%>
                                <input type="button"  value="Освежи" class="btn btn-sm default" /><%--onclick="clearMap()"--%>
                            </div>
                        </div>
                    </div>
                    <div id="map-portlet-body" class="portlet-body">
                        <div class="cont-col2">
                            <div class="gmaps" id="map-canvas" />
                        </div>
                        <div class="input-group">
                            <ul id="map_legend">


                                <li>

                                    <img src="images/crimemap/pin-gun-55.png" /><label>Оружје</label>

                                </li>


                                <li>

                                    <img src="images/crimemap/pin-violence-50.png" />
                                    <label>Насилство</label>

                                </li>


                                <li>

                                    <img src="images/crimemap/pin-thief-55.png" /><label>Кражба</label>

                                </li>


                                <li>

                                    <img src="images/crimemap/pin-papers-55.png" /><label>Документи</label>

                                </li>


                                <li>

                                    <img src="images/crimemap/pin-spric-55.png" /><label>Дрога</label>

                                </li>


                                <li>

                                    <img src="images/crimemap/pin-car-55.png" /><label>Сообраќај</label>

                                </li>

                                <li>

                                    <img src="images/crimemap/pin-other-55.png" /><label>Другo</label>

                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
