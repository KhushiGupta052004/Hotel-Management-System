-- Drop Database HotelManagementSystem;
CREATE DATABASE HotelManagementSystem;
USE HotelManagementSystem;


CREATE TABLE Guests (
    GuestID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    Email VARCHAR(100),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY AUTO_INCREMENT,
    RoomNumber VARCHAR(10) NOT NULL UNIQUE,
    RoomType VARCHAR(50),
    PricePerNight DECIMAL(10,2),
    Status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY AUTO_INCREMENT,
    GuestID INT NOT NULL,
    RoomID INT NOT NULL,
    CheckIn DATE,
    CheckOut DATE,
    TotalCost DECIMAL(10,2),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);

ALTER TABLE Guests
ADD Address VARCHAR(255),
ADD IDProofType VARCHAR(50),
ADD IDProofNumber VARCHAR(100),
ADD Preferences VARCHAR(255);

CREATE TABLE PaymentGateway (
    GatewayID INT PRIMARY KEY AUTO_INCREMENT,
    GatewayName VARCHAR(100) NOT NULL,
    ServiceFee DECIMAL(10,2) DEFAULT 0.00,
    Status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    ReservationID INT NOT NULL,
    Amount DECIMAL(10,2),
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PaymentMethod VARCHAR(50),
    GatewayID INT,
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID),
    FOREIGN KEY (GatewayID) REFERENCES PaymentGateway(GatewayID)
);

INSERT INTO PaymentGateway (GatewayName, ServiceFee)
VALUES ('Stripe', 1.50), ('PayPal', 2.00), ('Square', 1.20);

CREATE TABLE SpaServices (
    SpaServiceID INT PRIMARY KEY AUTO_INCREMENT,
    ServiceName VARCHAR(100),
    DurationMinutes INT,
    Price DECIMAL(10,2)
);

CREATE TABLE SpaReservations (
    SpaReservationID INT PRIMARY KEY AUTO_INCREMENT,
    GuestID INT,
    SpaServiceID INT,
    ReservationDate DATE,
    ReservationTime TIME,
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID),
    FOREIGN KEY (SpaServiceID) REFERENCES SpaServices(SpaServiceID)
);

CREATE TABLE MenuItems (
    ItemID INT PRIMARY KEY AUTO_INCREMENT,
    ItemName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE RestaurantOrders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    GuestID INT,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID)
);

CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ItemID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES RestaurantOrders(OrderID),
    FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID)
);

CREATE TABLE PoolReservations (
    PoolReservationID INT PRIMARY KEY AUTO_INCREMENT,
    GuestID INT,
    ReservationDate DATE,
    StartTime TIME,
    EndTime TIME,
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID)
);
CREATE TABLE GymMemberships (
    MembershipID INT PRIMARY KEY AUTO_INCREMENT,
    GuestID INT,
    MembershipType VARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID)
);


CREATE TABLE GymClasses (
    ClassID INT PRIMARY KEY AUTO_INCREMENT,
    ClassName VARCHAR(100),
    Instructor VARCHAR(100),
    ClassTime TIME,
    Price DECIMAL(10,2)
);


CREATE TABLE GymClassBookings (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    GuestID INT,
    ClassID INT,
    BookingDate DATE,
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID),
    FOREIGN KEY (ClassID) REFERENCES GymClasses(ClassID)
);
CREATE TABLE CabDrivers (
    DriverID INT PRIMARY KEY AUTO_INCREMENT,
    DriverName VARCHAR(100),
    Phone VARCHAR(20),
    CarModel VARCHAR(50),
    CarNumber VARCHAR(20)
);

CREATE TABLE CabBookings (
    CabBookingID INT PRIMARY KEY AUTO_INCREMENT,
    GuestID INT,
    DriverID INT,
    PickupLocation VARCHAR(255),
    DropLocation VARCHAR(255),
    PickupTime DATETIME,
    Cost DECIMAL(10,2),
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID),
    FOREIGN KEY (DriverID) REFERENCES CabDrivers(DriverID)
);

---
## 👤 Guest and Room Data

-- Inserting sample data into Guests
INSERT INTO Guests (FullName, Phone, Email, Address, IDProofType, IDProofNumber, Preferences)
VALUES
('Alice Johnson', '555-0101', 'alice.j@example.com', '123 Ocean Dr, Miami', 'Passport', 'A1234567', 'Non-smoking, high floor'),
('Bob Smith', '555-0102', 'bob.s@testmail.com', '45 North St, Chicago', 'Driving License', 'DL987654', 'Extra towels, late check-out'),
('Charlie Brown', '555-0103', 'c.brown@web.de', '78 Pine Ln, Houston', 'Voter ID', 'VOT34567', 'Near elevator'),
('Diana Prince', '555-0104', 'diana.p@outlook.com', '90 West Ave, London', 'Passport', 'PZ112233', 'Room with a view'),
('Ethan Hunt', '555-0105', 'e.hunt@agent.net', '20 Mission Rd, LA', 'Driving License', 'MIA007007', 'Quiet room, firm mattress');

-- Inserting sample data into Rooms
INSERT INTO Rooms (RoomNumber, RoomType, PricePerNight, Status)
VALUES
('101', 'Standard Single', 120.00, 'Occupied'),
('205', 'Deluxe Double', 250.00, 'Available'),
('302', 'Executive Suite', 450.00, 'Available'),
('408', 'Standard Single', 120.00, 'Available'),
('510', 'Deluxe Double', 250.00, 'Occupied');

-- Inserting sample data into Reservations
-- Alice (GuestID 1) books Room 101 (RoomID 1)
INSERT INTO Reservations (GuestID, RoomID, CheckIn, CheckOut, TotalCost)
VALUES
(1, 1, '2025-11-20', '2025-11-25', 600.00), -- Alice's current stay
(2, 5, '2025-11-22', '2025-11-28', 1500.00), -- Bob's current stay
(3, 2, '2025-12-01', '2025-12-05', 1000.00), -- Charlie's future booking
(4, 3, '2025-11-25', '2025-11-27', 900.00), -- Diana's future booking
(5, 4, '2025-12-10', '2025-12-12', 240.00); -- Ethan's future booking


---
## 💳 Payment Data

-- Inserting sample data into Payments
-- Note: PaymentGateway table already has data ('Stripe', 'PayPal', 'Square') with IDs 1, 2, 3
INSERT INTO Payments (ReservationID, Amount, PaymentMethod, GatewayID)
VALUES
(1, 300.00, 'Credit Card', 1), -- Alice's partial payment via Stripe
(2, 1500.00, 'Debit Card', 2), -- Bob's full payment via PayPal
(3, 500.00, 'Bank Transfer', NULL), -- Charlie's deposit (Direct method, no gateway)
(1, 300.00, 'Credit Card', 1), -- Alice's final payment via Stripe
(4, 900.00, 'Credit Card', 3); -- Diana's full payment via Square

---
## 🧖 Spa and Pool Data

-- Inserting sample data into SpaServices
INSERT INTO SpaServices (ServiceName, DurationMinutes, Price)
VALUES
('Swedish Massage', 60, 150.00),
('Deep Tissue Massage', 90, 200.00),
('Aromatherapy Facial', 45, 120.00);

-- Inserting sample data into SpaReservations
INSERT INTO SpaReservations (GuestID, SpaServiceID, ReservationDate, ReservationTime)
VALUES
(1, 1, '2025-11-24', '15:00:00'), -- Alice books a Swedish Massage
(2, 2, '2025-11-23', '11:30:00'), -- Bob books a Deep Tissue Massage
(1, 3, '2025-11-25', '10:00:00'); -- Alice books a Facial

-- Inserting sample data into PoolReservations
INSERT INTO PoolReservations (GuestID, ReservationDate, StartTime, EndTime)
VALUES
(2, '2025-11-24', '09:00:00', '10:30:00'), -- Bob reserves the pool
(3, '2025-12-02', '16:00:00', '17:00:00'), -- Charlie reserves the pool
(4, '2025-11-26', '13:00:00', '14:00:00'); -- Diana reserves the pool

---
## 🍽️ Restaurant Data

-- Inserting sample data into MenuItems
INSERT INTO MenuItems (ItemName, Category, Price)
VALUES
('Grilled Salmon', 'Main Course', 35.00),
('Caesar Salad', 'Appetizer', 15.00),
('Tiramisu', 'Dessert', 12.00),
('Steak Frites', 'Main Course', 45.00);

-- Inserting sample data into RestaurantOrders
INSERT INTO RestaurantOrders (GuestID, TotalAmount)
VALUES
(1, 50.00), -- Alice's order
(2, 57.00), -- Bob's order
(1, 47.00); -- Alice's second order

-- Inserting sample data into OrderItems (linking orders to menu items)
INSERT INTO OrderItems (OrderID, ItemID, Quantity)
VALUES
(1, 2, 1), -- Order 1 (Alice): Caesar Salad (15)
(1, 1, 1), -- Order 1 (Alice): Grilled Salmon (35)
(2, 4, 1), -- Order 2 (Bob): Steak Frites (45)
(2, 3, 1), -- Order 2 (Bob): Tiramisu (12)
(3, 1, 1), -- Order 3 (Alice): Grilled Salmon (35)
(3, 3, 1); -- Order 3 (Alice): Tiramisu (12)


---
## 💪 Gym and Cab Services Data

-- Inserting sample data into GymMemberships
INSERT INTO GymMemberships (GuestID, MembershipType, StartDate, EndDate)
VALUES
(1, 'Weekly Pass', '2025-11-20', '2025-11-27'),
(2, 'Day Pass', '2025-11-23', '2025-11-23');

-- Inserting sample data into GymClasses
INSERT INTO GymClasses (ClassName, Instructor, ClassTime, Price)
VALUES
('Morning Yoga', 'Ms. Patel', '07:00:00', 15.00),
('Spin Cycle', 'Mr. Jensen', '18:00:00', 20.00),
('Water Aerobics', 'Ms. Chen', '10:00:00', 10.00);

-- Inserting sample data into GymClassBookings
INSERT INTO GymClassBookings (GuestID, ClassID, BookingDate)
VALUES
(1, 1, '2025-11-24'), -- Alice books Morning Yoga
(2, 2, '2025-11-23'), -- Bob books Spin Cycle
(1, 3, '2025-11-25'); -- Alice books Water Aerobics

-- Inserting sample data into CabDrivers
INSERT INTO CabDrivers (DriverName, Phone, CarModel, CarNumber)
VALUES
('Sam Wilson', '555-0201', 'Toyota Camry', 'AX9900'),
('Maria Lopez', '555-0202', 'Mercedes E-Class', 'ML7890'),
('Kenji Tanaka', '555-0203', 'Tesla Model 3', 'KT1010');

-- Inserting sample data into CabBookings
INSERT INTO CabBookings (GuestID, DriverID, PickupLocation, DropLocation, PickupTime, Cost)
VALUES
(1, 1, 'Hotel Lobby', 'Airport Terminal B', '2025-11-25 08:00:00', 55.00), -- Alice to Airport
(2, 2, 'Hotel Lobby', 'Downtown Museum', '2025-11-24 14:30:00', 25.00), -- Bob to Museum
(3, 3, 'Hotel Lobby', 'Train Station', '2025-12-05 07:30:00', 40.00); -- Charlie to Train Station