import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["manualForm"];

  connect() {
  }
  toggle() {
    this.manualFormTarget.classList.toggle("d-none");
  }
}
