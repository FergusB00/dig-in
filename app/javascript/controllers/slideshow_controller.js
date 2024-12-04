import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="slideshow"
export default class extends Controller {
  connect() {
  }

  import { Controller } from "@hotwired/stimulus";

//   // New stimulus code to implement slideshow in the home still (JM 0412)
//   export default class extends Controller {
//     static targets = ["image"];

//     connect() {
//       this.images = [
//         "<%= asset_path('food1.jpg') %>",
//         "<%= asset_path('food2.jpg.jpg') %>",
//         "<%= asset_path('food3.jpg.jpg') %>"
//       ];
//       this.index = 0;
//       this.startSlideshow();
//     }

//     startSlideshow() {
//       this.showImage();
//       setInterval(() => this.nextImage(), 3000);
//     }

//     showImage() {
//       this.imageTarget.src = this.images[this.index];
//       this.imageTarget.classList.add('fade');
//       setTimeout(() => this.imageTarget.classList.remove('fade'), 500);
//     }

//     nextImage() {
//       this.index = (this.index + 1) % this.images.length;
//       this.showImage();
//     }
// }
