# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


# The main contoller logic
@ng_app.controller("MainCtrl", ['$scope', '$interval', '$window', '$timeout', '$mdDialog', 'Upload',
($scope, $interval, $window, $timeout, $mdDialog, Upload)->
  $scope.$watch 'files', ->
    console.log $scope.files
    return unless $scope.files
    $scope.print_file = $scope.files[0]
  

  $scope.reset = (retry)->
    $scope.error = false
    $scope.finished = false
    $scope.uploading = false
    $scope.upload_progress = 0
    return if retry
    $scope.print_file = undefined
    $scope.job = {}

  $scope.upload = (files) ->
    if $scope.can_print()
      $scope.uploading = true
      Upload.upload(
        url: 'http://127.0.0.1:3000/main/upload'
        data:
          job: $scope.job
          file: $scope.print_file
        ).then(
          (resp) ->
            $timeout ->
              console.log resp.data
              $scope.finished = true
              if resp.data.status != 'ok'
                $scope.error = true
              # $scope.log = 'file: ' + resp.config.data.file.name + ', Response: ' + JSON.stringify(resp.data) + '\n' + $scope.log
          ,
          (err)->
            $timeout ->
              console.log err
          ,
          (evt) ->
            progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
            console.log progressPercentage
            $scope.upload_progress = progressPercentage
        )
          # $scope.log = 'progress: ' + progressPercentage + '% ' + evt.config.data.file.name + '\n' + $scope.log

  $scope.showPrerenderedDialog = (ev) ->
    $mdDialog.show
      # controller: DialogController
      contentElement: '#myDialog'
      parent: angular.element(document.body)
      targetEvent: ev
      clickOutsideToClose: true
    return

  $scope.can_print = ()->
    $scope.job.target != undefined &&
    $scope.job_form.$valid &&
    $scope.print_file

  $scope.reset()
])
