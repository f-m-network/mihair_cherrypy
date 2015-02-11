<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="IE=Edge,chrome=1" http-equiv="X-UA-Compatible"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>mi.Hair</title>
    <meta content="authenticity_token" name="csrf-param"/>
    <meta content="Bzi/DMx6snRHhwrgnT1jNDGkFBDzzFM6R4xOqpw4R/8="
          name="csrf-token"/>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <!--Le HTML5 shim, for IE6-8 support of HTML elements--><!--[if lt IE 9]>
    <script src="//cdnjs.cloudflare.com/ajax/libs/html5shiv/3.6.1/html5shiv.js"></script>
    <![endif]-->
    <link href="/static/css/mihair.css" media="all" rel="stylesheet"/>

    <link href="http://fonts.googleapis.com/css?family=Roboto:400,300,500"
          rel="stylesheet" type="text/css"/>

    <%block name="extra_head" />
</head>

<body class="registrations   ">

<div id="wrapper">
    <div class="navbar navbar-inverse navbar-fixed-top" id="sitenav"
         role="navigation">

        <div class="container">
            <div class="navbar-header">
                <button class="navbar-toggle" data-target=".navbar-collapse"
                        data-toggle="collapse" type="button">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="/">
                    <img alt="Logo light" id="logo"
                         src="/static/images/logo_light-6f938900175f4baffe24c83326b9e5be.png"/>
                </a>
            </div>

            % if purchase_order:
            <div class="navbar-collapse collapse">
                <ul class="nav navbar-nav navbar-right">
                    <li><a>${purchase_order.get('partner_id')[1]} </a></li>
                    <li><a>Purchase Order ${purchase_order.get('name')}</a></li>
                </ul>
            </div>
            % endif

        </div>
    </div>

    <%block name="content" />



    <div class="push"></div>

</div>
<script src="/static/js/jquery.js"></script>

</body>
</html>