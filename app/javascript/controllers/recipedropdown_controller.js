import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="recipedropdown"
export default class extends Controller {
  static targets = ["content"]; // Define "content" as a target

  connect() {
    this.isOpen = false;
  }

  toggle(event) {
    event.preventDefault();

    this.isOpen = !this.isOpen;
    this.contentTarget.style.display = this.isOpen ? "block" : "none";

    const icon = event.currentTarget.querySelector("i");
    if (this.isOpen) {
      icon.classList.remove("fa-chevron-down");
      icon.classList.add("fa-chevron-up");
    } else {
      icon.classList.remove("fa-chevron-up");
      icon.classList.add("fa-chevron-down");
    }
  }
}
