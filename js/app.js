require.register("config.jsenv",function(t,e,o){o.exports={BUILD:"git-3f73c8d"}}),PDFJS.workerSrc="/pdf.worker.js",angular.module("App",["app.templates","ngMaterial","ui.router","pdf"]).config(["$stateProvider","$urlRouterProvider","$locationProvider"].concat(function(t,e,o){return t.state("about",{url:"/about",templateUrl:"app/partials/about.html",controller:"About"}),e.otherwise("/about"),o.html5Mode(!0)})).run(["$rootScope","$state","$stateParams","$location","$window","$anchorScroll"].concat(function(t,e,o,n){return t.$state=e,t.$stateParam=o,t.config_build=require("config.jsenv").BUILD,t.$on("$stateChangeSuccess",function(t,e){var o;return o=e.name,"undefined"!=typeof window&&null!==window&&"function"==typeof window.ga?window.ga("send","pageview",{page:n.$$path,title:o}):void 0})})).controller({AppCtrl:["$scope","$location","$rootScope","$sce"].concat(function(t,e){return t.$location=e,t.$watch("$location.path()",function(e){return e||(e="/"),t.activeNavId=e,t}),t.getClass=function(e){return t.activeNavId.substring(0,e.length===e)?"active":""}})}).controller({About:["$rootScope","$http","$scope","$mdSidenav","$interval"].concat(function(t,e,o,n){return t.activeTab="about",t.pdfUrl="/",o.toggleLeft=function(){return n("left").toggle()},t.pageProgress=0,t.slideProgress=5})}).controller({PDFPlayerCtrl:["$rootScope","$scope","$interval"].concat(function(t,e,o){var n;return n=15e3,e.$parent.onLoad=function(){return e.$parent.ready=!0},e.start=function(){return e.$parent.started=!0,t.pageProgress=0,o(function(){return $(".md-bar2").css({transition:"all "+n/1e3+"s linear"}),t.pageProgress=100},100,1),o(function(){return e.goNext(),t.slideProgress+=100/e.pageCount,$(".md-bar2").css({transition:""}),t.pageProgress=0,o(function(){return $(".md-bar2").css({transition:"all "+n/1e3+"s linear"}),t.pageProgress=100},100,1)},n,e.pageCount-1)}})}).controller({LeftCtrl:["$rootScope","$scope","$timeout","$interval","$mdSidenav","$log"].concat(function(t,e,o,n,r,a){return e.files=[{bytes:2772798,link:"https://dl.dropboxusercontent.com/1/view/2lv9585lhj8hnv0/ignite-od/au_Sandstorm-and-OpenDocument.pdf",name:"au_Sandstorm-and-OpenDocument.pdf",icon:"https://www.dropbox.com/static/images/icons64/page_white_acrobat.png"},{bytes:2270164,link:"https://dl.dropboxusercontent.com/1/view/nmoi7kfx3r2fynj/ignite-od/ianmakgill-what-happens-when-you-use-open-data-a-story-from-the-uk.pdf",name:"ianmakgill-what-happens-when-you-use-open-data-a-story-from-the-uk.pdf",icon:"https://www.dropbox.com/static/images/icons64/page_white_acrobat.png"}],e.trigger=function(e){return console.log(e),t.pdfUrl=e.link,t.hasPDF=!0},e.dropbox=function(){return Dropbox.choose({success:function(t){return console.log(JSON.stringify(t)),e.$apply(function(){return e.files=t})},linkType:"direct",multiselect:!0,extensions:[".pdf"]})},e.close=function(){return r("left").close().then(function(){return a.debug("close LEFT is done")}),t.activeTab="about"}})});