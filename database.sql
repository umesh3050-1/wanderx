CREATE DATABASE IF NOT EXISTS wanderx_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE wanderx_db;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS package_essentials;
DROP TABLE IF EXISTS package_exclusions;
DROP TABLE IF EXISTS package_inclusions;
DROP TABLE IF EXISTS package_itinerary;
DROP TABLE IF EXISTS package_departures;
DROP TABLE IF EXISTS packages;
DROP TABLE IF EXISTS travellers;
DROP TABLE IF EXISTS admins;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE admins (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    role VARCHAR(80) NOT NULL DEFAULT 'Travel Operations Lead',
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE travellers (
    traveller_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(25),
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE packages (
    package_id INT AUTO_INCREMENT PRIMARY KEY,
    package_code VARCHAR(40) NOT NULL UNIQUE,
    title VARCHAR(180) NOT NULL,
    location VARCHAR(150) NOT NULL,
    category VARCHAR(80) NOT NULL,
    duration VARCHAR(40) NOT NULL,
    description TEXT NOT NULL,
    overview TEXT,
    price_per_traveller DECIMAL(12,2) NOT NULL,
    group_size INT NOT NULL,
    rating DECIMAL(3,2) NOT NULL DEFAULT 4.50,
    image_url VARCHAR(255),
    featured TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE package_departures (
    departure_id INT AUTO_INCREMENT PRIMARY KEY,
    package_id INT NOT NULL,
    departure_date DATE NOT NULL,
    FOREIGN KEY (package_id) REFERENCES packages(package_id) ON DELETE CASCADE
);

CREATE TABLE package_itinerary (
    itinerary_id INT AUTO_INCREMENT PRIMARY KEY,
    package_id INT NOT NULL,
    day_number INT NOT NULL,
    day_title VARCHAR(120) NOT NULL,
    day_description TEXT NOT NULL,
    FOREIGN KEY (package_id) REFERENCES packages(package_id) ON DELETE CASCADE
);

CREATE TABLE package_inclusions (
    inclusion_id INT AUTO_INCREMENT PRIMARY KEY,
    package_id INT NOT NULL,
    inclusion_text VARCHAR(255) NOT NULL,
    FOREIGN KEY (package_id) REFERENCES packages(package_id) ON DELETE CASCADE
);

CREATE TABLE package_exclusions (
    exclusion_id INT AUTO_INCREMENT PRIMARY KEY,
    package_id INT NOT NULL,
    exclusion_text VARCHAR(255) NOT NULL,
    FOREIGN KEY (package_id) REFERENCES packages(package_id) ON DELETE CASCADE
);

CREATE TABLE package_essentials (
    essential_id INT AUTO_INCREMENT PRIMARY KEY,
    package_id INT NOT NULL,
    essential_text VARCHAR(255) NOT NULL,
    FOREIGN KEY (package_id) REFERENCES packages(package_id) ON DELETE CASCADE
);

CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_reference VARCHAR(30) NOT NULL UNIQUE,
    traveller_id INT NOT NULL,
    package_id INT NOT NULL,
    departure_date DATE NOT NULL,
    traveller_count INT NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    payment_method VARCHAR(60) NOT NULL,
    special_request VARCHAR(255),
    booking_status ENUM('Confirmed', 'Pending', 'Cancelled', 'Departed') NOT NULL DEFAULT 'Confirmed',
    cancelled_at TIMESTAMP NULL DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (traveller_id) REFERENCES travellers(traveller_id) ON DELETE CASCADE,
    FOREIGN KEY (package_id) REFERENCES packages(package_id) ON DELETE CASCADE
);

INSERT INTO admins (full_name, email, role, password_hash) VALUES
('WanderX Admin', 'wanderx@gmail.com', 'Travel Operations Lead', '$2y$10$replace_with_bcrypt_hash');

INSERT INTO travellers (full_name, email, phone, password_hash) VALUES
('Demo Traveller', 'traveller@wanderx.com', '+91 98765 43210', '$2y$10$replace_with_bcrypt_hash');

INSERT INTO packages
    (package_code, title, location, category, duration, description, overview, price_per_traveller, group_size, rating, image_url, featured)
VALUES
    ('pkg-bali-retreat', 'Bali Retreat Escape', 'Bali, Indonesia', 'Beach Retreat', '5D / 4N',
     'Boutique stays, beach club evenings, temple visits, and a relaxed island itinerary.',
     'A serene Bali escape designed around beachfront relaxation, cultural visits, and polished hospitality.',
     68500.00, 12, 4.80, 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=1200&q=80', 1),
    ('pkg-swiss-panorama', 'Swiss Alps Panorama', 'Switzerland', 'Scenic Rail', '8D / 7N',
     'A premium alpine route with rail passes, mountain viewpoints, and lakefront stays.',
     'A premium alpine circuit with scenic rail segments, lakefront stays, and postcard-perfect mountain viewpoints.',
     152000.00, 18, 4.90, 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80', 1),
    ('pkg-kerala-backwaters', 'Kerala Backwaters Journey', 'Kerala, India', 'Nature Escape', '6D / 5N',
     'Houseboat moments, spice trail visits, tea gardens, and a calm south India circuit.',
     'A calm south India package blending houseboat comfort, greenery, spice routes, and easy-paced sightseeing.',
     38900.00, 16, 4.70, 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=1200&q=80', 1),
    ('pkg-kyoto-trail', 'Kyoto Blossom Trail', 'Kyoto, Japan', 'Cultural Tour', '7D / 6N',
     'Shrines, district walks, culinary stops, and a carefully paced cultural itinerary.',
     'A culture-first route through Kyoto with heritage districts, cuisine, and slow travel moments.',
     126000.00, 14, 4.80, 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=1200&q=80', 0),
    ('pkg-dubai-luxe', 'Dubai City Luxe', 'Dubai, UAE', 'City Break', '4D / 3N',
     'Skyline icons, desert evening experiences, shopping districts, and premium transfers.',
     'A polished city break pairing iconic attractions with smooth premium transfers.',
     59900.00, 20, 4.60, 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=1200&q=80', 0),
    ('pkg-himalayan-loop', 'Himalayan Adventure Loop', 'Himachal Pradesh, India', 'Mountain Adventure', '7D / 6N',
     'Mountain stays, scenic transfers, local experiences, and a flexible adventure-friendly plan.',
     'An easy-to-book mountain route for travellers who want scenery, comfort, and soft adventure.',
     47200.00, 15, 4.70, 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1200&q=80', 0),
    ('pkg-santorini-glow', 'Santorini Glow Escape', 'Santorini, Greece', 'Island Luxury', '6D / 5N',
     'Cliffside suites, sunset cruises, curated dining, and a polished Mediterranean island itinerary.',
     'A signature island-luxury trip with romantic views and carefully paced premium experiences.',
     134000.00, 10, 4.90, 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?auto=format&fit=crop&w=1200&q=80', 1),
    ('pkg-singapore-skyline', 'Singapore Skyline Break', 'Singapore', 'Urban Discovery', '5D / 4N',
     'Marina views, curated city experiences, Sentosa highlights, and seamless premium transfers.',
     'A modern city package balancing attractions, waterfront stays, and efficient movement.',
     82500.00, 16, 4.70, 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?auto=format&fit=crop&w=1200&q=80', 0),
    ('pkg-rajasthan-royale', 'Rajasthan Royale Circuit', 'Jaipur, Jodhpur, Udaipur', 'Heritage Journey', '7D / 6N',
     'Palace stays, guided heritage walks, desert dining, and a richly layered cultural route.',
     'A heritage-heavy itinerary with palace stays, old-city walks, and premium regional experiences.',
     54800.00, 18, 4.80, 'https://images.unsplash.com/photo-1599661046827-dacde6976548?auto=format&fit=crop&w=1200&q=80', 0),
    ('pkg-maldives-blue', 'Maldives Blue Horizon', 'Maldives', 'Overwater Escape', '4D / 3N',
     'Overwater villa stays, lagoon dining, luxury speedboat transfers, and easy indulgent downtime.',
     'A short-format luxury island trip focused on comfort, private views, and resort ease.',
     118000.00, 8, 4.90, 'https://images.unsplash.com/photo-1573843981267-be1999ff37cd?auto=format&fit=crop&w=1200&q=80', 0),
    ('pkg-vietnam-coastline', 'Vietnam Coastline Discovery', 'Da Nang, Hoi An', 'Coastal Culture', '6D / 5N',
     'Beachfront stays, lantern-town evenings, culinary walks, and coastal day trips in one elegant route.',
     'A coastal culture package blending beachside comfort with old-town energy and food-led exploration.',
     71200.00, 14, 4.70, 'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1200&q=80', 0);

INSERT INTO package_departures (package_id, departure_date) VALUES
    (1, '2026-04-18'), (1, '2026-05-09'), (1, '2026-06-13'),
    (2, '2026-04-24'), (2, '2026-05-22'), (2, '2026-06-19'),
    (3, '2026-04-11'), (3, '2026-05-02'), (3, '2026-06-06'),
    (4, '2026-04-16'), (4, '2026-05-14'), (4, '2026-06-18'),
    (5, '2026-04-20'), (5, '2026-05-18'), (5, '2026-06-22'),
    (6, '2026-04-27'), (6, '2026-05-25'), (6, '2026-06-29'),
    (7, '2026-05-08'), (7, '2026-06-12'), (7, '2026-07-10'),
    (8, '2026-05-03'), (8, '2026-06-07'), (8, '2026-07-05'),
    (9, '2026-05-15'), (9, '2026-06-19'), (9, '2026-07-17'),
    (10, '2026-05-20'), (10, '2026-06-24'), (10, '2026-07-22'),
    (11, '2026-05-11'), (11, '2026-06-15'), (11, '2026-07-13');

INSERT INTO package_itinerary (package_id, day_number, day_title, day_description) VALUES
    (1, 1, 'Arrival in Bali', 'Airport pickup, resort check-in, and a relaxed sunset orientation by the coast.'),
    (1, 2, 'Temple and coastal trail', 'Visit signature temples, cliff viewpoints, and curated local experiences.'),
    (1, 3, 'Beach club and leisure', 'Enjoy premium downtime with optional spa and water activity add-ons.'),
    (2, 1, 'Zurich arrival', 'Hotel transfer, lakeside orientation, and welcome briefing.'),
    (2, 2, 'Lucerne highlights', 'Scenic transfer, old-town walk, and waterfront free time.'),
    (2, 3, 'Interlaken journey', 'Rail route through alpine valleys and premium stay check-in.'),
    (3, 1, 'Cochin arrival', 'Meet and transfer to your first stay with a gentle evening schedule.'),
    (3, 2, 'Munnar route', 'Scenic drive through hills, waterfalls, and tea estate viewpoints.'),
    (3, 3, 'Backwater houseboat', 'Board the houseboat and enjoy a slow cruise with local cuisine.'),
    (4, 1, 'Kyoto arrival', 'Private transfer, boutique hotel check-in, and a Gion evening orientation walk.'),
    (4, 2, 'Heritage Kyoto', 'Explore shrines, bamboo trails, and tea experiences with guided support.'),
    (4, 3, 'Culture and cuisine', 'Flexible time for local markets, district cafés, and optional workshops.'),
    (5, 1, 'Dubai arrival', 'Hotel check-in, marina transfer, and a skyline evening with leisure time.'),
    (5, 2, 'City icons', 'Visit landmark districts, premium shopping zones, and signature city attractions.'),
    (5, 3, 'Desert evening', 'Head out for a curated desert session with dining and live entertainment.'),
    (6, 1, 'Mountain arrival', 'Transfer to your hill stay and settle in with a scenic evening schedule.'),
    (6, 2, 'Valley viewpoints', 'Visit mountain outlooks, village stops, and curated local experiences.'),
    (6, 3, 'Adventure day', 'Optional soft-adventure activities with coordinated transport support.'),
    (7, 1, 'Santorini arrival', 'Island transfer, cliffside check-in, and sunset lounge time.'),
    (7, 2, 'Caldera exploration', 'Discover iconic villages, panoramic viewpoints, and premium dining pockets.'),
    (7, 3, 'Cruise and leisure', 'Optional catamaran or a relaxed day around the resort and old-town lanes.'),
    (8, 1, 'Singapore arrival', 'Airport pickup, waterfront check-in, and a Marina district evening.'),
    (8, 2, 'Urban highlights', 'Gardens, skyline zones, and curated city experiences with easy transfers.'),
    (8, 3, 'Sentosa day', 'Spend a balanced day between attractions, beaches, and entertainment hubs.'),
    (9, 1, 'Jaipur arrival', 'Check in to your heritage stay and enjoy a relaxed local welcome evening.'),
    (9, 2, 'Fort and palace circuit', 'Visit heritage landmarks, bazaars, and architectural icons with a guide.'),
    (9, 3, 'Udaipur extension', 'Continue through royal cities with lakefront experiences and curated dinners.'),
    (10, 1, 'Maldives arrival', 'Speedboat transfer to the resort and leisure by the lagoon.'),
    (10, 2, 'Island leisure', 'Enjoy spa, snorkelling, and open resort time with optional premium add-ons.'),
    (10, 3, 'Sunset dining', 'A relaxed day ending with curated oceanfront dining and private views.'),
    (11, 1, 'Da Nang arrival', 'Airport reception, beachfront hotel check-in, and evening relaxation.'),
    (11, 2, 'Hoi An discovery', 'Explore lantern-town streets, markets, and local café stops with a guide.'),
    (11, 3, 'Coastal touring', 'A balanced sightseeing day with beach time and scenic regional excursions.');

INSERT INTO package_inclusions (package_id, inclusion_text) VALUES
    (1, '4-star resort stay'), (1, 'Daily breakfast'), (1, 'Private airport transfers'),
    (2, 'Rail travel between cities'), (2, '4-star alpine hotels'), (2, 'Mountain excursion pass'),
    (3, 'Hotel and houseboat stay'), (3, 'Breakfast and one cruise meal'), (3, 'AC transfers'),
    (4, 'Boutique hotel accommodation'), (4, 'Daily breakfast'), (4, 'Guided Kyoto city tour'),
    (5, '4-star hotel stay'), (5, 'Airport and city transfers'), (5, 'Desert experience with dinner'),
    (6, 'Mountain hotel stay'), (6, 'Breakfast and dinner'), (6, 'Sightseeing transfers'),
    (7, 'Cliffside premium stay'), (7, 'Daily breakfast'), (7, 'Sunset viewpoint experience'),
    (8, 'City hotel stay'), (8, 'Breakfast'), (8, 'Airport transfers and city touring'),
    (9, 'Heritage hotel accommodation'), (9, 'Breakfast'), (9, 'Intercity transport'),
    (10, 'Resort stay'), (10, 'Breakfast and dinner'), (10, 'Speedboat transfers'),
    (11, 'Beachfront hotel stay'), (11, 'Daily breakfast'), (11, 'Guided Hoi An excursion');

INSERT INTO package_exclusions (package_id, exclusion_text) VALUES
    (1, 'Flights'), (1, 'Travel insurance'), (1, 'Personal expenses'),
    (2, 'Visa fees'), (2, 'Lunch and dinner'), (2, 'Optional snow activities'),
    (3, 'Flights and rail tickets'), (3, 'Personal tips'), (3, 'Optional ayurveda sessions'),
    (4, 'International airfare'), (4, 'Visa and insurance'), (4, 'Lunch and dinner'),
    (5, 'Visa charges'), (5, 'Personal shopping'), (5, 'Optional attraction tickets'),
    (6, 'Adventure activity fees'), (6, 'Personal expenses'), (6, 'Travel insurance'),
    (7, 'Airfare'), (7, 'Visa fees'), (7, 'Optional cruise upgrades'),
    (8, 'Attraction tickets not mentioned'), (8, 'Lunch and dinner'), (8, 'Personal expenses'),
    (9, 'Monument tickets not listed'), (9, 'Personal shopping'), (9, 'Travel insurance'),
    (10, 'Airfare'), (10, 'Water sports not mentioned'), (10, 'Personal expenses'),
    (11, 'Visa fees'), (11, 'Lunch and dinner'), (11, 'Optional activities');

INSERT INTO package_essentials (package_id, essential_text) VALUES
    (1, 'Best for couples and leisure travellers'),
    (1, 'Ideal weather from April to June'),
    (2, 'Ideal for first-time Switzerland travellers'),
    (2, 'Cool-weather packing recommended'),
    (3, 'Suitable for families and first-time Kerala travellers'),
    (3, 'Relaxed pace throughout'),
    (4, 'Best for culture-focused travellers'),
    (4, 'Comfortable walking shoes recommended'),
    (5, 'Good for short premium city breaks'),
    (5, 'Light evening wear recommended'),
    (6, 'Best for relaxed mountain travellers'),
    (6, 'Layered clothing is recommended'),
    (7, 'Popular for honeymoon and luxury trips'),
    (7, 'Sun protection is recommended'),
    (8, 'Ideal for urban explorers and families'),
    (8, 'Carry light clothing for humid weather'),
    (9, 'Great for heritage and architecture lovers'),
    (9, 'Traditional attire is optional for dinner experiences'),
    (10, 'Best for luxury and celebration trips'),
    (10, 'Resort-focused packing works best'),
    (11, 'Ideal for beach and culture travellers'),
    (11, 'Carry breathable clothing and walking footwear');

INSERT INTO bookings
    (booking_reference, traveller_id, package_id, departure_date, traveller_count, total_amount, payment_method, special_request, booking_status, cancelled_at)
VALUES
    ('WX240501', 1, 1, '2026-05-09', 2, 137000.00, 'Card', 'Near-pool room preferred', 'Confirmed', NULL),
    ('WX240502', 1, 3, '2026-06-06', 3, 116700.00, 'UPI', 'Vegetarian meal preference', 'Cancelled', '2026-04-20 10:00:00');
