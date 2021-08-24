import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import 'jquery'
import 'bootstrap'
import 'bootstrap-select'
require('../service_workers/service-worker')

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// initialize bootstrap-select
$(document).on('turbolinks:load', function() {
  $('.selectpicker').selectpicker('refresh');
});