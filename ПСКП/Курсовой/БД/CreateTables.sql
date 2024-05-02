CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    role VARCHAR(255) NOT NULL
);

CREATE TABLE Games (
    game_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_date DATE NOT NULL,
    developer VARCHAR(255) NOT NULL,
    genre VARCHAR(255) NOT NULL
);

CREATE TABLE Ratings (
    rating_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    game_id INT,
    rating INT NOT NULL,
    comment VARCHAR(MAX) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (game_id) REFERENCES Games(game_id)
);

CREATE TABLE Wishlist (
    wishlist_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    game_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (game_id) REFERENCES Games(game_id)
);

CREATE TABLE Notifications (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    game_id INT,
    message VARCHAR(MAX) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (game_id) REFERENCES Games(game_id)
);

CREATE TABLE UserLists (
    list_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    title VARCHAR(255) NOT NULL,
    game_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (game_id) REFERENCES Games(game_id)
);

CREATE TABLE Feedback (
    feedback_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    message VARCHAR(MAX) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Recommendations (
    recommendation_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    game_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (game_id) REFERENCES Games(game_id)
);

CREATE TABLE Languages (
    language_id INT IDENTITY(1,1) PRIMARY KEY,
    language_name VARCHAR(255) NOT NULL
);

CREATE TABLE Localization (
    localization_id INT IDENTITY(1,1) PRIMARY KEY,
    game_id INT,
    language_id INT,
    localized_title VARCHAR(255) NOT NULL,
    localized_description VARCHAR(MAX) NOT NULL,
    FOREIGN KEY (game_id) REFERENCES Games(game_id),
    FOREIGN KEY (language_id) REFERENCES Languages(language_id)
);