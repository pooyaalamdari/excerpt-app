// app/javascript/navbar_toggle.js

document.addEventListener('turbo:load', () => {
  const toggler = document.getElementById('navbarToggler');
  const navbarLinks = document.getElementById('navbarLinks');

  // برای اشکال‌زدایی: بررسی کنید که آیا عناصر پیدا می‌شوند
  console.log('Navbar Toggler:', toggler);
  console.log('Navbar Links:', navbarLinks);

  if (toggler && navbarLinks) {
    toggler.addEventListener('click', () => {
      navbarLinks.classList.toggle('show');
      // برای اشکال‌زدایی: وضعیت کلاس را پس از کلیک بررسی کنید
      console.log('Navbar Links class list after toggle:', navbarLinks.classList);
    });

    // Close navbar when a link is clicked (optional, but good UX)
    navbarLinks.querySelectorAll('a').forEach(link => {
      link.addEventListener('click', () => {
        if (navbarLinks.classList.contains('show')) {
          navbarLinks.classList.remove('show');
        }
      });
    });
  }
});
