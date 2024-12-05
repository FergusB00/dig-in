import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select";

// Connects to data-controller="tom-select"
export default class extends Controller {
  static values = { options: Object }

  connect() {
    new TomSelect(
      this.element, {
      create: false
      }
    )
    console.dir(this.element.tomselect.options)
  }

  // autoInput(){
  //   console.log("triggering Tom Select event!");
  //   new TomSelect(
  //     this.element
  //   )
//  }
}
