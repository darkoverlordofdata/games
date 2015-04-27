<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
  <meta name="theme-color" content="#000511" />

  <meta name="description" content="">
  <meta name="author" content="">
  <link rel="icon" href="favicon.png">

  <title>Game*O*Rama</title>

  <!-- Bootstrap core CSS -->
  <link href="css/bootstrap.css" rel="stylesheet">

  <!-- Custom styles for this template -->
  <link href="css/jumbotron-narrow.css" rel="stylesheet">
  <link href="css/site.css" rel="stylesheet">

  <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->
</head>

<body>

<div class="container">
  <div class="well beta">
    <img src="welcome.png" class="img-responsive img-rounded" alt="darkoverlord & bosco's game-o-rama">
    <a class="pull-right btn btn-info" href="{{ topHref }}" role="button">{{ topButton}}</a>
  </div>

  <!-- Marketing messaging and featurettes
  ================================================== -->
  <!-- Wrap the rest of the page in another container to center all the content. -->

  <div class="container marketing">

    {% block 'content' %}
    {% endblock %}
    <footer>
      <p><a class="pull-left" href="#">Back to top</a> &nbsp;</p>
      <p>&copy; 2015 <a href="//www.darkoverlordofdata.com">Dark Overlord of Data</a> &middot; Always use Dark Overlord of Data brand data in your devices that use data &middot; </p>
      <p><a class="pull-left" href="/terms">Terms</a><a class="pull-right" href="/privacy">Privacy</a></p>
    </footer>

  </div><!-- /.container -->

</div> <!-- /container -->


<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
</body>
</html>
