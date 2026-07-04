/* ==========================================================================
   GOPLAY LANDING PAGE JAVASCRIPT
   ========================================================================== */

document.addEventListener('DOMContentLoaded', () => {

    // 1. Sticky Navigation Header
    const header = document.querySelector('.header');
    const handleScroll = () => {
        if (window.scrollY > 50) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
        }
    };
    window.addEventListener('scroll', handleScroll);
    handleScroll(); // Run once on load in case page is already scrolled

    // 2. Mobile Drawer Navigation
    const menuToggle = document.getElementById('menu-toggle');
    const mobileDrawer = document.getElementById('mobile-drawer');
    const drawerClose = document.getElementById('drawer-close');
    const drawerOverlay = document.getElementById('drawer-overlay');
    const drawerLinks = document.querySelectorAll('.drawer-link');

    const openDrawer = () => {
        mobileDrawer.classList.add('open');
        drawerOverlay.classList.add('active');
        document.body.style.overflow = 'hidden'; // Lock body scroll
    };

    const closeDrawer = () => {
        mobileDrawer.classList.remove('open');
        drawerOverlay.classList.remove('active');
        document.body.style.overflow = 'auto'; // Unlock body scroll
    };

    if (menuToggle) menuToggle.addEventListener('click', openDrawer);
    if (drawerClose) drawerClose.addEventListener('click', closeDrawer);
    if (drawerOverlay) drawerOverlay.addEventListener('click', closeDrawer);
    drawerLinks.forEach(link => link.addEventListener('click', closeDrawer));

    // 3. Scroll Reveal Animations (Intersection Observer)
    const revealElements = document.querySelectorAll('.reveal');
    const revealOptions = {
        threshold: 0.15,
        rootMargin: '0px 0px -50px 0px'
    };

    const revealObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
                observer.unobserve(entry.target); // Animates only once
            }
        });
    }, revealOptions);

    revealElements.forEach(element => {
        revealObserver.observe(element);
    });

    // 4. Statistics Counters Animation
    const statsSection = document.querySelector('.hero-stats');
    const statNumbers = document.querySelectorAll('.stat-number');
    const statPercent = document.querySelector('.stat-number-percent');
    const statHours = document.querySelector('.stat-number-hours');
    let countersStarted = false;

    const runCounters = () => {
        if (countersStarted) return;
        countersStarted = true;

        // Animate Happy Streamers (Counts from 0 to 1.0 M)
        const targetStreamers = parseInt(statNumbers[0].getAttribute('data-target'));
        let countStreamers = 0;
        const durationStreamers = 2000; // ms
        const incrementStreamers = targetStreamers / (durationStreamers / 30);
        
        const timerStreamers = setInterval(() => {
            countStreamers += incrementStreamers;
            if (countStreamers >= targetStreamers) {
                statNumbers[0].textContent = '1M+';
                clearInterval(timerStreamers);
            } else {
                statNumbers[0].textContent = (countStreamers / 1000000).toFixed(1) + 'M+';
            }
        }, 30);

        // Animate Buffering Free Rate (Counts from 0 to 99%)
        const targetPercent = parseInt(statPercent.getAttribute('data-target'));
        let countPercent = 0;
        const timerPercent = setInterval(() => {
            countPercent += 1;
            if (countPercent >= targetPercent) {
                statPercent.textContent = targetPercent;
                clearInterval(timerPercent);
            } else {
                statPercent.textContent = countPercent;
            }
        }, 20);

        // Animate Hours Live (Counts from 0 to 24/7)
        const targetHours = parseInt(statHours.getAttribute('data-target'));
        let countHours = 0;
        const timerHours = setInterval(() => {
            countHours += 1;
            if (countHours >= targetHours) {
                statHours.textContent = targetHours;
                clearInterval(timerHours);
            } else {
                statHours.textContent = countHours;
            }
        }, 60);
    };

    // Trigger counters when stats section is visible
    if (statsSection) {
        const statsObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    runCounters();
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.5 });
        statsObserver.observe(statsSection);
    }

    // 5. Interactive Phone Showcase Switcher
    const tabButtons = document.querySelectorAll('.tab-btn');
    const showcaseImage = document.getElementById('showcase-image');
    const detailCards = document.querySelectorAll('.showcase-card');

    // Mapping tags to file names
    const screenshotPaths = {
        dash: 'App Screen/Screenshot_2026-07-04-11-36-54-980_com.goplay.goplay-portrait(1).png',
        player: 'App Screen/Screenshot_2026-07-04-11-54-44-173_com.goplay.goplay-portrait.png',
        zoom: 'App Screen/Screenshot_2026-07-04-02-50-01-478_com.goplay.goplay-portrait.png',
        schedule: 'App Screen/Screenshot_2026-07-04-11-37-25-113_com.goplay.goplay-portrait.png'
    };

    tabButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            const target = btn.getAttribute('data-target');

            // 1. Update Active Buttons
            tabButtons.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            // 2. Change Phone Screen with Fade Animation
            showcaseImage.classList.remove('fade-in-image');
            // Trigger reflow to restart animation
            void showcaseImage.offsetWidth; 
            showcaseImage.setAttribute('src', screenshotPaths[target]);
            showcaseImage.classList.add('fade-in-image');

            // 3. Update Detail Description Card
            detailCards.forEach(card => card.classList.remove('active'));
            const activeCard = document.getElementById(`detail-${target}`);
            if (activeCard) activeCard.classList.add('active');
        });
    });

    // 6. Frequently Asked Questions Accordion
    const faqQuestions = document.querySelectorAll('.faq-question');

    faqQuestions.forEach(question => {
        question.addEventListener('click', () => {
            const parentItem = question.closest('.faq-item');
            const isOpen = parentItem.classList.contains('open');

            // Close all items first (accordion functionality)
            document.querySelectorAll('.faq-item').forEach(item => {
                item.classList.remove('open');
            });

            // Toggle open on clicked item if it was closed
            if (!isOpen) {
                parentItem.classList.add('open');
            }
        });
    });

    // 7. Interactive Form Submissions Mock Feedbacks
    const newsletterForm = document.getElementById('newsletter-form');
    if (newsletterForm) {
        newsletterForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const emailInput = newsletterForm.querySelector('input');
            const emailValue = emailInput.value;
            
            // Show custom mini alert
            alert(`Thank you for subscribing! Matches updates will be sent to ${emailValue}`);
            emailInput.value = '';
        });
    }

    // 8. Custom APK Download Counter Mock Trigger
    const downloadApkButtons = document.querySelectorAll('a[href="#download"]');
    downloadApkButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            // Smooth scroll to the download section
            const targetSection = document.getElementById('download');
            if (targetSection) {
                e.preventDefault();
                targetSection.scrollIntoView({ behavior: 'smooth' });
            }
        });
    });

    // 9. Extra UI Interactive Touch: Add 3D Tilt Effect on Angled Mockup
    const tiltCard = document.querySelector('.tilt-card');
    if (tiltCard) {
        tiltCard.addEventListener('mousemove', (e) => {
            const cardRect = tiltCard.getBoundingClientRect();
            const cardWidth = cardRect.width;
            const cardHeight = cardRect.height;
            
            // Relative cursor positions inside card (from -0.5 to 0.5)
            const cursorX = (e.clientX - cardRect.left) / cardWidth - 0.5;
            const cursorY = (e.clientY - cardRect.top) / cardHeight - 0.5;
            
            // Rotate card (maximum 15deg)
            const rotateX = cursorY * -15; 
            const rotateY = cursorX * 15;
            
            tiltCard.style.transform = `rotateY(${rotateY - 18}deg) rotateX(${rotateX + 12}deg) rotateZ(4deg) scale(1.02)`;
        });
        
        tiltCard.addEventListener('mouseleave', () => {
            // Restore original state
            tiltCard.style.transform = `rotateY(-18deg) rotateX(12deg) rotateZ(4deg) scale(1)`;
        });
    }
});
