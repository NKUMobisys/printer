@ng_app = angular.module(
	'printer',
	[
		'ngAnimate',
		'ngMaterial',
		'ngMdIcons',
		'ngResource',
		'ngMessages',
		'ngFileUpload',
		# 'angular.validators',
	]
)
.config ["$httpProvider", '$resourceProvider', (provider, resource)->
	provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
	resource.defaults.stripTrailingSlashes = false;
]
.run ['$rootScope', ($rootScope)->
	$rootScope._gen_date = (date)->
		new Date(date)
	$rootScope.Routes = window.Routes
]
.filter 'bytes', ->
  (bytes, precision) ->
    if isNaN(parseFloat(bytes)) or !isFinite(bytes)
      return '-'
    if typeof precision == 'undefined'
      precision = 1
    units = [
      'bytes'
      'kB'
      'MB'
      'GB'
      'TB'
      'PB'
    ]
    number = Math.floor(Math.log(bytes) / Math.log(1024))
    (bytes / 1024 ** Math.floor(number)).toFixed(precision) + ' ' + units[number]

# http://kurtfunai.com/2014/08/angularjs-and-turbolinks.html
# https://docs.angularjs.org/error/ng/btstrpd
# http://stackoverflow.com/questions/36110789/rails-5-how-to-use-document-ready-with-turbo-links
$(document).on('turbolinks:load', ->
	# below can not use because of turbolinks's bug
	# unless (document.documentElement.hasAttribute("data-turbolinks-preview"))
	unless ($('body').attr("ng-bootstraped")) # Temporarily solution
		console.log 'not cached show'
		angular.bootstrap(document.body, ['printer'])
		$('body').attr("ng-bootstraped", true)
	else
		console.log 'cached show'

)

$(document).on('turbolinks:before-cache', ->
	# angular.element("body").scope().$broadcast("$destroy")
)