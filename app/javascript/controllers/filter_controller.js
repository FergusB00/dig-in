import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {
  connect() {
    const params = window.location.href.split("?")[1];
    console.log(params)
    if (params != undefined) {
      const results = params.split("&")
      results.forEach((param) => {
        if (param.startsWith("query=")) {
          this.element.value = param.split("=")[1];
        }
      })
    }
  }
}
