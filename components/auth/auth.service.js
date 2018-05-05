(function () {

  'use strict';

  angular
    .module('app')
    .service('authService', authService);

  authService.$inject = ['$state', 'angularAuth0', 'authManager'];

  function authService($state, angularAuth0, authManager) {
    function login(username, password) {
      angularAuth0.authorize();
    }

    function handleParseHash() {
      angularAuth0.parseHash({
          _idTokenVerification: false
        },
        function (err, authResult) {
          if (err) {
            console.log(err);
          }
          if (authResult && authResult.idToken) {
            setUser(authResult);
          }
        });
    }

    function logout() {
      localStorage.removeItem('access_token');
      localStorage.removeItem('id_token');
    }

    function setUser(authResult) {
      localStorage.setItem('access_token', authResult.accessToken);
      localStorage.setItem('id_token', authResult.idToken);
    }

    function isAuthenticated() {
      return authManager.isAuthenticated();
    }

    var userProfile;

    function getProfile(cb) {
      var accessToken = localStorage.getItem('access_token');
      if (!accessToken) {
        throw new Error('Access Token must exist to fetch profile');
      }
      angularAuth0.client.userInfo(accessToken, function (err, profile) {
        if (profile) {
          setUserProfile(profile);
        }
        cb(err, profile);
      });
    }

    function setUserProfile(profile) {
      userProfile = profile;
    }

    function getCachedProfile() {
      return userProfile;
    }
    return {
      login: login,
      handleParseHash: handleParseHash,
      logout: logout,
      isAuthenticated: isAuthenticated,
      getProfile: getProfile,
      setUserProfile: setUserProfile,
      getCachedProfile: getCachedProfile
    }
  } // authService
})();