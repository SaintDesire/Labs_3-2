use GamerHub;

-- Таблица пользователей
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY,
    Username VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Password VARCHAR(255) NOT NULL, -- Здесь предполагается, что пароль уже захеширован
    Role VARCHAR(50) NOT NULL
);

-- Таблица игр
CREATE TABLE Games (
    GameID INT PRIMARY KEY IDENTITY,
    Title VARCHAR(255) NOT NULL,
    Description TEXT,
    Genre VARCHAR(100),
    Platform VARCHAR(100),
    Release_date DATE,
    Rating DECIMAL(3, 1)
);

-- Таблица отзывов
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY IDENTITY,
    GameID INT FOREIGN KEY REFERENCES Games(GameID),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    Rating INT,
    Comment TEXT,
    CONSTRAINT FK_Game_User_Review FOREIGN KEY (GameID, UserID) REFERENCES Wishlist(GameID, UserID)
);

-- Таблица списка желаемых игр
CREATE TABLE Wishlist (
    WishlistID INT PRIMARY KEY IDENTITY,
    GameID INT FOREIGN KEY REFERENCES Games(GameID),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    CONSTRAINT UC_Wishlist UNIQUE (GameID, UserID)
);

-- Таблица уведомлений
CREATE TABLE Notifications (
    NotificationID INT PRIMARY KEY IDENTITY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    Message TEXT,
    Timestamp DATETIME
);
