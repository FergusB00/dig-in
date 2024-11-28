import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ["icon"];
  connect() {
    console.log("hello from navbar controller!");
    console.log(this.element)
  }

  toggle() {
    if (this.iconTarget.classList.contains("fa-bars")) {
      this.iconTarget.classList.remove("fa-bars");
      this.iconTarget.classList.add("fa-times");
    } else {
      this.iconTarget.classList.remove("fa-times");
      this.iconTarget.classList.add("fa-bars");
    }
  }
}
