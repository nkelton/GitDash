import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap"
require('jquery')
require('../service_workers/service-worker')

Rails.start()
Turbolinks.start()
ActiveStorage.start()
