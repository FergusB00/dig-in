// SLIDESHOW EXPERIMENT

document.addEventListener("DOMContentLoaded", function() {
  const imagePaths = [
    "<%= asset_path('meals/food1.jpg') %>",
    "<%= asset_path('meals/food2.jpg') %>",
    "<%= asset_path('meals/food3.jpg') %>",
    "<%= asset_path('meals/food4.jpg') %>",
    "<%= asset_path('meals/food5.jpg') %>",
    "<%= asset_path('meals/food6.jpg') %>",
    "<%= asset_path('meals/food7.jpg') %>",
    "<%= asset_path('meals/food8.jpg') %>"
  ];

  let currentIndex = 0;
  const slideshowImage = document.getElementById("slideshow-image");
  const interval = 3000; // Time in milliseconds for each image (e.g., 3000ms = 3 seconds)

  function switchImage() {
    currentIndex = (currentIndex + 1) % imagePaths.length; // Cycle through images
    slideshowImage.src = imagePaths[currentIndex]; // Update image source
    slideshowImage.classList.add("fade"); // Add fade effect
  }

  // Set the interval to switch images
  setInterval(switchImage, interval);

  // Optional: Add CSS for smooth fade-in/out
  slideshowImage.addEventListener("load", () => {
    setTimeout(() => slideshowImage.classList.remove("fade"), 500); // Remove fade class after transition
  });
});

// document.addEventListener('DOMContentLoaded', function () {
//   // List of image filenames in the 'images/meals' folder
//   const imageFilenames = [
//     'meal1.jpg', 'meal2.jpg', 'meal3.jpg', 'meal4.jpg', 'meal5.jpg',
//     'meal6.jpg', 'meal7.jpg', 'meal8.jpg', 'meal9.jpg', 'meal10.jpg'
//   ];

//   // Get the container for carousel items
//   const carouselContainer = document.getElementById('carouselItemsContainer');

//   // Loop through the filenames and create the carousel items
//   imageFilenames.forEach((filename, index) => {
//     const isActive = index === 0 ? 'active' : '';  // Set the first item as active

//     // Create the carousel item HTML
//     const carouselItemHTML = `
//       <div class="carousel-item ${isActive}">
//         <img src="images/meals/${filename}" class="d-block w-100" alt="Meal ${index + 1}">
//       </div>
//     `;

//     // Append the carousel item to the container
//     carouselContainer.innerHTML += carouselItemHTML;
//   });

//   // Initializes the Bootstrap carousel with 2-second interval
//   const myCarousel = new bootstrap.Carousel('#mealCarousel', {
//     interval: 2000, // Set interval to 2000 milliseconds (2 seconds)
//     ride: 'carousel'
//   });
// });
