###
# Copyright (C) 2014-2017 Andrey Antukh <niwi@niwi.nz>
# Copyright (C) 2014-2017 Jesús Espino Garcia <jespinog@gmail.com>
# Copyright (C) 2014-2017 David Barragán Merino <bameda@dbarragan.com>
# Copyright (C) 2014-2017 Alejandro Alonso <alejandro.alonso@kaleidos.net>
# Copyright (C) 2014-2017 Juan Francisco Alcántara <juanfran.alcantara@kaleidos.net>
# Copyright (C) 2014-2017 Xavi Julian <xavier.julian@kaleidos.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# File: openid-auth.coffee
###

OpenIDLoginButtonDirective = ($window, $params, $location, $config, $events, $confirm,
	$auth, $navUrls, $loader) ->
	# Login or registar a user with his/her openid account.
	#
	# Example:
	#	 tg-openid-login-button()
	#
	# Requirements:
	#   - ...

	link = ($scope, $el, $attrs) ->
		AUTH_URL = $config.get("openidAuth", null)
		$scope.openid_name = $config.get("openidName", "openid-connect")
		loginOnSuccess = (response) ->
			if $params.next and $params.next != $navUrls.resolve("login")
				nextUrl = $params.next
			else
				nextUrl = $navUrls.resolve("home")

			$events.setupConnection()

			$location.search("next", null)
			$location.search("token", null)
			$location.search("state", null)
			$location.search("code", null)
			$location.path(nextUrl)

		redirectURL = () -> $location.absUrl().split('?')[0]
		loginOnError = (response) ->
			$location.search("state", null)
			$location.search("code", null)
			$loader.pageLoaded()

			if response.data._error_message
				$confirm.notify("light-error", response.data._error_message )
			else
				$confirm.notify("light-error", "Our Oompa Loompas have not been able to get your credentials from OpenID.") #TODO: i18n

		loginWithOpenIDAccount = ->
			type = $params.state
			code = $params.code
			token = $params.token
			accessToken = $params.access_token
			return if not (code) && not(accessToken)
			$loader.start(true)

			if code
				data = {code: code, url:redirectURL()}
				$auth.login(data, "openid").then(loginOnSuccess, loginOnError)
			else
				data = {access_token: accessToken, url:redirectURL()}
				$auth.login(data, "openid").then(loginOnSuccess, loginOnError)

		loginWithOpenIDAccount()


		$el.on "click", ".button-auth", (event) ->
			console.log(redirectURL());
			redirectToUri = redirectURL();
			url = "#{AUTH_URL}?redirect_uri=#{redirectToUri}&client_id=taiga&response_type=code"
			window.location.href = url

		$scope.$on "$destroy", ->
			$el.off()

	return {
		link: link
		restrict: "EA"
		template: ""
	}

module = angular.module('taigaContrib.openidAuth', [])
module.directive("tgOpenidLoginButton", ["$window", '$routeParams', "$tgLocation", "$tgConfig", "$tgEvents",
	"$tgConfirm", "$tgAuth", "$tgNavUrls", "tgLoader",
	OpenIDLoginButtonDirective])
