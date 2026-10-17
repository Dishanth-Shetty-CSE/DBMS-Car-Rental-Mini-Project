/**
 * Car Rental System - Vehicle Data & Image Catalog Helper
 * Maps database car models to high-definition imagery and real-world specs
 */

const CAR_CATALOG = {
    "Honda City": {
        category: "Executive Sedan",
        image: "https://images.unsplash.com/photo-1590362891991-f776e747a588?auto=format&fit=crop&w=800&q=80",
        fallbackImage: "Resources/Luxury Sedan.jpg",
        transmission: "Automatic",
        fuel: "Petrol",
        seats: 5,
        mileage: "18.4 km/l",
        dailyRate: 2200,
        rating: 4.9,
        trips: 142
    },
    "Hyundai i20": {
        category: "Premium Hatchback",
        image: "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=800&q=80",
        fallbackImage: "Resources/Luxury Sedan.jpg",
        transmission: "Manual",
        fuel: "Petrol",
        seats: 5,
        mileage: "20.2 km/l",
        dailyRate: 1600,
        rating: 4.8,
        trips: 98
    },
    "Maruti Swift": {
        category: "Compact Hatchback",
        image: "https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?auto=format&fit=crop&w=800&q=80",
        fallbackImage: "Resources/Luxury Sedan.jpg",
        transmission: "Manual",
        fuel: "Petrol",
        seats: 5,
        mileage: "23.2 km/l",
        dailyRate: 1400,
        rating: 4.7,
        trips: 215
    },
    "Toyota Innova": {
        category: "Premium MPV / 7-Seater",
        image: "https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=800&q=80",
        fallbackImage: "Resources/Premium SUV.jpg",
        transmission: "Manual",
        fuel: "Diesel",
        seats: 7,
        mileage: "14.5 km/l",
        dailyRate: 3400,
        rating: 4.9,
        trips: 310
    },
    "Tata Nexon": {
        category: "Compact SUV",
        image: "https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?auto=format&fit=crop&w=800&q=80",
        fallbackImage: "Resources/Premium SUV.jpg",
        transmission: "Automatic",
        fuel: "Diesel",
        seats: 5,
        mileage: "17.5 km/l",
        dailyRate: 2500,
        rating: 4.8,
        trips: 180
    },
    "Mahindra XUV500": {
        category: "Full Size SUV",
        image: "https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=800&q=80",
        fallbackImage: "Resources/Premium SUV.jpg",
        transmission: "Automatic",
        fuel: "Diesel",
        seats: 7,
        mileage: "15.1 km/l",
        dailyRate: 3100,
        rating: 4.8,
        trips: 165
    },
    "Ford EcoSport": {
        category: "Urban Compact SUV",
        image: "https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=800&q=80",
        fallbackImage: "Resources/Premium SUV.jpg",
        transmission: "Manual",
        fuel: "Petrol",
        seats: 5,
        mileage: "16.8 km/l",
        dailyRate: 2100,
        rating: 4.7,
        trips: 120
    },
    "Renault Kwid": {
        category: "City Hatchback",
        image: "https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?auto=format&fit=crop&w=800&q=80",
        fallbackImage: "Resources/Luxury Sedan.jpg",
        transmission: "Manual",
        fuel: "Petrol",
        seats: 5,
        mileage: "22.0 km/l",
        dailyRate: 1200,
        rating: 4.6,
        trips: 89
    },
    "Skoda Rapid": {
        category: "Comfort Sedan",
        image: "https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&w=800&q=80",
        fallbackImage: "Resources/Luxury Sedan.jpg",
        transmission: "Automatic",
        fuel: "Petrol",
        seats: 5,
        mileage: "17.2 km/l",
        dailyRate: 2300,
        rating: 4.8,
        trips: 135
    },
    "Kia Seltos": {
        category: "Modern Smart SUV",
        image: "https://images.unsplash.com/photo-1580273916550-e323be2ae537?auto=format&fit=crop&w=800&q=80",
        fallbackImage: "Resources/Premium SUV.jpg",
        transmission: "Automatic",
        fuel: "Petrol",
        seats: 5,
        mileage: "16.5 km/l",
        dailyRate: 2900,
        rating: 4.9,
        trips: 204
    }
};

/**
 * Returns complete vehicle metadata with graceful defaults for any custom or new car model
 */
function getCarDetails(modelName) {
    if (!modelName) {
        return {
            category: "Standard Vehicle",
            image: "Resources/Luxury Sedan.jpg",
            fallbackImage: "Resources/Luxury Sedan.jpg",
            transmission: "Automatic",
            fuel: "Petrol",
            seats: 5,
            mileage: "18.0 km/l",
            dailyRate: 2000,
            rating: 4.8,
            trips: 75
        };
    }
    
    // Direct match
    for (const key in CAR_CATALOG) {
        if (modelName.toLowerCase().includes(key.toLowerCase()) || key.toLowerCase().includes(modelName.toLowerCase())) {
            return CAR_CATALOG[key];
        }
    }
    
    // Type heuristic matching
    const lower = modelName.toLowerCase();
    if (lower.includes("suv") || lower.includes("innova") || lower.includes("xuv") || lower.includes("safari") || lower.includes("harrier") || lower.includes("creta")) {
        return {
            category: "Premium SUV",
            image: "Resources/Premium SUV.jpg",
            fallbackImage: "Resources/Premium SUV.jpg",
            transmission: "Automatic",
            fuel: "Diesel",
            seats: 7,
            mileage: "15.0 km/l",
            dailyRate: 3000,
            rating: 4.8,
            trips: 110
        };
    } else if (lower.includes("truck") || lower.includes("pickup") || lower.includes("isuzu")) {
        return {
            category: "Utility Pickup",
            image: "Resources/Pickup Truck.jpg",
            fallbackImage: "Resources/Pickup Truck.jpg",
            transmission: "Manual",
            fuel: "Diesel",
            seats: 5,
            mileage: "13.0 km/l",
            dailyRate: 2800,
            rating: 4.7,
            trips: 60
        };
    } else if (lower.includes("convertible") || lower.includes("bmw") || lower.includes("mercedes") || lower.includes("audi") || lower.includes("sports")) {
        return {
            category: "Sports Convertible",
            image: "Resources/Sports Convertible.jpg",
            fallbackImage: "Resources/Sports Convertible.jpg",
            transmission: "Automatic",
            fuel: "Petrol",
            seats: 4,
            mileage: "12.0 km/l",
            dailyRate: 5000,
            rating: 4.9,
            trips: 85
        };
    }
    
    return {
        category: "Executive Sedan",
        image: "Resources/Luxury Sedan.jpg",
        fallbackImage: "Resources/Luxury Sedan.jpg",
        transmission: "Automatic",
        fuel: "Petrol",
        seats: 5,
        mileage: "18.0 km/l",
        dailyRate: 2200,
        rating: 4.8,
        trips: 90
    };
}
