# Declare app level module which depends on filters, and services
PDFJS.workerSrc = '/pdf.worker.js'

angular.module "App" <[app.templates ngMaterial ui.router pdf]>

.config <[$stateProvider $urlRouterProvider $locationProvider]> ++ ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $stateProvider
    .state 'about' do
      url: '/about'
      templateUrl: 'app/partials/about.html'
      controller: "About"
    # Catch all
  $urlRouterProvider
    .otherwise('/about')

  # Without serve side support html5 must be disabled.
  $locationProvider.html5Mode true

.run <[$rootScope $state $stateParams $location $window $anchorScroll]> ++ ($rootScope, $state, $stateParams, $location, $window, $anchorScroll) ->
  $rootScope.$state = $state
  $rootScope.$stateParam = $stateParams
  $rootScope.config_build = require 'config.jsenv' .BUILD
  $rootScope.$on '$stateChangeSuccess' (e, {name}) ->
    window?ga? 'send' 'pageview' page: $location.$$path, title: name

.controller AppCtrl: <[$scope $location $rootScope $sce]> ++ (s, $location, $rootScope, $sce) ->
  s <<< {$location}
  s.$watch '$location.path()' (activeNavId or '/') ->
    s <<< {activeNavId}

  s.getClass = (id) ->
    if s.activeNavId.substring 0 id.length is id
      'active'
    else
      ''

.controller About: <[$rootScope $http $scope $mdSidenav $interval]> ++ ($rootScope, $http, $scope, $mdSidenav, $interval) ->
    $rootScope.activeTab = 'about'
    $rootScope.pdfUrl = '/'
    $scope.toggleLeft = -> $mdSidenav('left').toggle!
    $rootScope.pageProgress = 0
    $rootScope.slideProgress = 5

.controller PDFPlayerCtrl: <[$rootScope $scope $interval]> ++ ($rootScope, $scope, $interval) ->
  per-page = 15000
  $scope.$parent.onLoad = ->
    # ready
    $scope.$parent.ready = true
    #start!
  $scope.start = ->
    $scope.$parent.started = true
    $rootScope.pageProgress = 0
    $interval (->
      $('.md-bar2').css transition: "all #{per-page / 1000}s linear"
      $rootScope.pageProgress = 100
    ), 100, 1
    $interval (->
      $scope.goNext!
      $rootScope.slideProgress += 100 / $scope.pageCount
      $('.md-bar2').css transition: ''
      $rootScope.pageProgress = 0
      $interval (->
        $('.md-bar2').css transition: "all #{per-page / 1000}s linear"
        $rootScope.pageProgress = 100
      ), 100, 1
    ), per-page, $scope.pageCount-1

.controller LeftCtrl: <[$rootScope $scope $timeout $interval $mdSidenav $log]> ++ ($rootScope, $scope, $timeout, $interval, $mdSidenav, $log) ->
  $scope.files = [{"bytes":2772798,"link":"https://dl.dropboxusercontent.com/1/view/2lv9585lhj8hnv0/ignite-od/au_Sandstorm-and-OpenDocument.pdf","name":"au_Sandstorm-and-OpenDocument.pdf","icon":"https://www.dropbox.com/static/images/icons64/page_white_acrobat.png"},{"bytes":2270164,"link":"https://dl.dropboxusercontent.com/1/view/nmoi7kfx3r2fynj/ignite-od/ianmakgill-what-happens-when-you-use-open-data-a-story-from-the-uk.pdf","name":"ianmakgill-what-happens-when-you-use-open-data-a-story-from-the-uk.pdf","icon":"https://www.dropbox.com/static/images/icons64/page_white_acrobat.png"}]
  $scope.trigger = ->
    console.log it
    $rootScope.pdfUrl = it.link
    $rootScope.hasPDF = true

  $scope.dropbox = -> Dropbox.choose do
    success: (files) ->
      console.log JSON.stringify files
      $scope.$apply -> $scope.files = files
    link-type: 'direct'
    multiselect: true
    extensions: ['.pdf']

  $scope.close = ->
    $mdSidenav 'left' .close!
    .then ->
      $log.debug "close LEFT is done"
    $rootScope.activeTab = 'about'