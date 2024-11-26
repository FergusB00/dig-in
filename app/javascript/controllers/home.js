document.addEventListener('DOMContentLoaded', function () {
  // List of image filenames in the 'images/meals' folder
  const imageFilenames = [
    'meal1.jpg', 'meal2.jpg', 'meal3.jpg', 'meal4.jpg', 'meal5.jpg',
    'meal6.jpg', 'meal7.jpg', 'meal8.jpg', 'meal9.jpg', 'meal10.jpg'
  ];

  // Get the container for carousel items
  const carouselContainer = document.getElementById('carouselItemsContainer');

  // Loop through the filenames and create the carousel items
  imageFilenames.forEach((filename, index) => {
    const isActive = index === 0 ? 'active' : '';  // Set the first item as active

    // Create the carousel item HTML
    const carouselItemHTML = `
      <div class="carousel-item ${isActive}">
        <img src="images/meals/${filename}" class="d-block w-100" alt="Meal ${index + 1}">
      </div>
    `;

    // Append the carousel item to the container
    carouselContainer.innerHTML += carouselItemHTML;
  });

  // Initializes the Bootstrap carousel with 2-second interval
  const myCarousel = new bootstrap.Carousel('#mealCarousel', {
    interval: 2000, // Set interval to 2000 milliseconds (2 seconds)
    ride: 'carousel'
  });
});
